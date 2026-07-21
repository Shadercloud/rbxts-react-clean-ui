
import React from "@rbxts/react";
import { CleanThemeContext } from "../../Contexts";
import { SizeElementProps, SpacedElementProps } from "../../Interfaces";
import { SizeHelper, SpacingHelper } from "../../Helpers";

interface ScrollerProps extends SizeElementProps, SpacedElementProps {
    children?: React.ReactNode;
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

        const canvasConn = frame
            .GetPropertyChangedSignal("AbsoluteCanvasSize")
            .Connect(updateScrolling);

        const windowConn = frame
            .GetPropertyChangedSignal("AbsoluteWindowSize")
            .Connect(updateScrolling);

        return () => {
            canvasConn.Disconnect();
            windowConn.Disconnect();
        };
    }, []);

    const spacing = SpacingHelper.GetPadding(theme, props.spacing)

    return (
        <scrollingframe
            ref={ref}
            AutomaticSize={SizeHelper.GetAutoSize(props, Enum.AutomaticSize.None)}
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