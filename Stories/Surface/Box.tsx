import React from "@rbxts/react";
import { Box as BoxComponent, Container, Text } from "@rbxts/react-clean-ui";

function Box() {
    return <Container BackgroundColor3={new Color3(1, 1, 1)} BackgroundTransparency={0} BorderSizePixel={0} width={360}>
        <uipadding PaddingTop={new UDim(0, 10)} PaddingBottom={new UDim(0, 10)} PaddingLeft={new UDim(0, 10)} PaddingRight={new UDim(0, 10)} />
        <BoxComponent>
            <Text text="Boxes give content a bordered, shadowed surface to sit on." />
        </BoxComponent>
    </Container>
}

export = Box;
