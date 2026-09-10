import React from "@rbxts/react";
import { BreakPointElementProps, ResponsiveCssSize, ResponsiveValue, ScaleSize } from "../../Interfaces/";
import { CleanThemeContext } from "../../Contexts";
import { BreakpointHelper, SizeHelper, SpacingHelper } from "../../Helpers/";

export interface GridProps extends BreakPointElementProps {
    cols?: ResponsiveValue<number>;
    gap?: ScaleSize | "None";
    // Grid's own outer width, same CSS-style width every other component
    // accepts (a number, "50%", "300px", etc). Defaults to filling its
    // parent, matching every prior usage that relied on that. Height is
    // never user-settable - it's always driven by the measure/lock cycle.
    width?: ResponsiveCssSize;
    children?: React.ReactNode;
    name?: string;
}

// How many real engine frames a cell keeps re-reporting its own AbsoluteSize
// for after a measure pass starts. See the effect below for why this is a
// fixed poll window rather than a "wait until it stops changing" check.
const SETTLE_POLL_FRAMES = 10;

interface GridCellProps {
    index: number;
    width: UDim;
    height: number;
    locked: boolean;
    // Identifies the current measure pass (derived from width/cols/gap/
    // childCount - see Grid's `measureKey`). Depending on it, not just
    // `locked`, is what makes a cell re-report once Grid's inputs change:
    // staleness is detected lazily by key comparison rather than through a
    // separate "reset" effect racing the cell's own report (see Grid for why
    // that race existed and why this avoids it).
    measureKey: string;
    onMeasured: (measureKey: string, index: number, height: number) => void;
    children?: React.ReactNode;
}

function GridCell(props: GridCellProps) {
    const measurementRef = React.useRef<Frame>();

    const reportMeasurement = React.useCallback(() => {
        const instance = measurementRef.current;
        if (instance !== undefined) props.onMeasured(props.measureKey, props.index, instance.AbsoluteSize.Y);
    }, [props.onMeasured, props.measureKey, props.index]);

    // Nested AutomaticSize content (e.g. this cell's frame auto-sizing to fit
    // a TextLabel that is itself auto-sizing to fit wrapped text) can take
    // several real engine frames - not one Lua resumption cycle - to reach
    // its final size, and there is no reliable signal for "done": a poll
    // that keeps reading the same not-yet-updated value is indistinguishable
    // from one that has genuinely settled. So instead of trying to detect
    // settling, just keep re-reporting every real frame for a fixed window;
    // Grid's own settle effect (see there) only ever commits once this
    // window's reports stop arriving, so it naturally waits out however long
    // this takes rather than racing it. The live `Change` binding below
    // keeps reporting indefinitely after this window too, for content that
    // keeps resizing beyond it.
    React.useEffect(() => {
        if (props.locked) return;

        let mounted = true;

        reportMeasurement();

        task.spawn(() => {
            for (let frame = 0; frame < SETTLE_POLL_FRAMES; frame++) {
                task.wait();
                if (!mounted) return;
                reportMeasurement();
            }
        });

        return () => {
            mounted = false;
        };
    }, [props.locked, props.measureKey, reportMeasurement]);

    return (
        <frame
            key="GridCell"
            ref={measurementRef}
            LayoutOrder={props.index}
            Size={new UDim2(props.width, new UDim(0, props.locked ? props.height : 0))}
            AutomaticSize={props.locked ? Enum.AutomaticSize.None : Enum.AutomaticSize.Y}
            BackgroundTransparency={1}
            ClipsDescendants={true}
            Change={props.locked ? undefined : { AbsoluteSize: reportMeasurement }}
        >
            {props.children}
        </frame>
    );
}

// A measure pass's collected cell heights, tagged with the `measureKey` they
// were collected under. Tagging (rather than clearing the map via a separate
// effect whenever the key changes) is what avoids the race that used to exist
// here: a cell's own report and a parent-driven "reset" both wrote to the same
// state, from two different effects in the same commit, in an order React
// gives no guarantee about - so the reset could (and did) permanently wipe
// out a report that had already landed. Tagging instead lets staleness be
// detected lazily, as plain data, with no competing writer.
interface MeasuredHeights {
    key: string;
    values: Map<number, number>;
}

// A completed lock, similarly tagged. `locked` is a value derived from
// comparing this tag to the current `measureKey`, not its own effect-driven
// state, so a change to width/cols/gap/childCount unlocks the grid the very
// same render it happens in - no extra round trip required.
interface GridLock {
    key: string;
    height: number;
}

