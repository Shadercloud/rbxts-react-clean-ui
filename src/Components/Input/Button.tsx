import React from "@rbxts/react";
import {
    BackgroundElementProps,
    ButtonFlag,
    CssPadding,
    IconElementProps,
    Intent,
    IntentElementProps,
    ScalableElementProps,
    ShadowElementProps,
    SizeElementProps,
    SpacedElementProps,
    ZIndexElementProps,
} from "../../Interfaces/";
import { CleanThemeContext } from "../../Contexts/";
import { BoxShadow, Corners, Gradient, Padding } from "../Decorator";
import { Text } from "../Typography";
import { ColorHelper, CssHelper, SizeHelper, SpacingHelper, TypographyHelper } from "../../Helpers";
import { Icon, IconProps } from "../Surface";
import { HStack } from "../Layout";
import { Group, GroupContext } from "../Layout/";
import { ThemeTemplate } from "../../Theme/theme.template";
import { isPointerPress, PressOn, PressReleaseCallback, usePressRelease } from "./Button.press";

export type ButtonStyleOverride = Partial<ThemeTemplate["components"]["button"]>;

function resolveOwnIntentTransparency(
    intent: Intent | undefined,
    state: ButtonFlag,
    intents: ButtonStyleOverride["intents"],
): number | undefined {
    if (intent === undefined || intent === "primary") {
        return undefined;
    }

    const entry = intents?.[intent];

    return entry?.[state]?.backgroundTransparency ?? entry?.default?.backgroundTransparency;
}

export interface ButtonProps extends
    SpacedElementProps,
    ShadowElementProps,
    ZIndexElementProps,
    BackgroundElementProps,
    IntentElementProps,
    ScalableElementProps,
    IconElementProps,
    Pick<SizeElementProps, "width"> {
    text?: string;
    fontWeight?: Enum.FontWeight;
    Event?: React.InstanceEvent<ImageButton>;
    children?: React.ReactNode;
    group?: boolean;
    disabled?: boolean;
    spinning?: boolean;
    LayoutOrder?: number;
    styleOverride?: ButtonStyleOverride;
    name?: string;
    padding?: CssPadding;
    modal?: boolean;
    fill?: boolean;
    pressOn?: PressOn;
    onRelease?: PressReleaseCallback;
}

export interface ButtonTextProps extends ScalableElementProps, IntentElementProps {
    children?: string;
    text: string;
    disabled?: boolean;
    styleOverride?: ButtonStyleOverride;
    LayoutOrder?: number;
}

function ButtonText(props: ButtonTextProps) {
    const theme = React.useContext(CleanThemeContext);

    return (
        <Text
            name="ButtonText"
            text={props.text}
            typography={TypographyHelper.getTypography(
                theme,
                props.scale,
                { ...theme.components.button.typography, ...props.styleOverride?.typography }
            )}
            LayoutOrder={props.LayoutOrder}
            TextColor3={
                ColorHelper.getIntentColors(
                    theme,
                    props.intent,
                    props.disabled ? "disabled" : "default",
                    theme.components.button.intents,
                    props.styleOverride?.intents,
                ).textColor
            } />
    );
}


export interface ButtonIconProps extends IconProps, IntentElementProps {
    disabled?: boolean;
    styleOverride?: ButtonStyleOverride;
}

