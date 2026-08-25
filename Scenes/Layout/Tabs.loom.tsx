import React from "@rbxts/react";
import { Tabs } from "../../src/Components/Layout/Tabs";
import { Container } from "../../src/Components/Layout/Container";
import { Text } from "../../src/Components/Typography/Text";
import { LoomScene } from "../LoomScene";
import { Box } from "../../src/Components/Surface/Box";

export const preview = {
    render: () => (
        <LoomScene>
            <Container width="100%" height="220" center>
                <Box width="320">
                    <Tabs>
                        <Tabs.Tab>
                            <Tabs.Title text="Profile" />
                            <Tabs.Content>
                                <Text text="Your profile details show up here." />
                            </Tabs.Content>
                        </Tabs.Tab>
                        <Tabs.Tab>
                            <Tabs.Title text="Settings" />
                            <Tabs.Content>
                                <Text text="Adjust your account settings on this tab." />
                            </Tabs.Content>
                        </Tabs.Tab>
                        <Tabs.Tab>
                            <Tabs.Title text="Billing" />
                            <Tabs.Content>
                                <Text text="Billing history and invoices live here." />
                            </Tabs.Content>
                        </Tabs.Tab>
                    </Tabs>
                </Box>
            </Container>
        </LoomScene>
    ),
    title: "Layout/Tabs",
} as const;
