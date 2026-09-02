import React from "@rbxts/react";
import { Fieldset, Switch as SwitchComponent, Text, VStack } from "@rbxts/react-clean-ui";
import { ScreenshotFrame } from "../ScreenshotFrame";

function Switch(props: { screenshot?: boolean } = {}) {
    const [liveValue, setLiveValue] = React.useState(false);

    const content = (
        <VStack>
            <Fieldset checkbox>
                <Fieldset.Control>
                    <SwitchComponent onChange={setLiveValue} />
                </Fieldset.Control>
                <Fieldset.Label>
                    <Text text={`Live value: ${liveValue ? "on" : "off"}`} />
                </Fieldset.Label>
            </Fieldset>
            <Fieldset checkbox>
                <Fieldset.Control>
                    <SwitchComponent checked />
                </Fieldset.Control>
                <Fieldset.Label>
                    <Text text="Initially checked" />
                </Fieldset.Label>
            </Fieldset>
            <Fieldset checkbox disabled>
                <Fieldset.Control>
                    <SwitchComponent disabled />
                </Fieldset.Control>
                <Fieldset.Label>
                    <Text text="Disabled (off)" />
                </Fieldset.Label>
            </Fieldset>
            <Fieldset checkbox disabled>
                <Fieldset.Control>
                    <SwitchComponent checked disabled />
                </Fieldset.Control>
                <Fieldset.Label>
                    <Text text="Disabled (on)" />
                </Fieldset.Label>
            </Fieldset>
            <Fieldset checkbox>
                <Fieldset.Control>
                    <SwitchComponent checked intent="success" />
                </Fieldset.Control>
                <Fieldset.Label>
                    <Text text="<b>success</b> intent" />
                </Fieldset.Label>
            </Fieldset>
            <Fieldset checkbox>
                <Fieldset.Control>
                    <SwitchComponent checked intent="danger" />
                </Fieldset.Control>
                <Fieldset.Label>
                    <Text text="<b>danger</b> intent" />
                </Fieldset.Label>
            </Fieldset>
            <Fieldset checkbox>
                <Fieldset.Control>
                    <SwitchComponent checked intent="warning" />
                </Fieldset.Control>
                <Fieldset.Label>
                    <Text text="<b>warning</b> intent" />
                </Fieldset.Label>
            </Fieldset>
            <Fieldset checkbox>
                <Fieldset.Control>
                    <SwitchComponent checked intent="info" />
                </Fieldset.Control>
                <Fieldset.Label>
                    <Text text="<b>info</b> intent" />
                </Fieldset.Label>
            </Fieldset>
        </VStack>
    );

    return props.screenshot ? <ScreenshotFrame>{content}</ScreenshotFrame> : content;
}

export = Switch;
