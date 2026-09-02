import React from "@rbxts/react";
import { Tabs } from "../../src/Components/Layout/Tabs";
import { Container } from "../../src/Components/Layout/Container";
import { Text } from "../../src/Components/Typography/Text";
import { LoomScene } from "../LoomScene";
import { Card } from "../../src/Components/Surface/Card";

export const preview = {
    render: () => (
        <LoomScene>
            <Container width="100%" height="220" center>
                <Card width="320">
                    <Tabs>
                        <Card.Header>
                            <Tabs.List>
                                <Tabs.Title value="profile" text="Profile" />
                                <Tabs.Title value="settings" text="Settings" />
                                <Tabs.Title value="billing" text="Billing" />
                            </Tabs.List>
                        </Card.Header>
                        <Card.Body>
                            <Tabs.Body>
                                <Tabs.Content value="profile">
                                    <Text text="Your profile details show up here." />
                                </Tabs.Content>
                                <Tabs.Content value="settings">
                                    <Text text="Adjust your account settings on this tab." />
                                </Tabs.Content>
                                <Tabs.Content value="billing">
                                    <Text text="Billing history and invoices live here." />
                                </Tabs.Content>
                            </Tabs.Body>
                        </Card.Body>
                    </Tabs>
                </Card>
            </Container>
        </LoomScene>
    ),
    title: "Layout/Tabs",
} as const;
