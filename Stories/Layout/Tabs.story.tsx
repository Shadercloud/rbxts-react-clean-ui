import React from "@rbxts/react";
import { Boolean, EnumList } from "@rbxts/ui-labs";
import { Container, createStory } from "@rbxts/react-clean-ui";
import Tabs from "./Tabs";

export = createStory((props) => (
    <Container center>
        <Tabs fill={props.controls.Fill} titles={props.controls.Titles} />
    </Container>
), {
    Fill: Boolean(false),
    Titles: EnumList<"text" | "icon-text" | "icon">(
        {
            Text: "text",
            "Icon and text": "icon-text",
            "Icon only": "icon",
        },
        "Text",
    ),
});
