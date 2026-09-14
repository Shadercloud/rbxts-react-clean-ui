import React from "@rbxts/react";
import { BreakPointElementProps, ResponsiveCssSize, ResponsiveValue, ScaleSize } from "../../Interfaces/";
import { CleanThemeContext } from "../../Contexts";
import { BreakpointHelper, SizeHelper, SpacingHelper } from "../../Helpers/";

export interface GridProps extends BreakPointElementProps {
    cols?: ResponsiveValue<number>;
    gap?: ScaleSize | "None";
    width?: ResponsiveCssSize;
    children?: React.ReactNode;
    name?: string;
}

const SETTLE_POLL_FRAMES = 10;

interface GridCellProps {
    index: number;
    width: UDim;
    height: number;
    locked: boolean;
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
            BorderSizePixel={0}
            ClipsDescendants={true}
            Change={props.locked ? undefined : { AbsoluteSize: reportMeasurement }}
        >
            {props.children}
        </frame>
    );
}

interface MeasuredHeights {
    key: string;
    values: Map<number, number>;
}

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
    const cellWidthOffset = math.floor(-gap * (cols - 1) / cols);
    const cellWidth = new UDim(cellWidthScale, cellWidthOffset);

    const childCount = React.Children.count(props.children);

    const measureKey = `${width}:${cols}:${gap}:${childCount}`;

    const locked = lock !== undefined && lock.key === measureKey;
    const lockedHeight = locked ? lock!.height : 0;

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

    const reportHeight = React.useCallback((reportKey: string, index: number, height: number) => {
        setHeights((current) => {
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
            BorderSizePixel={0}
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
