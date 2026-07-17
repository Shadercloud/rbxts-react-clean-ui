import React from "@rbxts/react";
import {
    BackgroundElementProps,
    IconElementProps,
    IntentElementProps,
    ScalableElementProps,
    ShadowElementProps,
    SpacedElementProps,
    ZIndexElementProps,
} from "../../Interfaces/";
import { CleanThemeContext, useGroupElement } from "../../Contexts/";
import { BoxShadow, Corners, Padding } from "../Decorator";
import { Text } from "../Typography";
import { ColorHelper, SpacingHelper, TypographyHelper } from "../../Helpers";
import { Icon } from "../Surface";
import { GroupMeasurement, HStack } from "../Layout";

export interface ButtonProps extends
    SpacedElementProps,
    ShadowElementProps,
    ZIndexElementProps,
    BackgroundElementProps,
    IntentElementProps,
    ScalableElementProps,
    IconElementProps {
    text?: string;
    fontWeight?: Enum.FontWeight;
    Event?: React.InstanceEvent<ImageButton>;
    children?: React.ReactNode;
    group?: boolean;
}

export function Button(props: ButtonProps) {
    const context = React.useContext(CleanThemeContext);
    const [hover, setHover] = React.useState(false);

    const group = useGroupElement(props.group);

    const padding = SpacingHelper.GetResolvedPadding(context, props);

    return (
        <imagebutton
            Event={{
                ...props.Event,

                MouseEnter: (button, x, y) => {
                    setHover(true);

                    props.Event?.MouseEnter?.(button, x, y);
                },

                MouseLeave: (button, x, y) => {
                    setHover(false);

                    props.Event?.MouseLeave?.(button, x, y);
                },

            }}

            Size={UDim2.fromOffset(group?.groupSize?.X ?? 0, 0)}
            AutomaticSize={Enum.AutomaticSize.XY}
            BackgroundTransparency={
                props.BackgroundTransparency ??
                context.components.button.backgroundTransparency
            }
            BackgroundColor3={ColorHelper.getIntentColor(
                context,
                props.intent,
                hover ? "hover" : "background",
                context.components.button.intents,
                props.BackgroundColor3,
            )}
            AutoButtonColor={false}
            ZIndex={props.ZIndex}
        >
            <Corners radius={context.components.button.cornerRadius} />

            <uistroke
                Thickness={context.components.button.borderThickness}
                BorderStrokePosition={Enum.BorderStrokePosition.Inner}
                Color={ColorHelper.getIntentColor(
                    context,
                    props.intent,
                    "border",
                    context.components.button.intents,
                )}
            />

            <BoxShadow {...props} value={context.components.button.boxShadow} />
            <Padding {...props} />
            <GroupMeasurement enabled={props.group} group={group} padding={padding}>

                {(props.icon !== undefined || props.text !== undefined) &&
                    <HStack valign="Center" spacing={props.spacing}>
                        {props.icon !== undefined &&
                            <Icon
                                scale={props.scale}
                                icon={props.icon}
                                color={
                                    ColorHelper.getIntentColor(
                                        context,
                                        props.intent,
                                        "text",
                                        context.components.button.intents,
                                        undefined,
                                        context.components.button.textColor
                                    )

                                } />
                        }
                        {props.text !== undefined &&
                            <Text
                                text={props.text}
                                typography={TypographyHelper.getTypography(
                                    context,
                                    props.scale,
                                    context.components.button.typography
                                )}
                                TextColor3={
                                    ColorHelper.getIntentColor(
                                        context,
                                        props.intent,
                                        "text",
                                        context.components.button.intents,
                                        undefined,
                                        context.components.button.textColor
                                    )
                                } />
                        }
                    </HStack>
                }

                {props.children}
            </GroupMeasurement>
        </imagebutton>
    );
}