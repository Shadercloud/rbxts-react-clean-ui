import React, { Component } from "@rbxts/react";
import { BackgroundElementProps, ShadowElementProps, SizeElementProps, SpacedElementProps, ZIndexElementProps } from "../../Interfaces/";
import { CleanThemeContext } from "../../Contexts/";
interface BoxProps extends SpacedElementProps, ShadowElementProps, BackgroundElementProps, ZIndexElementProps, SizeElementProps {
}
export declare class Box extends Component<BoxProps> {
    static contextType: React.Context<import("../..").CleanTheme>;
    context: React.ContextType<typeof CleanThemeContext>;
    render(): React.JSX.Element;
}
export {};
