import React from "@rbxts/react";
import { Box, Button, Container, createStory, Tooltip } from "@rbxts/react-clean-ui";
import ToolTip from "./ToolTip";

export = createStory((props) => (
    <>
        <Container center>
            <Box>
                <ToolTip />
            </Box>
        </Container>
        <Tooltip content="No room above, so this opens below and shifts away from the edge" placement="Top">
            <Button text="Top-left corner (Top flips)" />
        </Tooltip>
    </>
));
