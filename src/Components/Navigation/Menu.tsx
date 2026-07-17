import React, { Component, ReactComponent } from "@rbxts/react";
import { Button } from "../Input";
import { Container, FlexItem, Group, HStack, Scroller, VStack } from "../Layout";
import { Text } from "../Typography";
import { NavigationContext } from "../../Contexts";

interface MenuProps {
    title: string;
}

interface MenuState {
    collapsed: boolean;
}

@ReactComponent
export class Menu extends Component<MenuProps, MenuState> {
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