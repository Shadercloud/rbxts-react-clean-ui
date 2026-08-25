import React from "@rbxts/react";
import { Checkbox as CheckboxComponent, Container, Fieldset, Text, VStack } from "@rbxts/react-clean-ui";

function Checkbox() {
    return <Container BackgroundColor3={new Color3(1, 1, 1)} BackgroundTransparency={0} BorderSizePixel={0}>
        <uipadding PaddingTop={new UDim(0, 10)} PaddingBottom={new UDim(0, 10)} PaddingLeft={new UDim(0, 10)} PaddingRight={new UDim(0, 10)} />
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
    </Container>
}

export = Checkbox;
