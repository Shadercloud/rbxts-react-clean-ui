import React, { Binding } from "@rbxts/react";
import { SpacedElementProps } from "../../Interfaces";
interface HStackProps extends SpacedElementProps {
    children?: React.ReactNode;
    valign?: Enum.VerticalAlignment | "Center" | "Top" | "Bottom" | React.Binding<Enum.VerticalAlignment> | undefined;
    VerticalAlignment?: Enum.VerticalAlignment;
    Wraps?: boolean;
    HorizontalAlignment?: Enum.HorizontalAlignment;
    HorizontalFlex?: Enum.UIFlexAlignment;
    VerticalFlex?: Enum.UIFlexAlignment;
    Event?: React.InstanceEvent<UIListLayout>;
    Change?: React.InstanceChangeEvent<UIListLayout>;
    Padding?: UDim | Binding<UDim>;
    name?: string;
}
export declare function HStack(props: HStackProps): React.JSX.Element;
export {};
