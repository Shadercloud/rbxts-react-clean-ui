import React, { Component } from "@rbxts/react";
import { CleanThemeContext } from "../../Contexts";
import { TypographyStyle } from "../../Theme";
import { TextVariant } from "../../Interfaces/";
interface TextProps extends React.InstanceProps<TextLabel> {
    text: string;
    variant?: TextVariant;
    typography?: TypographyStyle;
    weight?: Enum.FontWeight | "bold";
    align?: "Left" | "Right" | "Center";
}
export declare class Text extends Component<TextProps> {
    static contextType: React.Context<import("../../Theme").CleanTheme>;
    context: React.ContextType<typeof CleanThemeContext>;
    render(): React.ReactNode;
}
export {};