function ButtonIcon(props: ButtonIconProps) {
    const theme = React.useContext(CleanThemeContext);
    return <Icon
        name={props.name ?? "ButtonIcon"}
        scale={props.scale}
        icon={props.icon}
        spinning={props.spinning}
        speed={props.speed}
        LayoutOrder={props.LayoutOrder}
        color={
            ColorHelper.getIntentColors(
                theme,
                props.intent,
                props.disabled ? "disabled" : "default",
                theme.components.button.intents,
                props.styleOverride?.intents,
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
        const trackRelease = usePressRelease(props.onRelease);
        const pressDown = props.pressOn === "down";

        const padding = SpacingHelper.GetResolvedPadding(theme, props);

        const state = props.disabled ? "disabled" : hover ? "hover" : "default";

        const intentColors = ColorHelper.getIntentColors(
            theme,
            props.intent,
            state,
            theme.components.button.intents,
            props.styleOverride?.intents,
        );

        const backgroundImage = CssHelper.resolveBackgroundImage(intentColors.backgroundImage);

        const intentBackgroundTransparency = resolveOwnIntentTransparency(
            props.intent,
            state,
            props.styleOverride?.intents,
        ) ?? resolveOwnIntentTransparency(
            props.intent,
            state,
            theme.components.button.intents,
        );

        return (
            <imagebutton
                key={props.name ?? "Button"}
                ref={ref}
                Active={!props.disabled}
                Modal={props.modal ?? false}
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

                        if (pressDown && isPointerPress(inputObject)) {
                            return;
                        }

                        props.Event?.Activated?.(button, inputObject, clickCount);
                    },

                    ...(pressDown ? {
                        InputBegan: (button: ImageButton, inputObject: InputObject) => {
                            props.Event?.InputBegan?.(button, inputObject);

                            if (props.disabled || !isPointerPress(inputObject)) {
                                return;
                            }

                            props.Event?.Activated?.(button, inputObject, 1);

                            if (props.onRelease !== undefined) {
                                trackRelease(button, inputObject);
                            }
                        },
                    } : {}),
                }}

                Size={props.width !== undefined
                    ? SizeHelper.GetSize({ width: props.width })
                    : UDim2.fromOffset(props.group ? group?.size?.X ?? 0 : 0, 0)}
                AutomaticSize={props.width !== undefined
                    ? SizeHelper.GetAutoSize({ width: props.width })
                    : props.fill ? Enum.AutomaticSize.Y : Enum.AutomaticSize.XY}
                BackgroundTransparency={
                    props.BackgroundTransparency ??
                    props.styleOverride?.backgroundTransparency ??
                    intentBackgroundTransparency ??
                    theme.components.button.backgroundTransparency
                }
                BackgroundColor3={intentColors.backgroundColor}
                AutoButtonColor={false}
                LayoutOrder={props.LayoutOrder}
                ZIndex={props.ZIndex}
                BorderSizePixel={0}

                Image={backgroundImage.Image}
                ImageColor3={backgroundImage.ImageColor3}
                ImageTransparency={backgroundImage.ImageTransparency}
                ScaleType={backgroundImage.ScaleType}
                SliceCenter={backgroundImage.SliceCenter}
                SliceScale={backgroundImage.SliceScale}
                TileSize={backgroundImage.TileSize}
            >
                <Corners radius={props.styleOverride?.cornerRadius ?? theme.components.button.cornerRadius} />

                {props.fill && <uiflexitem key="FlexItem" FlexMode={Enum.UIFlexMode.Fill} />}

                <uistroke
                    key="Stroke"
                    Thickness={intentColors.borderThickness ?? props.styleOverride?.borderThickness ?? theme.components.button.borderThickness}
                    BorderStrokePosition={Enum.BorderStrokePosition.Inner}
                    Color={intentColors.borderColor}
                />

                <BoxShadow {...props} value={props.styleOverride?.boxShadow ?? theme.components.button.boxShadow} />
                <Gradient value={intentColors.backgroundGradient} />
                <Padding {...props} />
                <Group.Element enabled={props.group} padding={padding}>

                    {(props.icon !== undefined || props.text !== undefined) &&
                        <HStack
                            valign="Center"
                            spacing={props.spacing}
                            Wraps={false}
                            HorizontalAlignment={props.fill || props.width !== undefined ? Enum.HorizontalAlignment.Center : undefined}>
                            {props.icon !== undefined &&
                                <ButtonIcon
                                    LayoutOrder={1}
                                    scale={props.scale}
                                    intent={props.intent}
                                    disabled={props.disabled}
                                    icon={props.icon}
                                    spinning={props.spinning}
                                    styleOverride={props.styleOverride} />
                            }
                            {props.text !== undefined &&
                                <ButtonText
                                    LayoutOrder={2}
                                    text={props.text}
                                    intent={props.intent}
                                    disabled={props.disabled}
                                    scale={props.scale}
                                    styleOverride={props.styleOverride} />
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