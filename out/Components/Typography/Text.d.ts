import React from "@rbxts/react";
import { TypographyStyle } from "../../Theme";
import { TextVariant } from "../../Interfaces/";
interface TextProps extends React.InstanceProps<TextLabel> {
    text: string;
    variant?: TextVariant;
    typography?: TypographyStyle;
    weight?: Enum.FontWeight | "bold";
    align?: "Left" | "Right" | "Center";
    TextWrap?: boolean;
    letterSpacing?: number;
    name?: string;
}
export declare const Text: React.ForwardRefExoticComponent<Omit<TextProps, "ref"> & React.RefAttributes<TextLabel>>;
export {};
