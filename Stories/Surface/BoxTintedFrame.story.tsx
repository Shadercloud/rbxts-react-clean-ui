import React from "@rbxts/react";
import { createStory } from "@rbxts/react-clean-ui";
import BoxTintedFrame from "./BoxTintedFrame";

// backgroundImage lives on theme.components.box.backgroundImage rather than as a Box
// prop, so it's demonstrated inside BoxTintedFrame.tsx via a themed subtree instead of a control here.
export = createStory((props) => (
    <BoxTintedFrame />
));
