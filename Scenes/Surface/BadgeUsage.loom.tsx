import React from "@rbxts/react";
import { Badge } from "../../src/Components/Surface/Badge";
import { Box } from "../../src/Components/Surface/Box";
import { Button } from "../../src/Components/Input/Button";
import { Container } from "../../src/Components/Layout/Container";
import { HStack } from "../../src/Components/Layout/HStack";
import { VStack } from "../../src/Components/Layout/VStack";
import { Text } from "../../src/Components/Typography/Text";
import { LoomScene } from "../LoomScene";

export const preview = {
    render: () => (
        <LoomScene>
            <Container width="80%" height="260" center>
                <Box>
                    <VStack>
                        <Container name="InboxRow" LayoutOrder={1}>
                            <HStack valign="Center" Wraps={false}>
                                <Text LayoutOrder={1} text="Inbox" TextWrap={false} />
                                <Badge LayoutOrder={2} text="24" intent="danger" />
                            </HStack>
                        </Container>
                        <Container name="FriendsRow" LayoutOrder={2}>
                            <HStack valign="Center" Wraps={false}>
                                <Text LayoutOrder={1} text="Friends online" TextWrap={false} />
                                <Badge LayoutOrder={2} text="5" icon="check" intent="success" />
                            </HStack>
                        </Container>
                        <Container name="QuestsRow" LayoutOrder={3}>
                            <HStack valign="Center" Wraps={false}>
                                <Text LayoutOrder={1} text="Daily quests" TextWrap={false} />
                                <Badge LayoutOrder={2} text="New" intent="info" scale="sm" />
                            </HStack>
                        </Container>
                        <Container name="ButtonRow" LayoutOrder={4}>
                            <HStack valign="Center" Wraps={false}>
                                <Button LayoutOrder={1} text="Notifications" />
                                <Badge LayoutOrder={2} text="99+" intent="warning" />
                            </HStack>
                        </Container>
                    </VStack>
                </Box>
            </Container>
        </LoomScene>
    ),
    title: "Surface/Badge Usage",
} as const;
