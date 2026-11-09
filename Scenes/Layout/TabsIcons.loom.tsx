import React from "@rbxts/react";
import { Tabs } from "../../src/Components/Layout/Tabs";
import { Container } from "../../src/Components/Layout/Container";
import { VStack } from "../../src/Components/Layout/VStack";
import { LoomScene } from "../LoomScene";
import { Card } from "../../src/Components/Surface/Card";

export const preview = {
    render: () => (
        <LoomScene>
            <Container width="100%" height="160" center>
                <Card width="320">
                    <Card.Body>
                        <VStack Padding={new UDim(0, 12)}>
                            <Container name="IconTabs" width="100%" LayoutOrder={1}>
                                <Tabs>
                                    <Tabs.List>
                                        <Tabs.Title value="home" icon="home" />
                                        <Tabs.Title value="alerts" icon="bell" />
                                        <Tabs.Title value="settings" icon="cog" />
                                    </Tabs.List>
                                </Tabs>
                            </Container>
                            <Container name="IconTextTabs" width="100%" LayoutOrder={2}>
                                <Tabs>
                                    <Tabs.List>
                                        <Tabs.Title value="profile" icon="user" text="Profile" />
                                        <Tabs.Title value="settings" icon="cog" text="Settings" />
                                        <Tabs.Title value="billing" icon="credit-card" text="Billing" />
                                    </Tabs.List>
                                </Tabs>
                            </Container>
                        </VStack>
                    </Card.Body>
                </Card>
            </Container>
        </LoomScene>
    ),
    title: "Layout/Tabs Icons",
} as const;
