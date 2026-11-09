import React from "@rbxts/react";
import { EnumList, Number } from "@rbxts/ui-labs";
import { Container as ContainerComponent, createStory } from "@rbxts/react-clean-ui";
import Container from "./Container";

export = createStory((props) => (
    <ContainerComponent
        center
        padding="16"
        cornerRadius="md"
        borderThickness={1}
        borderColor={Color3.fromHex("#8A8F98")}
        borderTransparency={0.4}
    >
        <Container
            width={props.controls.Width}
            maxWidth={props.controls.MaxWidth}
            borderPosition={props.controls.BorderPosition}
        />
    </ContainerComponent>
), {
    Width: Number(420, 200, 600),
    MaxWidth: Number(600, 200, 600),
    BorderPosition: EnumList<"inner" | "outer">(
        {
            Inner: "inner",
            Outer: "outer",
        },
        "Inner",
    ),
});
