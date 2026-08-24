import React from "@rbxts/react";
import { Box, Container, createStory, Text, VStack, Fieldset, Slider, Input } from "@rbxts/react-clean-ui";

function SliderDemo() {
    const startingValue = 10
    const [value, setValue] = React.useState<number>(startingValue);
    const [realtimeValue, setRealtimeValue] = React.useState<number>(startingValue);

    const [controlledValue, setControllerValue] = React.useState<number>(startingValue);

    const [step, setStep] = React.useState<number>(0.1);

    const [rangeValue, setRangeValue] = React.useState<Vector2>(new Vector2(2, 8));
    return <Container
        width="90%"
        center
    >
        <Box>
            <VStack>
                <Container>
                    <Text text="Slider Example" variant="heading" />
                </Container>
                <Fieldset>
                    <Fieldset.Label>
                        <Text text="Slider Example" />
                    </Fieldset.Label>
                    <Fieldset.Control>
                        <Slider highlight="start" min-value={5} max-value={20} value={value} onChanged={(val: number | Vector2) => {
                            if (typeIs(val, "number")) {
                                setValue(val);
                                setRealtimeValue(val);
                            }
                        }}
                            onDragged={(val: number | Vector2) => {
                                if (typeIs(val, "number"))
                                    setRealtimeValue(val);
                            }} />
                    </Fieldset.Control>

                </Fieldset>

                <Container>
                    <Text text={`Realtime value to: ${realtimeValue}`} />
                </Container>
                <Container>
                    <Text text={`Value has been changed to: ${value}`} />
                </Container>

                <Container>
                    <Text text="Controlled State Sliders" variant="heading" />
                </Container>
                <Container>
                    <Text text={`The below two sliders have state controlled by this story instead of internal, \nso can both be driven from the same value: ${controlledValue}`} />
                </Container>
                <Fieldset>
                    <Fieldset.Label>
                        <Text text="Slider Example 1:" />
                    </Fieldset.Label>
                    <Fieldset.Control>
                        <Slider controlled min-value={5} max-value={20} step={step} value={controlledValue}
                            onDragged={(val: number | Vector2) => {
                                if (typeIs(val, "number"))
                                    setControllerValue(val);
                            }} />
                    </Fieldset.Control>
                </Fieldset>
                <Fieldset>
                    <Fieldset.Label>
                        <Text text="Slider Example 2:" />
                    </Fieldset.Label>
                    <Fieldset.Control>
                        <Slider controlled min-value={5} max-value={20} step={step} value={controlledValue}
                            highlight="end"
                            onDragged={(val: number | Vector2) => {
                                if (typeIs(val, "number"))
                                    setControllerValue(val);
                            }} />
                    </Fieldset.Control>

                </Fieldset>
                <Fieldset>
                    <Fieldset.Label>
                        <Text text="Set Step Value: " />
                    </Fieldset.Label>
                    <Fieldset.Control>
                        <Input controlled value={`${step}`} validation="Number" onChange={(val) => {
                            const v = tonumber(val);
                            if (v !== undefined)
                                setStep(v)
                        }} />
                    </Fieldset.Control>
                </Fieldset>
                <Container>
                    <Text text="Range Example" variant="heading" />
                </Container>
                <Fieldset>
                    <Fieldset.Label>
                        <Text text={`Range Slider (${rangeValue}): `} />
                    </Fieldset.Label>
                    <Fieldset.Control>
                        <Slider
                            highlight="middle"
                            range
                            min-value={0}
                            max-value={10}
                            step={1}
                            controlled
                            value={rangeValue}
                            onDragged={(value) => {
                                if (typeIs(value, "Vector2")) {
                                    setRangeValue(value);
                                }
                            }}

                        />
                    </Fieldset.Control>

                </Fieldset>
            </VStack>
        </Box>
    </Container>
}

export = createStory(SliderDemo);