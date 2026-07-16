import React from "@rbxts/react";
import { CleanThemeContext } from "../../Contexts";

interface ScrollerProps {
    children?: React.ReactNode;
}

export function Scroller(props: ScrollerProps) {
    const theme = React.useContext(CleanThemeContext);
    const thickness = 12
    return (
        <scrollingframe
            Size={UDim2.fromScale(1, 1)}
            BorderSizePixel={0}
            ScrollingDirection={Enum.ScrollingDirection.Y}
            ScrollBarImageColor3={theme.components.scroller.barColor}
            CanvasSize={UDim2.fromScale(1, 0)}
            BackgroundTransparency={1}
            ScrollBarThickness={thickness}
            VerticalScrollBarInset={Enum.ScrollBarInset.ScrollBar}
            AutomaticCanvasSize={Enum.AutomaticSize.Y}
        >
            <frame Size={new UDim2(1, -thickness, 0, 0)}
                AutomaticSize={Enum.AutomaticSize.Y}
                BackgroundTransparency={1}>
                {props.children}
            </frame>
        </scrollingframe>
    );
}