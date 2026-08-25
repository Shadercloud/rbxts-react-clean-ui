import React from "@rbxts/react";
import { Container, Fieldset, Input, Slider as SliderComponent, Text, VStack } from "@rbxts/react-clean-ui";

function Slider() {
    const startingValue = 10
    const [value, setValue] = React.useState<number>(startingValue);
    const [realtimeValue, setRealtimeValue] = React.useState<number>(startingValue);

    const [controlledValue, setControlledValue] = React.useState<number>(startingValue);

    const [step, setStep] = React.useState<number>(0.1);

    const [rangeValue, setRangeValue] = React.useState<Vector2>(new Vector2(2, 8));

    return <Container BackgroundColor3={new Color3(1, 1, 1)} BackgroundTransparency={0} BorderSizePixel={0} width={420}>
        <uipadding PaddingTop={new UDim(0, 10)} PaddingBottom={new UDim(0, 10)} PaddingLeft={new UDim(0, 10)} PaddingRight={new UDim(0, 10)} />
        <VStack>
            <Fieldset>
                <Fieldset.Label>
                    <Text text={`Slider (value: ${realtimeValue}):`} />
                </Fieldset.Label>
                <Fieldset.Control>
                    <SliderComponent highlight="start" min-value={5} max-value={20} value={value} onChanged={(val: number | Vector2) => {
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

            <Fieldset>
                <Fieldset.Label>
                    <Text text={`Controlled Slider A (${controlledValue}):`} />
                </Fieldset.Label>
                <Fieldset.Control>
                    <SliderComponent controlled min-value={5} max-value={20} step={step} value={controlledValue}
                        onDragged={(val: number | Vector2) => {
                            if (typeIs(val, "number"))
                                setControlledValue(val);
                        }} />
                </Fieldset.Control>
            </Fieldset>
            <Fieldset>
                <Fieldset.Label>
                    <Text text={`Controlled Slider B (${controlledValue}):`} />
                </Fieldset.Label>
                <Fieldset.Control>
                    <SliderComponent controlled min-value={5} max-value={20} step={step} value={controlledValue}
                        highlight="end"
                        onDragged={(val: number | Vector2) => {
                            if (typeIs(val, "number"))
                                setControlledValue(val);
                        }} />
                </Fieldset.Control>
            </Fieldset>
            <Fieldset>
                <Fieldset.Label>
                    <Text text="Step size:" />
                </Fieldset.Label>
                <Fieldset.Control>
                    <Input controlled value={`${step}`} validation="Number" onChange={(val) => {
                        const v = tonumber(val);
                        if (v !== undefined)
                            setStep(v)
                    }} />
                </Fieldset.Control>
            </Fieldset>
            <Fieldset>
                <Fieldset.Label>
                    <Text text={`Range (${rangeValue}):`} />
                </Fieldset.Label>
                <Fieldset.Control>
                    <SliderComponent
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
    </Container>
}

export = Slider;
