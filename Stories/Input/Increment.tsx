import React from "@rbxts/react";
import { Container, Fieldset, Increment as IncrementComponent, Text, VStack } from "@rbxts/react-clean-ui";

interface IncrementProps {
    min?: number;
    max?: number;
    step?: number;
}

function Increment(props: IncrementProps = {}) {
    const [value, setValue] = React.useState<number>(4);
    const [boundedValue, setBoundedValue] = React.useState<number>(props.max ?? 10);

    return <Container
        BackgroundColor3={new Color3(1, 1, 1)}
        BackgroundTransparency={0}
        BorderSizePixel={0}
        width={360}
    >
        <uipadding PaddingTop={new UDim(0, 10)} PaddingBottom={new UDim(0, 10)} PaddingLeft={new UDim(0, 10)} PaddingRight={new UDim(0, 10)} />
        <VStack>
            <Fieldset>
                <Fieldset.Label>
                    <Text text={`Default (value: ${value}):`} />
                </Fieldset.Label>
                <Fieldset.Control>
                    <IncrementComponent value={value} onChange={setValue} />
                </Fieldset.Control>
            </Fieldset>
            <Fieldset>
                <Fieldset.Label>
                    <Text text={`Bounded ${props.min ?? 0}-${props.max ?? 10}, step ${props.step ?? 1} (value: ${boundedValue}):`} />
                </Fieldset.Label>
                <Fieldset.Control>
                    <IncrementComponent
                        value={boundedValue}
                        min={props.min ?? 0}
                        max={props.max ?? 10}
                        step={props.step ?? 1}
                        onChange={setBoundedValue}
                    />
                </Fieldset.Control>
            </Fieldset>
        </VStack>
    </Container>
}

export = Increment;
