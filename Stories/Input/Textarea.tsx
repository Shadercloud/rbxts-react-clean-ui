import React from "@rbxts/react";
import { Container, Text, Textarea as TextareaComponent, VStack } from "@rbxts/react-clean-ui";
import { ScreenshotFrame } from "../ScreenshotFrame";

const LONG_TEXT = [
    "Textareas keep a fixed height, so long content scrolls instead of pushing the layout around.",
    "The scrollbar gutter is always reserved, which means the text wraps at the same width whether or not the bar is showing.",
    "Use the mouse wheel, a touch drag or the right thumbstick while focused to scroll through this text.",
    "Typing or moving the caret keeps the caret's line in view, with its padding.",
    "This paragraph only exists to make sure the content is taller than the field from the very start.",
].join("\n\n");

interface TextareaProps {
    rows?: number;
    height?: number;
    maxLength?: number;
    disabled?: boolean;
    screenshot?: boolean;
}

function Textarea(props: TextareaProps = {}) {
    const disabled = props.disabled ?? false;
    const [controlledValue, setControlledValue] = React.useState("");
    const [countedValue, setCountedValue] = React.useState("");

    const content = (
        <Container width={420}>
            <VStack>
                <Text text="Controlled (default 4 rows)" />
                <TextareaComponent
                    placeholder="Write a message..."
                    value={controlledValue}
                    controlled
                    onChange={setControlledValue}
                    disabled={disabled}
                />
                <Text text={`Mirrored length: ${controlledValue.size()} bytes`} />
                <Text text={`rows={${props.rows ?? 2}}`} />
                <TextareaComponent placeholder="Sized by rows" value="" rows={props.rows ?? 2} disabled={disabled} />
                <Text text={`height={${props.height ?? 120}} with long text`} />
                <TextareaComponent value={LONG_TEXT} height={props.height ?? 120} disabled={disabled} />
                <Text text={`maxLength={${props.maxLength ?? 1500}} with showCount`} />
                <TextareaComponent
                    placeholder="Limited length"
                    value={countedValue}
                    onChange={setCountedValue}
                    maxLength={props.maxLength ?? 1500}
                    showCount
                    disabled={disabled}
                />
                <Text text="Disabled" />
                <TextareaComponent value="This field can't be edited." rows={2} disabled />
            </VStack>
        </Container>
    );

    return props.screenshot ? <ScreenshotFrame>{content}</ScreenshotFrame> : content;
}

export = Textarea;
