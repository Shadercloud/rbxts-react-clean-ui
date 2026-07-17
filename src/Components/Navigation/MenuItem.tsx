import React from "@rbxts/react";
import { Button, ButtonProps } from "../Input";
import { NavigationContext } from "../../Contexts";

interface MenuItemProps extends ButtonProps {
    title: string
}

export function MenuItem(props: MenuItemProps) {
    const context = React.useContext(NavigationContext);
    return (
        <Button text={!context.collapsed ? props.title : undefined} icon={props.icon} Event={props.Event} group />
    );
}