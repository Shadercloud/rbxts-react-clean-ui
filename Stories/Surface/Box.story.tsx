import React from "@rbxts/react";
import { createStory, Container } from "@rbxts/react-clean-ui";
import Box from "./Box";


// backgroundImage lives on theme.components.box.backgroundImage rather than as a Box
// prop, so it's demonstrated inside Box.tsx via a themed subtree instead of a control here.
export = createStory((props) => (
    <Container width="300" height="300" center>
        <Box />
    </Container>
));
