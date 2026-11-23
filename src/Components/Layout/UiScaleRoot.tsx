import React from "@rbxts/react";
import { UiScaleContext, useUiScale } from "../../Contexts";
import { ZIndexElementProps } from "../../Interfaces";
import { UiScaleFrame } from "./UiScaleRoot.frame";

export interface UiScaleRootProps extends ZIndexElementProps {
    scale: number;
    name?: string;
    children?: React.ReactNode;
}

export const UiScaleRoot = React.forwardRef<Frame, UiScaleRootProps>((props, ref) => {
    const parentScale = useUiScale();

    return (
        <UiScaleFrame ref={ref} name={props.name ?? "UiScaleRoot"} scale={props.scale} ZIndex={props.ZIndex}>
            <UiScaleContext.Provider value={parentScale * props.scale}>
                {props.children}
            </UiScaleContext.Provider>
        </UiScaleFrame>
    );
});
