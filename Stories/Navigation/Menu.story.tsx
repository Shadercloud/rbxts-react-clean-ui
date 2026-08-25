import React from "@rbxts/react";
import { Container, createStory } from "@rbxts/react-clean-ui";
import Menu from "./Menu";

export = createStory((props) => (
    <>
        <Container>
            <Menu />
        </Container>
        <Container right="0px">
            <Menu title="Really Long Menu Name" />
        </Container>
    </>
));
