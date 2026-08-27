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
import { ColorHelper, CssHelper, SpacingHelper, TypographyHelper } from "../../Helpers";
import { Icon, IconProps } from "../Surface";
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
    disabled?: boolean;
    LayoutOrder?: number;
}

export interface ButtonTextProps extends ScalableElementProps, IntentElementProps {
    children?: string;
    text: string;
    disabled?: boolean;
}

function ButtonText(props: ButtonTextProps) {
    const theme = React.useContext(CleanThemeContext);

    return (
        <Text
            text={props.text}
            typography={TypographyHelper.getTypography(
                theme,
                props.scale,
                theme.components.button.typography
            )}
            TextColor3={
                ColorHelper.getIntentColors(
                    theme,
                    props.intent,
                    props.disabled ? "disabled" : "default",
                    theme.components.button.intents,
                ).textColor
            } />
    );
}


export interface ButtonIconProps extends IconProps, IntentElementProps {
    disabled?: boolean;
}

function ButtonIcon(props: ButtonIconProps) {
    const theme = React.useContext(CleanThemeContext);
    return <Icon
        scale={props.scale}
        icon={props.icon}
        spinning={props.spinning}
        speed={props.speed}
        color={
            ColorHelper.getIntentColors(
                theme,
                props.intent,
                props.disabled ? "disabled" : "default",
                theme.components.button.intents,
            ).textColor

        } />
}

type ButtonComponent = React.ForwardRefExoticComponent<
    ButtonProps & React.RefAttributes<ImageButton>
> & {
    Text: typeof ButtonText;
    Icon: typeof ButtonIcon;
};

const Button = React.forwardRef<ImageButton, ButtonProps>(
    (props, ref) => {
        const theme = React.useContext(CleanThemeContext);
        const [hover, setHover] = React.useState(false);

        React.useEffect(() => {
            if (props.disabled) {
                setHover(false);
            }
        }, [props.disabled]);

        const group = React.useContext(GroupContext)

        const padding = SpacingHelper.GetResolvedPadding(theme, props);

        const state = props.disabled ? "disabled" : hover ? "hover" : "default";

        const intentColors = ColorHelper.getIntentColors(
            theme,
            props.intent,
            state,
            theme.components.button.intents,
        );

        const backgroundImage = CssHelper.resolveBackgroundImage(intentColors.backgroundImage);

        return (
            <imagebutton
                ref={ref}
                Active={!props.disabled}
                Event={{
                    ...props.Event,

                    MouseEnter: (button, x, y) => {
                        if (!props.disabled) {
                            setHover(true);
                        }

                        props.Event?.MouseEnter?.(button, x, y);
                    },

                    MouseLeave: (button, x, y) => {
                        if (!props.disabled) {
                            setHover(false);
                        }

                        props.Event?.MouseLeave?.(button, x, y);
                    },

                    Activated: (button, inputObject, clickCount) => {
                        if (props.disabled) {
                            return;
                        }

                        props.Event?.Activated?.(button, inputObject, clickCount);
                    },
                }}

                Size={UDim2.fromOffset(props.group ? group?.size?.X ?? 0 : 0, 0)}
                AutomaticSize={Enum.AutomaticSize.XY}
                BackgroundTransparency={
                    props.BackgroundTransparency ??
                    theme.components.button.backgroundTransparency
                }
                BackgroundColor3={intentColors.backgroundColor}
                AutoButtonColor={false}
                LayoutOrder={props.LayoutOrder}
                ZIndex={props.ZIndex}

                Image={backgroundImage.Image}
                ImageColor3={backgroundImage.ImageColor3}
                ImageTransparency={backgroundImage.ImageTransparency}
                ScaleType={backgroundImage.ScaleType}
                SliceCenter={backgroundImage.SliceCenter}
                SliceScale={backgroundImage.SliceScale}
                TileSize={backgroundImage.TileSize}
            >
                <Corners radius={theme.components.button.cornerRadius} />

                <uistroke
                    Thickness={theme.components.button.borderThickness}
                    BorderStrokePosition={Enum.BorderStrokePosition.Inner}
                    Color={intentColors.borderColor}
                />

                <BoxShadow {...props} value={theme.components.button.boxShadow} />
                <Padding {...props} />
                <Group.Element enabled={props.group} padding={padding}>

                    {(props.icon !== undefined || props.text !== undefined) &&
                        <HStack valign="Center" spacing={props.spacing} Wraps={false}>
                            {props.icon !== undefined &&
                                <ButtonIcon
                                    scale={props.scale}
                                    intent={props.intent}
                                    disabled={props.disabled}
                                    icon={props.icon} />
                            }
                            {props.text !== undefined &&
                                <ButtonText
                                    text={props.text}
                                    intent={props.intent}
                                    disabled={props.disabled}
                                    scale={props.scale} />
                            }
                        </HStack>
                    }

                    {props.children}
                </Group.Element>
            </imagebutton>
        );
    }) as ButtonComponent

Button.Text = ButtonText;
Button.Icon = ButtonIcon;

export { Button }