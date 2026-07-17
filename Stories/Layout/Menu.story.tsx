import React from "@rbxts/react";
import { Box, Button, Container, createStory, Group, Menu, MenuItem } from "@rbxts/react-clean-ui";

export = createStory((props) => (
    <><Container>
        <Box
            width="Auto"
            height="100%"
        >
            <Menu title="Main Menu">
                <MenuItem title="New Game" icon="plus-circle"></MenuItem>
                <MenuItem title="Create Character" icon="user-plus"></MenuItem>
                <MenuItem title="Load Game " icon="database"></MenuItem>
                <MenuItem title="Quit" icon="sign-out"></MenuItem>
            </Menu>
        </Box>
    </Container>
    </>
));