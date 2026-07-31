import React from "@rbxts/react";
import { BoxProps } from "./Box";
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
type CardComponent = React.ForwardRefExoticComponent<CardProps & React.RefAttributes<Frame>> & {
    Header: typeof CardHeader;
    Footer: typeof CardFooter;
    Body: typeof CardBody;
};
declare const Card: CardComponent;
export { Card };
