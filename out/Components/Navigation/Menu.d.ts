import React from "@rbxts/react";
import { ButtonProps } from "../Input";
interface MenuItemProps extends ButtonProps {
    title: string;
}
export declare function MenuItem(props: MenuItemProps): React.JSX.Element;
interface MenuProps {
    title: string;
    collapsed?: boolean;
}
type MenuComponent = React.ForwardRefExoticComponent<MenuProps & React.RefAttributes<Frame>> & {
    Item: typeof MenuItem;
};
declare const Menu: MenuComponent;
export { Menu };
