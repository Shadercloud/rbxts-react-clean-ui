import React from "@rbxts/react";
import { OverlayContext, useUiScale } from "../../Contexts";
import { ZIndexElementProps } from "../../Interfaces";

export interface UiScaleFrameProps extends ZIndexElementProps {
    scale: number;
    name: string;
    children?: React.ReactNode;
}

export const UiScaleFrame = React.forwardRef<Frame, UiScaleFrameProps>((props, ref) => {
    return (
        <frame
            key={props.name}
            ref={ref}
            Size={UDim2.fromScale(1 / props.scale, 1 / props.scale)}
            BackgroundTransparency={1}
            BorderSizePixel={0}
            ZIndex={props.ZIndex}
        >
            <uiscale key="UiScale" Scale={props.scale} />
            {props.children}
        </frame>
    );
});

export function useOverlayScale(): number {
    const scale = useUiScale();
    const overlay = React.useContext(OverlayContext);

    return scale / (overlay.scale ?? 1);
}

export interface OverlayScaleFrameProps extends ZIndexElementProps {
    children?: React.ReactNode;
}

export function OverlayScaleFrame(props: OverlayScaleFrameProps) {
    const relativeScale = useOverlayScale();

    if (relativeScale === 1) {
        return props.children;
    }

    return (
        <UiScaleFrame name="UiScaleOverlay" scale={relativeScale} ZIndex={props.ZIndex}>
            {props.children}
        </UiScaleFrame>
    );
}
