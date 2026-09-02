import React from "@rbxts/react";
import { IconName, ScalableElementProps, SpacedElementProps } from "../../Interfaces";
export interface InputProps extends ScalableElementProps, SpacedElementProps, React.InstanceProps<TextBox> {
    value: string;
    placeholder?: string;
    validation?: "Number" | "String" | "None" | "Int" | "Telephone" | "Alphanumeric" | "Email";
    min?: number;
    max?: number;
    onChange?: (value: string) => void;
    Event?: React.InstanceEvent<TextBox>;
    controlled?: boolean;
    icon?: IconName;
    name?: string;
}
export declare function Input(props: InputProps): React.JSX.Element;
