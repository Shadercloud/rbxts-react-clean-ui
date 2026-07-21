import React from "@rbxts/react";
import { Box, Container, createStory, Menu } from "@rbxts/react-clean-ui";

export = createStory((props) => (
    <Container>
        <Box
            width="Auto"
            height="100%"
        >
            <Menu title="Main Menu">
                <Menu.Item title="New Game" icon="plus-circle"
                    Event={{
                        Activated: () => { print("Clicked New Game") }
                    }} />
                <Menu.Item title="Create Character" icon="user-plus" />
                <Menu.Item title="Load Game " icon="database" />
                <Menu.Item title="Quit" icon="sign-out" />
            </Menu>
        </Box>
    </Container>

));