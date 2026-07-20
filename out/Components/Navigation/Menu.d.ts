import React, { Component } from "@rbxts/react";
interface MenuProps {
    title: string;
    collapsed?: boolean;
}
interface MenuState {
    collapsed: boolean;
}
export declare class Menu extends Component<MenuProps, MenuState> {
    state: MenuState;
    render(): React.ReactNode;
}
export {};
