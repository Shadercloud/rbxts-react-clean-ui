import React from "@rbxts/react";
export interface HoverButtonContextValue {
    hover: boolean;
    isSelected: boolean;
}
export declare const HoverButtonContext: React.Context<HoverButtonContextValue | undefined>;
type ImageButtonProps = React.InstanceProps<ImageButton>;
interface HoverButtonProps {
    default: ImageButtonProps;
    hover?: ImageButtonProps;
    focus?: ImageButtonProps;
    isSelected?: boolean;
    children?: React.ReactNode;
}
export declare function HoverButton(propSet: HoverButtonProps): React.JSX.Element;
export {};
