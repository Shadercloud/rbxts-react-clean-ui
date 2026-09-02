import React from "@rbxts/react";
import {
    IntentElementProps,
    ScalableElementProps,
    SpacedElementProps,
} from "../../Interfaces";
import { CleanThemeContext } from "../../Contexts/";
import { Container, FlexItem, HStack } from "../Layout";
import { Button } from "./Button";
import { resolveSteppedValue } from "./Increment.step";
import { Input } from "./Input";

export interface IncrementProps
    extends ScalableElementProps,
    SpacedElementProps,
    IntentElementProps,
    React.InstanceProps<ImageLabel> {
    value: number;
    onChange?: (value: number) => void;
    step?: number;
    min?: number;
    max?: number;
    controlled?: boolean;
    name?: string;
}

export const Increment = React.forwardRef<ImageLabel, IncrementProps>(
    (props, ref) => {
        const theme = React.useContext(CleanThemeContext);
        const buttonStyleOverride = theme.components.increment?.button;

        const [value, setValue] = React.useState(props.value);

        const current = props.controlled ? props.value : value;
        const step = props.step ?? 1;

        const decrementDisabled = resolveSteppedValue(
            current,
            "decrement",
            step,
            props.min,
            props.max,
        ) === undefined;

        const incrementDisabled = resolveSteppedValue(
            current,
            "increment",
            step,
            props.min,
            props.max,
        ) === undefined;

        const applyValue = (nextValue: number) => {
            if (!props.controlled) {
                setValue(nextValue);
            }

            props.onChange?.(nextValue);
        };

        return (
            <Container
                name={props.name ?? "Increment"}
                ref={ref}
                {...props}
                Size={UDim2.fromScale(1, 0)}
                AutomaticSize={Enum.AutomaticSize.Y}
            >
                <HStack Wraps={false} valign="Center" spacing={props.spacing}>
                    <Button
                        name="DecrementButton"
                        icon="minus"
                        intent={props.intent}
                        scale={props.scale}
                        spacing={props.spacing}
                        disabled={decrementDisabled}
                        styleOverride={buttonStyleOverride}
                        LayoutOrder={0}
                        Event={{
                            Activated: () => {
                                const nextValue = resolveSteppedValue(
                                    current,
                                    "decrement",
                                    step,
                                    props.min,
                                    props.max,
                                );

                                if (nextValue === undefined) {
                                    return;
                                }

                                applyValue(nextValue);
                            },
                        }}
                    />

                    <FlexItem HorizontalFlex="Fill" LayoutOrder={1}>
                        <Input
                            name="IncrementInput"
                            Size={UDim2.fromScale(0, 0)}
                            scale={props.scale}
                            spacing={props.spacing}
                            controlled={true}
                            validation="Number"
                            min={props.min}
                            max={props.max}
                            value={tostring(current)}
                            TextXAlignment={Enum.TextXAlignment.Center}
                            onChange={(text) => {
                                const parsed = tonumber(text);

                                if (parsed === undefined) {
                                    return;
                                }

                                applyValue(parsed);
                            }}
                        />
                    </FlexItem>

                    <Button
                        name="IncrementButton"
                        icon="plus"
                        intent={props.intent}
                        scale={props.scale}
                        spacing={props.spacing}
                        disabled={incrementDisabled}
                        styleOverride={buttonStyleOverride}
                        LayoutOrder={2}
                        Event={{
                            Activated: () => {
                                const nextValue = resolveSteppedValue(
                                    current,
                                    "increment",
                                    step,
                                    props.min,
                                    props.max,
                                );

                                if (nextValue === undefined) {
                                    return;
                                }

                                applyValue(nextValue);
                            },
                        }}
                    />
                </HStack>
            </Container>
        );
    },
);
