import React, { Component, ReactComponent } from "@rbxts/react";
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

interface MenuState {
    collapsed: boolean;
}

@ReactComponent
export class Menu extends Component<MenuProps, MenuState> {
    static Item = MenuItem;

    state: MenuState = {
        collapsed: this.props.collapsed ?? false
    }
    render(): React.ReactNode {
        return <NavigationContext.Provider value={{
            collapsed: this.state.collapsed
        }}>

            <Group>
                <VStack spacing="sm">
                    <Container group>
                        <HStack valign="Center">
                            <Button icon="bars" Event={{
                                Activated: () => {
                                    this.setState((state) => {
                                        return {
                                            collapsed: !state.collapsed
                                        }
                                    })
                                }
                            }} />
                            {!this.state.collapsed && <Text text={this.props.title} variant="heading" />}
                        </HStack>
                    </Container>
                    <FlexItem mode="Fill">
                        <Scroller height="100%">
                            <VStack spacing="sm" HorizontalFlex={Enum.UIFlexAlignment.None}>
                                {this.props.children}
                            </VStack>
                        </Scroller>
                    </FlexItem>
                </VStack>
            </Group>
        </NavigationContext.Provider>
    }
}