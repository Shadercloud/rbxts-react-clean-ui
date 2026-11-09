import React from "@rbxts/react";
import { Button, Container, HStack, Switch, Text, VStack } from "@rbxts/react-clean-ui";
import { ScreenshotFrame } from "../ScreenshotFrame";

function SwitchControlled(props: { screenshot?: boolean } = {}) {
    const [checked, setChecked] = React.useState(false);
    const [controlledCalls, setControlledCalls] = React.useState(0);
    const [uncontrolledCalls, setUncontrolledCalls] = React.useState(0);
    const [uncontrolledValue, setUncontrolledValue] = React.useState(true);

    const content = (
        <Container width={420}>
            <VStack>
                <Container name="Controlled" LayoutOrder={1}>
                    <HStack valign="Center" Wraps={false}>
                        <Switch
                            checked={checked}
                            onChange={(value: boolean) => {
                                setChecked(value);
                                setControlledCalls((count) => count + 1);
                            }}
                        />
                        <Text LayoutOrder={1} text={`Controlled: ${checked ? "on" : "off"} (onChange calls: ${controlledCalls})`} TextWrap={false} />
                    </HStack>
                </Container>
                <Container name="ToggleFromOutside" LayoutOrder={2}>
                    <Button text="Toggle from outside" icon="refresh" Event={{ Activated: () => setChecked(!checked) }} />
                </Container>
                <Container name="Uncontrolled" LayoutOrder={3}>
                    <HStack valign="Center" Wraps={false}>
                        <Switch
                            defaultChecked
                            onChange={(value: boolean) => {
                                setUncontrolledValue(value);
                                setUncontrolledCalls((count) => count + 1);
                            }}
                        />
                        <Text LayoutOrder={1} text={`Uncontrolled: ${uncontrolledValue ? "on" : "off"} (onChange calls: ${uncontrolledCalls})`} TextWrap={false} />
                    </HStack>
                </Container>
                <Container name="Ordered" LayoutOrder={4}>
                    <HStack valign="Center" Wraps={false}>
                        <VStack>
                            <Switch name="Third" LayoutOrder={3} defaultChecked intent="danger" />
                            <Switch name="First" LayoutOrder={1} defaultChecked intent="success" />
                            <Switch name="Second" LayoutOrder={2} defaultChecked intent="info" />
                        </VStack>
                        <Text LayoutOrder={1} text="Declared danger, success, info; LayoutOrder sorts them" TextWrap={false} />
                    </HStack>
                </Container>
            </VStack>
        </Container>
    );

    return props.screenshot ? <ScreenshotFrame>{content}</ScreenshotFrame> : content;
}

export = SwitchControlled;
