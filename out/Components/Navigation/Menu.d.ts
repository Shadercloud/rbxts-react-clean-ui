import React, { Component } from "@rbxts/react";
interface MenuProps {
    title: string;
}
interface MenuState {
    collapsed: boolean;
}
export declare class Menu extends Component<MenuProps, MenuState> {
    render(): React.ReactNode;
}
export {};
