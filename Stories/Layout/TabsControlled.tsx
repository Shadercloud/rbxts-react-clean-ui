import React from "@rbxts/react";
import { Button, Container, Tabs as TabsComponent, Text, VStack } from "@rbxts/react-clean-ui";
import { ScreenshotFrame } from "../ScreenshotFrame";

const TAB_VALUES = ["inventory", "quests", "settings"];

function TabsControlled(props: { screenshot?: boolean; fill?: boolean } = {}) {
    const [selected, setSelected] = React.useState("inventory");

    const selectNext = () => {
        const index = TAB_VALUES.indexOf(selected);
        setSelected(TAB_VALUES[(index + 1) % TAB_VALUES.size()]);
    };

    const content = (
        <Container width={420}>
            <VStack>
                <TabsComponent value={selected} onValueChange={setSelected}>
                    <TabsComponent.List fill={props.fill ?? false}>
                        <TabsComponent.Title value="inventory" text="Inventory" />
                        <TabsComponent.Title value="quests" text="Quests" />
                        <TabsComponent.Title value="settings" text="Settings" />
                    </TabsComponent.List>
                    <TabsComponent.Body>
                        <TabsComponent.Content value="inventory">
                            <Text text="12 items, 3 equipped." />
                        </TabsComponent.Content>
                        <TabsComponent.Content value="quests">
                            <Text text="2 active quests, 1 ready to turn in." />
                        </TabsComponent.Content>
                        <TabsComponent.Content value="settings">
                            <Text text="Audio, graphics and controls." />
                        </TabsComponent.Content>
                    </TabsComponent.Body>
                </TabsComponent>
                <Text text={`Selected: ${selected}`} />
                <Button text="Next tab" icon="arrow-right" Event={{ Activated: () => selectNext() }} />
            </VStack>
        </Container>
    );

    return props.screenshot ? <ScreenshotFrame>{content}</ScreenshotFrame> : content;
}

export = TabsControlled;
