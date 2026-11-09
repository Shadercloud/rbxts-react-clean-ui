import React from "@rbxts/react";
import { Button, Checkbox, Container, HStack, Text, VStack } from "@rbxts/react-clean-ui";
import { ScreenshotFrame } from "../ScreenshotFrame";

function CheckboxControlled(props: { screenshot?: boolean } = {}) {
    const [checked, setChecked] = React.useState(false);
    const [controlledCalls, setControlledCalls] = React.useState(0);
    const [frozenCalls, setFrozenCalls] = React.useState(0);
    const [uncontrolledCalls, setUncontrolledCalls] = React.useState(0);
    const [uncontrolledValue, setUncontrolledValue] = React.useState(true);
    const [labelValue, setLabelValue] = React.useState(false);

    const content = (
        <Container width={420}>
            <VStack>
                <Container name="Controlled" LayoutOrder={1}>
                    <HStack valign="Center" Wraps={false}>
                        <Checkbox
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
                <Container name="Frozen" LayoutOrder={3}>
                    <HStack valign="Center" Wraps={false}>
                        <Checkbox
                            checked
                            onChange={() => setFrozenCalls((count) => count + 1)}
                        />
                        <Text LayoutOrder={1} text={`Controlled, onChange ignored (calls: ${frozenCalls})`} TextWrap={false} />
                    </HStack>
                </Container>
                <Container name="Uncontrolled" LayoutOrder={4}>
                    <HStack valign="Center" Wraps={false}>
                        <Checkbox
                            defaultChecked
                            onChange={(value: boolean) => {
                                setUncontrolledValue(value);
                                setUncontrolledCalls((count) => count + 1);
                            }}
                        />
                        <Text LayoutOrder={1} text={`Uncontrolled: ${uncontrolledValue ? "on" : "off"} (onChange calls: ${uncontrolledCalls})`} TextWrap={false} />
                    </HStack>
                </Container>
                <Container name="WithLabel" LayoutOrder={5}>
                    <Checkbox
                        label={`Click this label to toggle (${labelValue ? "on" : "off"})`}
                        onChange={setLabelValue}
                    />
                </Container>
            </VStack>
        </Container>
    );

    return props.screenshot ? <ScreenshotFrame>{content}</ScreenshotFrame> : content;
}

export = CheckboxControlled;
