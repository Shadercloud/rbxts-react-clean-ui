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
        <Button text={!context.collapsed ? props.title : undefined} icon={props.icon} Event={props.Event} group />
    );
}

interface MenuProps {
    title: string;
    collapsed?: boolean;
}

type MenuComponent = React.ForwardRefExoticComponent<
    MenuProps & React.RefAttributes<Frame>
> & {
    Item: typeof MenuItem;
};

const Menu = React.forwardRef<Frame, MenuProps>(
    (props, ref) => {

        const [collapsed, setCollapsed] = React.useState<boolean>(props.collapsed ?? false)


        return <NavigationContext.Provider value={{
            collapsed: collapsed
        }}>

            <Container ref={ref}>
                <Group>
                    <VStack spacing="sm">
                        <Container group >
                            <HStack valign="Center">
                                <Button icon="bars" Event={{
                                    Activated: () => {
                                        setCollapsed(!collapsed);
                                    }
                                }} />
                                {!collapsed && <Text text={props.title} variant="heading" />}
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