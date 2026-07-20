import React, { Binding } from "@rbxts/react";
interface FlexItemProps {
    children?: React.ReactNode;
    align?: Enum.HorizontalAlignment | "Right" | "Left" | "Center" | React.Binding<Enum.HorizontalAlignment>;
    mode?: Enum.UIFlexMode | "Grow" | "None" | "Shrink" | "Fill" | "Custom" | Binding<Enum.UIFlexMode>;
    GrowRatio?: number;
    ShrinkRatio?: number;
}
export declare function FlexItem(props: FlexItemProps): React.JSX.Element;
export {};
