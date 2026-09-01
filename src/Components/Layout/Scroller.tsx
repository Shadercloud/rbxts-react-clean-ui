
import React from "@rbxts/react";
import { CleanThemeContext } from "../../Contexts";
import { PositionElementProps, SizeElementProps, SpacedElementProps } from "../../Interfaces";
import { SizeHelper, SpacingHelper } from "../../Helpers";

interface ScrollerProps extends SizeElementProps, SpacedElementProps, PositionElementProps {
    children?: React.ReactNode;
    AutomaticSizeParent?: boolean;
}

export function Scroller(props: ScrollerProps) {
    const theme = React.useContext(CleanThemeContext);

    const thickness = 12;
    const [isScrolling, setIsScrolling] = React.useState(false);

    const ref = React.useRef<ScrollingFrame>();

    React.useEffect(() => {
        const frame = ref.current;
        if (!frame) return;

        const updateScrolling = () => {
            setIsScrolling(
                frame.AbsoluteCanvasSize.Y > frame.AbsoluteWindowSize.Y,
            );
        };

        updateScrolling();

        // Some renderers (e.g. the browser-based Loom scene preview) don't back
        // this ref with an instance that supports property-changed signals, so
        // guard the subscription instead of throwing and losing overflow tracking.
        let canvasConn: RBXScriptConnection | undefined;
        let windowConn: RBXScriptConnection | undefined;

        pcall(() => {
            canvasConn = frame
                .GetPropertyChangedSignal("AbsoluteCanvasSize")
                .Connect(updateScrolling);
        });

        pcall(() => {
            windowConn = frame
                .GetPropertyChangedSignal("AbsoluteWindowSize")
                .Connect(updateScrolling);
        });

        return () => {
            canvasConn?.Disconnect();
            windowConn?.Disconnect();
        };
    }, []);

    const spacing = SpacingHelper.GetPadding(theme, props.spacing)

    return (

        <scrollingframe
            ref={ref}
            AnchorPoint={SizeHelper.GetAnchor(props)}
            AutomaticSize={SizeHelper.GetAutoSize(props, Enum.AutomaticSize.None)}
            Position={SizeHelper.GetPosition(props)}
            Size={SizeHelper.GetSize(props, UDim2.fromScale(1, 1))}
            BorderSizePixel={0}
            ScrollingDirection={Enum.ScrollingDirection.Y}
            ScrollBarImageColor3={theme.components.scroller.barColor}
            CanvasSize={UDim2.fromScale(1, 0)}
            BackgroundTransparency={1}
            ScrollBarThickness={thickness}
            VerticalScrollBarInset={Enum.ScrollBarInset.ScrollBar}
            AutomaticCanvasSize={Enum.AutomaticSize.Y}
        >
            { /* Need this for the automaticSize of the parent to work (weird Roblox thing) */}
            {props.AutomaticSizeParent && <uilistlayout
                FillDirection={Enum.FillDirection.Horizontal}
            />}
            <frame
                Size={new UDim2(1, isScrolling ? -thickness - (spacing) : 0, 0, 0)}
                AutomaticSize={Enum.AutomaticSize.Y}
                BackgroundTransparency={1}
            >
                {props.children}
            </frame>
        </scrollingframe>
    );
}