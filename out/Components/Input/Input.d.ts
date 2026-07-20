import React from "@rbxts/react";
import { ScalableElementProps, SpacedElementProps } from "../../Interfaces";
interface InputProps extends ScalableElementProps, SpacedElementProps, React.InstanceProps<TextBox> {
    value: string;
    placeholder?: string;
    validation?: "Number" | "String" | "None" | "Int";
    onChange?: (value: string) => void;
    Event?: React.InstanceEvent<TextBox>;
}
export declare function Input(props: InputProps): React.JSX.Element;
export {};
