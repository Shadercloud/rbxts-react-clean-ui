import React from "@rbxts/react";
import { Container, Text as TextComponent, VStack } from "@rbxts/react-clean-ui";

interface TextProps {
    wrap?: boolean;
}

function Text(props: TextProps = {}) {
    return <Container BackgroundColor3={new Color3(1, 1, 1)} BackgroundTransparency={0} BorderSizePixel={0} width={420}>
        <uipadding PaddingTop={new UDim(0, 10)} PaddingBottom={new UDim(0, 10)} PaddingLeft={new UDim(0, 10)} PaddingRight={new UDim(0, 10)} />
        <VStack spacing="sm">
            <TextComponent text="Display" variant="display" />
            <TextComponent text="Title" variant="title" />
            <TextComponent text="Heading" variant="heading" />
            <TextComponent text="Body (default variant)" variant="body" />
            <TextComponent text="Label" variant="label" />
            <TextComponent text="Caption" variant="caption" />
            <TextComponent text="Bold weight" weight="bold" />
            <TextComponent text="Custom color" TextColor3={new Color3(0.2, 0.45, 0.9)} />
            <TextComponent text="Right aligned" align="Right" />
            <TextComponent
                text="Long paragraphs wrap across multiple lines by default so body copy stays readable inside narrow containers."
                TextWrap={props.wrap}
            />
        </VStack>
    </Container>
}

export = Text;
