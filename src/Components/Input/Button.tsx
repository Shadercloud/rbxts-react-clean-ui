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
import { CleanThemeContext } from "../../Contexts/";
import { BoxShadow, Corners, Padding } from "../Decorator";
import { Text } from "../Typography";
import { ColorHelper, SpacingHelper, TypographyHelper } from "../../Helpers";
import { Icon } from "../Surface";
import { HStack } from "../Layout";
import { Group, GroupContext } from "../Layout/";

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
    const theme = React.useContext(CleanThemeContext);
    const [hover, setHover] = React.useState(false);

    const group = React.useContext(GroupContext)

    const padding = SpacingHelper.GetResolvedPadding(theme, props);

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

            Size={UDim2.fromOffset(props.group ? group?.size?.X ?? 0 : 0, 0)}
            AutomaticSize={Enum.AutomaticSize.XY}
            BackgroundTransparency={
                props.BackgroundTransparency ??
                theme.components.button.backgroundTransparency
            }
            BackgroundColor3={ColorHelper.getIntentColor(
                theme,
                props.intent,
                hover ? "hover" : "background",
                theme.components.button.intents,
                props.BackgroundColor3,
            )}
            AutoButtonColor={false}
            ZIndex={props.ZIndex}
        >
            <Corners radius={theme.components.button.cornerRadius} />

            <uistroke
                Thickness={theme.components.button.borderThickness}
                BorderStrokePosition={Enum.BorderStrokePosition.Inner}
                Color={ColorHelper.getIntentColor(
                    theme,
                    props.intent,
                    "border",
                    theme.components.button.intents,
                )}
            />

            <BoxShadow {...props} value={theme.components.button.boxShadow} />
            <Padding {...props} />
            <Group.Element enabled={props.group} padding={padding}>

                {(props.icon !== undefined || props.text !== undefined) &&
                    <HStack valign="Center" spacing={props.spacing}>
                        {props.icon !== undefined &&
                            <Icon
                                scale={props.scale}
                                icon={props.icon}
                                color={
                                    ColorHelper.getIntentColor(
                                        theme,
                                        props.intent,
                                        "text",
                                        theme.components.button.intents,
                                        undefined,
                                        theme.components.button.textColor
                                    )

                                } />
                        }
                        {props.text !== undefined &&
                            <Text
                                text={props.text}
                                typography={TypographyHelper.getTypography(
                                    theme,
                                    props.scale,
                                    theme.components.button.typography
                                )}
                                TextColor3={
                                    ColorHelper.getIntentColor(
                                        theme,
                                        props.intent,
                                        "text",
                                        theme.components.button.intents,
                                        undefined,
                                        theme.components.button.textColor
                                    )
                                } />
                        }
                    </HStack>
                }

                {props.children}
            </Group.Element>
        </imagebutton>
    );
}