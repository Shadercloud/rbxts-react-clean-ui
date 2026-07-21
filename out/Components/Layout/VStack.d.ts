import React from "@rbxts/react";
import { SpacedElementProps } from "../../Interfaces";
interface VStackProps extends SpacedElementProps {
    children?: React.ReactNode;
    HorizontalFlex?: Enum.UIFlexAlignment;
    Event?: React.InstanceEvent<UIListLayout>;
    Change?: React.InstanceChangeEvent<UIListLayout>;
}
export declare function VStack(props: VStackProps): React.JSX.Element;
export {};
