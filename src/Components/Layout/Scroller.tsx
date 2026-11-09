import React from "@rbxts/react";
import { CleanThemeContext } from "../../Contexts";
import { PositionElementProps, SizeElementProps, SpacedElementProps } from "../../Interfaces";
import { SizeHelper, SpacingHelper } from "../../Helpers";

export interface ScrollerProps extends SizeElementProps, SpacedElementProps, PositionElementProps {
    children?: React.ReactNode;
    AutomaticSizeParent?: boolean;
    name?: string;
    stableGutter?: boolean;
    onScroll?: (canvasPosition: Vector2, scroller: ScrollingFrame) => void;
    onNearEnd?: () => void;
    nearEndThreshold?: number;
}

export const Scroller = React.forwardRef<ScrollingFrame, ScrollerProps>((props, forwardedRef) => {
    const theme = React.useContext(CleanThemeContext);
    const scrollerTheme = theme.components.scroller;

    const thickness = 12;
    const [isScrolling, setIsScrolling] = React.useState(false);

    const ref = React.useRef<ScrollingFrame>();
    const thumbRef = React.useRef<Frame>();
    const propsRef = React.useRef(props);
    propsRef.current = props;

    const hasTrack = scrollerTheme.trackColor !== undefined;
    const thumbBorderThickness = scrollerTheme.thumbBorderThickness ?? 0;
    const hasCustomThumb = thumbBorderThickness > 0;
    const sizeConstraint = SizeHelper.GetSizeConstraint(props);
    const decorated = hasTrack || hasCustomThumb || sizeConstraint !== undefined;

    const setFrame = React.useCallback(
        (instance: ScrollingFrame | undefined) => {
            ref.current = instance;

            if (typeIs(forwardedRef, "function")) {
                forwardedRef(instance);
            } else if (forwardedRef !== undefined) {
                (forwardedRef as React.MutableRefObject<ScrollingFrame | undefined>).current = instance;
            }
        },
        [forwardedRef],
    );

    React.useEffect(() => {
        const frame = ref.current;
        if (!frame) return;

        let nearEndArmed = true;
        let lastCanvasHeight = 0;

        const updateThumb = () => {
            const thumb = thumbRef.current;
            if (!thumb) return;

            const windowHeight = frame.AbsoluteWindowSize.Y;
            const canvasHeight = frame.AbsoluteCanvasSize.Y;
            const maxScroll = canvasHeight - windowHeight;

            if (maxScroll <= 0 || windowHeight <= 0) {
                thumb.Visible = false;
                return;
            }

            const length = math.min(windowHeight, math.max(thickness, (windowHeight * windowHeight) / canvasHeight));
            const progress = math.clamp(frame.CanvasPosition.Y / maxScroll, 0, 1);

            thumb.Size = new UDim2(0, thickness, 0, length);
            thumb.Position = new UDim2(1, -thickness, 0, progress * (windowHeight - length));
            thumb.Visible = true;
        };

        const updateNearEnd = () => {
            const onNearEnd = propsRef.current.onNearEnd;
            if (onNearEnd === undefined) return;

            const canvasHeight = frame.AbsoluteCanvasSize.Y;
            if (canvasHeight > lastCanvasHeight) nearEndArmed = true;
            lastCanvasHeight = canvasHeight;

            const distance = canvasHeight - frame.AbsoluteWindowSize.Y - frame.CanvasPosition.Y;
            const threshold = math.max(0, propsRef.current.nearEndThreshold ?? 0);

            if (distance <= threshold) {
                if (nearEndArmed) {
                    nearEndArmed = false;
                    onNearEnd();
                }
            } else {
                nearEndArmed = true;
            }
        };

        const updateScrolling = () => {
            setIsScrolling(
                frame.AbsoluteCanvasSize.Y > frame.AbsoluteWindowSize.Y,
            );
            updateThumb();
            updateNearEnd();
        };

        const updatePosition = () => {
            updateThumb();
            propsRef.current.onScroll?.(frame.CanvasPosition, frame);
            updateNearEnd();
        };

        updateScrolling();

        const canvasConn = frame
            .GetPropertyChangedSignal("AbsoluteCanvasSize")
            .Connect(updateScrolling);

        const windowConn = frame
            .GetPropertyChangedSignal("AbsoluteWindowSize")
            .Connect(updateScrolling);

        const positionConn = frame
            .GetPropertyChangedSignal("CanvasPosition")
            .Connect(updatePosition);

        return () => {
            canvasConn.Disconnect();
            windowConn.Disconnect();
            positionConn.Disconnect();
        };
    }, [decorated, hasCustomThumb]);

    const spacing = SpacingHelper.GetPadding(theme, props.spacing)
    const reserveGutter = props.stableGutter === true || isScrolling;

    const scrollingFrame = (
        <scrollingframe
            key={decorated ? "ScrollingFrame" : props.name ?? "Scroller"}
            ref={setFrame}
            AnchorPoint={decorated ? undefined : SizeHelper.GetAnchor(props)}
            AutomaticSize={decorated ? undefined : SizeHelper.GetAutoSize(props, Enum.AutomaticSize.None)}
            Position={decorated ? undefined : SizeHelper.GetPosition(props)}
            Size={decorated ? UDim2.fromScale(1, 1) : SizeHelper.GetSize(props, UDim2.fromScale(1, 1))}
            ZIndex={decorated ? 2 : undefined}
            BorderSizePixel={0}
            ScrollingDirection={Enum.ScrollingDirection.Y}
            ScrollBarImageColor3={scrollerTheme.barColor}
            ScrollBarImageTransparency={hasCustomThumb ? 1 : undefined}
            CanvasSize={UDim2.fromScale(1, 0)}
            BackgroundTransparency={1}
            ScrollBarThickness={thickness}
            VerticalScrollBarInset={props.stableGutter === true ? Enum.ScrollBarInset.Always : Enum.ScrollBarInset.ScrollBar}
            AutomaticCanvasSize={Enum.AutomaticSize.Y}
        >
            {props.AutomaticSizeParent && <uilistlayout
                key="AutomaticSizeLayout"
                FillDirection={Enum.FillDirection.Horizontal}
            />}
            <frame
                key="ScrollerContent"
                Size={new UDim2(1, reserveGutter ? -thickness - (spacing) : 0, 0, 0)}
                AutomaticSize={Enum.AutomaticSize.Y}
                BackgroundTransparency={1}
                BorderSizePixel={0}
            >
                {props.children}
            </frame>
        </scrollingframe>
    );

    if (!decorated) return scrollingFrame;

    return (
        <frame
            key={props.name ?? "Scroller"}
            AnchorPoint={SizeHelper.GetAnchor(props)}
            AutomaticSize={SizeHelper.GetAutoSize(props, Enum.AutomaticSize.None)}
            Position={SizeHelper.GetPosition(props)}
            Size={SizeHelper.GetSize(props, UDim2.fromScale(1, 1))}
            BackgroundTransparency={1}
            BorderSizePixel={0}
        >
            {sizeConstraint !== undefined && (
                <uisizeconstraint
                    key="SizeConstraint"
                    MinSize={sizeConstraint.MinSize}
                    MaxSize={sizeConstraint.MaxSize}
                />
            )}
            {hasTrack && (
                <frame
                    key="ScrollerTrack"
                    AnchorPoint={new Vector2(1, 0)}
                    Position={UDim2.fromScale(1, 0)}
                    Size={new UDim2(0, thickness, 1, 0)}
                    ZIndex={1}
                    Visible={isScrolling}
                    Active={false}
                    BackgroundColor3={scrollerTheme.trackColor}
                    BackgroundTransparency={scrollerTheme.trackTransparency ?? 0}
                    BorderSizePixel={0}
                />
            )}
            {scrollingFrame}
            {hasCustomThumb && (
                <frame
                    key="ScrollerThumb"
                    ref={thumbRef}
                    ZIndex={3}
                    Active={false}
                    BackgroundColor3={scrollerTheme.barColor}
                    BorderSizePixel={0}
                >
                    <uistroke
                        key="ThumbBorder"
                        ApplyStrokeMode={Enum.ApplyStrokeMode.Border}
                        BorderStrokePosition={Enum.BorderStrokePosition.Inner}
                        Thickness={thumbBorderThickness}
                        Color={scrollerTheme.thumbBorderColor}
                    />
                </frame>
            )}
        </frame>
    );
});
