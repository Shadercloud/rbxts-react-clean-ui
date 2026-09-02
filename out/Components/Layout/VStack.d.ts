import React, { Binding } from "@rbxts/react";
import { SpacedElementProps } from "../../Interfaces";
interface VStackProps extends SpacedElementProps {
    valign?: Enum.VerticalAlignment | "Center" | "Top" | "Bottom" | React.Binding<Enum.VerticalAlignment> | undefined;
    children?: React.ReactNode;
    HorizontalFlex?: Enum.UIFlexAlignment;
    HorizontalAlignment?: Enum.HorizontalAlignment;
    VerticalFlex?: Enum.UIFlexAlignment;
    VerticalAlignment?: Enum.VerticalAlignment;
    Event?: React.InstanceEvent<UIListLayout>;
    Change?: React.InstanceChangeEvent<UIListLayout>;
    Padding?: UDim | Binding<UDim>;
    Wraps?: boolean;
    name?: string;
}
export declare function VStack(props: VStackProps): React.JSX.Element;
export {};
