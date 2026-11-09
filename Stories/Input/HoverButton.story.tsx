import React from "@rbxts/react";
import { Boolean, EnumList } from "@rbxts/ui-labs";
import { Container, createStory } from "@rbxts/react-clean-ui";
import HoverButton from "./HoverButton";

export = createStory((props) => (
    <Container center>
        <HoverButton
            isSelected={props.controls.Selected}
            borderPosition={props.controls.BorderPosition}
        />
    </Container>
), {
    Selected: Boolean(false),
    BorderPosition: EnumList<"inner" | "outer">(
        {
            Inner: "inner",
            Outer: "outer",
        },
        "Inner",
    ),
});