export const Grid = React.forwardRef<Frame, GridProps>((props, ref) => {
    const theme = React.useContext(CleanThemeContext);

    const [width, setWidth] = React.useState<number>(0);
    const [heights, setHeights] = React.useState<MeasuredHeights>({ key: "", values: new Map() });
    const [lock, setLock] = React.useState<GridLock | undefined>(undefined);

    const breakpoints = props.breakpoints ?? theme.breakpoints;
    const breakpoint = BreakpointHelper.getBreakpoint(width, breakpoints);
    const cols = math.max(SizeHelper.resolveResponsiveValue(props.cols, breakpoint) ?? 1, 1);
    const gap = SpacingHelper.GetPadding(theme, props.gap);

    const cellWidthScale = 1 / cols;
    // Floored (not just divided) so each cell's per-pixel-rounded offset never
    // sums, across a row, to more than the container's actual width - an exact
    // fractional offset (e.g. gap=8, cols=5 => -6.4) rounds up on some cells,
    // overflows the row by a couple of pixels, and makes UIGridLayout wrap the
    // last cell early regardless of FillDirectionMaxCells.
    const cellWidthOffset = math.floor(-gap * (cols - 1) / cols);
    const cellWidth = new UDim(cellWidthScale, cellWidthOffset);

    const childCount = React.Children.count(props.children);

    // Identifies the current measure pass. Any change to the grid's measured
    // width invalidates the locked row height, not just a breakpoint
    // crossing: cell widths are Scale-based, so within one breakpoint a
    // narrower window still re-wraps text taller (and a wider one shorter).
    // Without this, shrinking then widening the window would leave every cell
    // stuck at the tallest height ever measured. Width only changes when the
    // parent resizes (unlocking alters the root's height, not its width), so
    // this can't feed back into itself.
    const measureKey = `${width}:${cols}:${gap}:${childCount}`;

    const locked = lock !== undefined && lock.key === measureKey;
    const lockedHeight = locked ? lock!.height : 0;

    // Nested AutomaticSize content (e.g. a Box wrapping a Text) can take more
    // than one real engine frame - not just one Lua resumption cycle - to
    // settle into its final height (text wrapping in particular depends on
    // the engine's own layout pass, which runs on a frame boundary). Each
    // further settle re-fires a cell's AbsoluteSize report and cancels this
    // attempt via the cleanup below, which reschedules a fresh one since
    // `heights` is a dependency. Waiting two real frames (task.wait, inside a
    // spawned coroutine so this effect body itself never yields) - rather
    // than a same-tick task.defer - gives that layout pass room to actually
    // finish before we commit to a height.
    React.useEffect(() => {
        if (locked || heights.key !== measureKey || heights.values.size() < childCount) return;

        let cancelled = false;

        task.spawn(() => {
            task.wait();
            task.wait();
            if (cancelled) return;

            let max = 0;
            for (const [, height] of heights.values) max = math.max(max, height);

            setLock({ key: measureKey, height: max });
        });

        return () => {
            cancelled = true;
        };
    }, [heights, locked, measureKey, childCount]);

    // Deliberately always writes a fresh { key, values } object, even when
    // the reported height hasn't visibly changed from last time: the cell's
    // settle-poll (see GridCell) calls this every real frame for a fixed
    // window specifically so each poll keeps resetting Grid's settle-effect
    // dependency below, which is what makes that effect wait out the whole
    // window instead of committing on a value that merely hasn't updated yet.
    const reportHeight = React.useCallback((reportKey: string, index: number, height: number) => {
        setHeights((current) => {
            // A report from a stale pass (its measureKey no longer matches
            // what Grid last computed) starts a fresh map instead of merging
            // into whatever is currently there.
            const values = current.key === reportKey ? current.values : new Map<number, number>();

            const updated = new Map<number, number>();
            for (const [key, value] of values) updated.set(key, value);
            updated.set(index, height);
            return { key: reportKey, values: updated };
        });
    }, []);

    let cellIndex = 0;

    return (
        <frame
            key={props.name ?? "Grid"}
            ref={ref}
            Size={SizeHelper.GetSize(props, UDim2.fromScale(1, 1))}
            AutomaticSize={Enum.AutomaticSize.Y}
            BackgroundTransparency={1}
            Change={{
                AbsoluteSize: (instance) => {
                    const nextWidth = instance.AbsoluteSize.X;

                    setWidth((currentWidth) =>
                        currentWidth === nextWidth ? currentWidth : nextWidth
                    );
                },
            }}
        >
            {locked ? (
                <uigridlayout
                    key="GridLayout"
                    CellSize={new UDim2(cellWidthScale, cellWidthOffset, 0, lockedHeight)}
                    CellPadding={new UDim2(0, gap, 0, gap)}
                    FillDirection={Enum.FillDirection.Horizontal}
                    FillDirectionMaxCells={cols}
                    SortOrder={Enum.SortOrder.LayoutOrder}
                />
            ) : (
                <uilistlayout
                    key="GridMeasureLayout"
                    FillDirection={Enum.FillDirection.Horizontal}
                    Wraps={true}
                    Padding={new UDim(0, gap)}
                    SortOrder={Enum.SortOrder.LayoutOrder}
                />
            )}
            {React.Children.map(props.children, (child) => {
                // Own 0-based counter rather than the map callback's index: the
                // Luau React port passes a 1-based index there, and LayoutOrder
                // is specified as the child's 0-based position.
                const index = cellIndex++;

                return (
                    <GridCell
                        key={index}
                        index={index}
                        width={cellWidth}
                        height={lockedHeight}
                        locked={locked}
                        measureKey={measureKey}
                        onMeasured={reportHeight}
                    >
                        {child}
                    </GridCell>
                );
            })}
        </frame>
    );
});
