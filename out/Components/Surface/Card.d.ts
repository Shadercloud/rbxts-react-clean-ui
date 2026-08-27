import React from "@rbxts/react";
import { BoxProps } from "./Box";
import { IntentElementProps, PositionElementProps, ZIndexElementProps } from "../../Interfaces";
interface CardHeaderProps extends IntentElementProps, PositionElementProps, ZIndexElementProps {
    children?: React.ReactNode;
    overlay?: boolean;
}
export declare const CardHeader: React.ForwardRefExoticComponent<CardHeaderProps & React.RefAttributes<ImageLabel>>;
interface CardBodyProps extends BoxProps {
}
export declare const CardBody: React.ForwardRefExoticComponent<Omit<CardBodyProps, "ref"> & React.RefAttributes<ImageLabel>>;
interface CardFooterProps extends BoxProps, IntentElementProps {
    overlay?: boolean;
}
export declare const CardFooter: React.ForwardRefExoticComponent<Omit<CardFooterProps, "ref"> & React.RefAttributes<ImageLabel>>;
interface CardProps extends BoxProps, IntentElementProps {
}
type CardComponent = React.ForwardRefExoticComponent<CardProps & React.RefAttributes<ImageLabel>> & {
    Header: typeof CardHeader;
    Footer: typeof CardFooter;
    Body: typeof CardBody;
};
declare const Card: CardComponent;
export { Card };
