import React, { Component } from "@rbxts/react";
import { ButtonProps } from "../Input";
interface MenuItemProps extends ButtonProps {
    title: string;
}
export declare function MenuItem(props: MenuItemProps): React.JSX.Element;
interface MenuProps {
    title: string;
    collapsed?: boolean;
}
interface MenuState {
    collapsed: boolean;
}
export declare class Menu extends Component<MenuProps, MenuState> {
    static Item: typeof MenuItem;
    state: MenuState;
    render(): React.ReactNode;
}
export {};
