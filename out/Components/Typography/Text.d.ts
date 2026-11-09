import React from "@rbxts/react";
import { TypographyOutline, TypographyStyle } from "../../Theme";
import { SizeElementProps, TextVariant } from "../../Interfaces/";
interface TextProps extends React.InstanceProps<TextLabel>, Pick<SizeElementProps, "minWidth" | "maxWidth" | "minHeight" | "maxHeight"> {
    text: string;
    variant?: TextVariant;
    typography?: TypographyStyle;
    weight?: Enum.FontWeight | "bold";
    align?: "Left" | "Right" | "Center";
    TextWrap?: boolean;
    letterSpacing?: number;
    name?: string;
    outline?: TypographyOutline | boolean;
    shrinkToFit?: boolean;
    shrinkMinScale?: number;
    minTextSize?: number;
    maxTextSize?: number;
}
export declare const Text: React.ForwardRefExoticComponent<Omit<TextProps, "ref"> & React.RefAttributes<TextLabel>>;
export {};
