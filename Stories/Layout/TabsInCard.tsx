import React from "@rbxts/react";
import { Card, Container, Tabs as TabsComponent, Text } from "@rbxts/react-clean-ui";
import { ScreenshotFrame } from "../ScreenshotFrame";

function TabsInCard(props: { screenshot?: boolean } = {}) {
    const content = (
        <TabsComponent>
            <Card intent="primary">
                <Card.Header>
                    <TabsComponent.List>
                        <TabsComponent.Title value="overview" text="Overview" />
                        <TabsComponent.Title value="activity" text="Activity" />
                    </TabsComponent.List>
                </Card.Header>
                <Card.Body width="100%">
                    <TabsComponent.Body>
                        <TabsComponent.Content value="overview">
                            <Text text="Level 42, joined three seasons ago, and currently ranked in the top 10% of the leaderboard." />
                        </TabsComponent.Content>
                        <TabsComponent.Content value="activity">
                            <Text text="Recently cleared the Frostpeak dungeon and unlocked the Ember Blade achievement." />
                        </TabsComponent.Content>
                    </TabsComponent.Body>
                </Card.Body>
            </Card>
        </TabsComponent>
    );

    return props.screenshot ? <ScreenshotFrame>{content}</ScreenshotFrame> : content;
}

export = TabsInCard;
