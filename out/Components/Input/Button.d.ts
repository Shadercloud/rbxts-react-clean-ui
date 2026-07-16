import React, { Component } from "@rbxts/react";
import { BackgroundElementProps, IconElementProps, IntentElementProps, ShadowElementProps, SpacedElementProps, ZIndexElementProps } from "../../Interfaces/";
import { CleanThemeContext } from "../../Contexts/";
interface ButtonProps extends SpacedElementProps, ShadowElementProps, ZIndexElementProps, BackgroundElementProps, IntentElementProps, IconElementProps {
    text?: string;
    fontWeight?: Enum.FontWeight;
}
interface ButtonState {
    hover: boolean;
}
export declare class Button extends Component<ButtonProps, ButtonState> {
    static contextType: React.Context<import("../..").CleanTheme>;
    context: React.ContextType<typeof CleanThemeContext>;
    render(): React.JSX.Element;
}
export {};
