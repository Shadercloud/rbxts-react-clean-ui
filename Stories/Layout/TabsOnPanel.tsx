import React from "@rbxts/react";
import { Container, extendTheme, Tabs as TabsComponent, Text, ThemeProvider, WoodenTheme } from "@rbxts/react-clean-ui";
import { ScreenshotFrame } from "../ScreenshotFrame";

const tabsOnPanelTheme = extendTheme(WoodenTheme, {
    components: {
        tabs: {
            gap: -3,
            borderColor: Color3.fromHex("#331D07"),
            borderThickness: 3,
            cornerRadius: 0,
            list: {
                backgroundTransparency: 1,
                backgroundImage: { image: "" },
                padding: "0px",
                cornerRadius: 0,
            },
            button: {
                borderThickness: 3,
                cornerRadius: { topLeft: 8, topRight: 8, bottomLeft: 0, bottomRight: 0 },
                intents: {
                    primary: {
                        default: {
                            textColor: Color3.fromHex("#D3CBA3"),
                            borderColor: Color3.fromHex("#331D07"),
                            backgroundColor: Color3.fromHex("#5C3A18"),
                            backgroundTransparency: 0,
                            backgroundImage: { image: "" },
                        },
                        hover: {
                            textColor: Color3.fromHex("#D3CBA3"),
                            backgroundTransparency: 0,
                        },
                        focus: {
                            textColor: Color3.fromHex("#FFF7CF"),
                            backgroundColor: Color3.fromHex("#FFFFFF"),
                            backgroundTransparency: 0,
                            backgroundGradient: {
                                colors: [Color3.fromHex("#BA854A"), Color3.fromHex("#A16B30"), Color3.fromHex("#7A4A20")],
                                stops: [0, 0.48, 1],
                                rotation: 90,
                            },
                        },
                    },
                },
            },
        },
    },
});

function TabsOnPanel(props: { screenshot?: boolean; fill?: boolean } = {}) {
    const content = (
        <Container width={420}>
            <ThemeProvider theme={tabsOnPanelTheme}>
                <TabsComponent>
                    <TabsComponent.List fill={props.fill ?? false}>
                        <TabsComponent.Title value="crafting" text="Crafting" />
                        <TabsComponent.Title value="storage" text="Storage" />
                        <TabsComponent.Title value="upgrades" text="Upgrades" />
                    </TabsComponent.List>
                    <TabsComponent.Body>
                        <TabsComponent.Content value="crafting">
                            <Text text="Combine timber and iron at the workbench to craft new tools." />
                        </TabsComponent.Content>
                        <TabsComponent.Content value="storage">
                            <Text text="Your hearth chest holds 24 of 40 stacks." />
                        </TabsComponent.Content>
                        <TabsComponent.Content value="upgrades">
                            <Text text="Upgrade the hearth to unlock a second crafting slot." />
                        </TabsComponent.Content>
                    </TabsComponent.Body>
                </TabsComponent>
            </ThemeProvider>
        </Container>
    );

    return props.screenshot ? <ScreenshotFrame>{content}</ScreenshotFrame> : content;
}

export = TabsOnPanel;
