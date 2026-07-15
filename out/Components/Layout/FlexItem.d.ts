import React, { Binding } from "@rbxts/react";
interface FlexItemProps {
    children?: React.ReactNode;
    align?: Enum.HorizontalAlignment | "Right" | "Left" | "Center" | React.Binding<Enum.HorizontalAlignment>;
    mode?: Enum.UIFlexMode | "Grow" | "None" | "Shrink" | "Fill" | "Custom" | Binding<Enum.UIFlexMode>;
}
export declare function FlexItem(props: FlexItemProps): React.JSX.Element;
export {};
