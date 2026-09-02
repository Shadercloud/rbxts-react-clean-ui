import React from "@rbxts/react";
import { Button, ButtonProps } from "../Input";
import { Container, FlexItem, Group, HStack, Scroller, VStack } from "../Layout";
import { Text } from "../Typography";
import { NavigationContext } from "../../Contexts";

interface MenuItemProps extends ButtonProps {
    title: string;
}

export function MenuItem(props: MenuItemProps) {
    const context = React.useContext(NavigationContext);
    return (
        <Button name="MenuItem" text={!context.collapsed ? props.title : undefined} icon={props.icon} Event={props.Event} group />
    );
}

interface MenuProps {
    title: string;
    collapsed?: boolean;
    name?: string;
}

type MenuComponent = React.ForwardRefExoticComponent<
    MenuProps & React.RefAttributes<ImageLabel>
> & {
    Item: typeof MenuItem;
};

const Menu = React.forwardRef<ImageLabel, MenuProps>(
    (props, ref) => {

        const [collapsed, setCollapsed] = React.useState<boolean>(props.collapsed ?? false)


        return <NavigationContext.Provider value={{
            collapsed: collapsed
        }}>

            <Container name={props.name ?? "Menu"} ref={ref}>
                <Group>
                    <VStack spacing="sm">
                        <Container name="MenuHeader" group >
                            <HStack valign="Center">
                                <Button name="MenuToggleButton" icon="bars" LayoutOrder={1} Event={{
                                    Activated: () => {
                                        setCollapsed(!collapsed);
                                    }
                                }} />
                                {!collapsed && <Text name="MenuTitle" text={props.title} variant="heading" LayoutOrder={2} />}
                            </HStack>
                        </Container>
                        <FlexItem mode="Fill">
                            <Scroller height="100%">
                                <VStack spacing="sm" HorizontalFlex={Enum.UIFlexAlignment.None}>
                                    {props.children}
                                </VStack>
                            </Scroller>
                        </FlexItem>
                    </VStack>
                </Group>
            </Container>
        </NavigationContext.Provider>

    }) as MenuComponent;

Menu.Item = MenuItem;
export { Menu }