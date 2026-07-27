import React, { Component } from "@rbxts/react";
import { BoxProps } from "./Box";
import { CleanThemeContext } from "../../Contexts";
import { IntentElementProps } from "../../Interfaces";
interface CardHeaderProps extends IntentElementProps {
    children?: React.ReactNode;
}
export declare const CardHeader: React.ForwardRefExoticComponent<CardHeaderProps & React.RefAttributes<Frame>>;
interface CardBodyProps extends BoxProps {
}
export declare const CardBody: React.ForwardRefExoticComponent<Omit<CardBodyProps, "ref"> & React.RefAttributes<Frame>>;
interface CardFooterProps extends BoxProps, IntentElementProps {
}
export declare const CardFooter: React.ForwardRefExoticComponent<Omit<CardFooterProps, "ref"> & React.RefAttributes<Frame>>;
interface CardProps extends BoxProps, IntentElementProps {
}
export declare class Card extends Component<CardProps> {
    static Header: React.ForwardRefExoticComponent<CardHeaderProps & React.RefAttributes<Frame>>;
    static Footer: React.ForwardRefExoticComponent<Omit<CardFooterProps, "ref"> & React.RefAttributes<Frame>>;
    static Body: React.ForwardRefExoticComponent<Omit<CardBodyProps, "ref"> & React.RefAttributes<Frame>>;
    static contextType: React.Context<import("../..").CleanTheme>;
    context: React.ContextType<typeof CleanThemeContext>;
    render(): React.JSX.Element;
}
export {};
