import React from "@rbxts/react";
import { Checkbox as CheckboxComponent, Fieldset, Text, VStack } from "@rbxts/react-clean-ui";
import { ScreenshotFrame } from "../ScreenshotFrame";

function Checkbox(props: { screenshot?: boolean } = {}) {
    const content = (
        <VStack>
            <Fieldset checkbox>
                <Fieldset.Control>
                    <CheckboxComponent onChange={(value: boolean) => {
                        print(`Checked: ${value}`)
                    }} />
                </Fieldset.Control>
                <Fieldset.Label>
                    <Text text="Default checkbox settings" />
                </Fieldset.Label>
            </Fieldset>
            <Fieldset checkbox>
                <Fieldset.Control>
                    <CheckboxComponent checked />
                </Fieldset.Control>
                <Fieldset.Label>
                    <Text text="Initially Checked" />
                </Fieldset.Label>
            </Fieldset>
            <Fieldset checkbox>
                <Fieldset.Control>
                    <CheckboxComponent scale="xl" spacing="xl" />
                </Fieldset.Control>
                <Fieldset.Label>
                    <Text text="<b>xl</b> Scale and Spacing" />
                </Fieldset.Label>
            </Fieldset>
            <Fieldset checkbox>
                <Fieldset.Control>
                    <CheckboxComponent scale="xs" spacing="xl" />
                </Fieldset.Control>
                <Fieldset.Label>
                    <Text text="<b>xs</b> Scale with <b>xl</b> Spacing" />
                </Fieldset.Label>
            </Fieldset>
            <Fieldset checkbox>
                <Fieldset.Control>
                    <CheckboxComponent icon-checked="thumbs-up" icon-unchecked="thumbs-down" intent-checked="info" intent-unchecked="danger" />
                </Fieldset.Control>
                <Fieldset.Label>
                    <Text text="Custom icons and colors" />
                </Fieldset.Label>
            </Fieldset>
        </VStack>
    );

    return props.screenshot ? <ScreenshotFrame>{content}</ScreenshotFrame> : content;
}

export = Checkbox;
