import React from "@rbxts/react";
import { Menu } from "../../src/Components/Navigation/Menu";
import { Container } from "../../src/Components/Layout/Container";
import { Box } from "../../src/Components/Surface/Box";
import { LoomScene } from "../LoomScene";

export const preview = {
    render: () => (
        <LoomScene>
            <Container height="350">
                <Box width="Auto" height="100%">
                    <Menu title="Main Menu">
                        <Menu.Item title="Home" icon="home" />
                        <Menu.Item title="Profile" icon="user" />
                        <Menu.Item title="Settings" icon="cog" />
                        <Menu.Item title="Logout" icon="sign-out" />
                    </Menu>
                </Box>
            </Container>
        </LoomScene>
    ),
    title: "Navigation/Menu",
} as const;
