import React from "@rbxts/react";
import { Box, Container, createStory, Menu, MenuItem } from "@rbxts/react-clean-ui";

export = createStory((props) => (
    <Container>
        <Box
            width="Auto"
            height="100%"
        >
            <Menu title="Main Menu">
                <MenuItem title="New Game" icon="plus-circle"
                    Event={{
                        Activated: () => { print("Clicked New Game") }
                    }} />
                <MenuItem title="Create Character" icon="user-plus" />
                <MenuItem title="Load Game " icon="database" />
                <MenuItem title="Quit" icon="sign-out" />
            </Menu>
        </Box>
    </Container>

));