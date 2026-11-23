import React from "@rbxts/react";
import { ZIndexElementProps } from "../../Interfaces";
export interface UiScaleFrameProps extends ZIndexElementProps {
    scale: number;
    name: string;
    children?: React.ReactNode;
}
export declare const UiScaleFrame: React.ForwardRefExoticComponent<UiScaleFrameProps & React.RefAttributes<Frame>>;
export declare function useOverlayScale(): number;
export interface OverlayScaleFrameProps extends ZIndexElementProps {
    children?: React.ReactNode;
}
export declare function OverlayScaleFrame(props: OverlayScaleFrameProps): boolean | ReadonlyMap<React.Key, React.ReactNode> | {
    readonly [key: string]: React.ReactNode;
    readonly [key: number]: React.ReactNode;
} | readonly React.ReactNode[] | React.JSX.Element | undefined;
