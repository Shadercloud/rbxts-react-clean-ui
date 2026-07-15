import React, { Component } from "@rbxts/react";
import { PositionElementProps, SizeElementProps, ZIndexElementProps } from "../../Interfaces/";
interface ContainerProps extends SizeElementProps, PositionElementProps, ZIndexElementProps {
}
export declare class Container extends Component<ContainerProps> {
    render(): React.ReactNode;
}
export {};
