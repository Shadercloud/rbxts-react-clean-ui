import React from "@rbxts/react";
import { Icon } from "../Surface";
import { CleanThemeContext } from "../../Contexts";
import { FieldsetContext, HStack } from "../Layout";
import { Text } from "../Typography";
import { Corners, Gradient, Padding } from "../Decorator";
import { ColorHelper, CssHelper, SpacingHelper, TypographyHelper } from "../../Helpers";
import { BackgroundElementProps, IconName, Intent, IntentElementProps, PaddingProps, ScalableElementProps, SpacedElementProps } from "../../Interfaces";

interface CheckboxProps extends IntentElementProps, PaddingProps, BackgroundElementProps, SpacedElementProps, ScalableElementProps {
    checked?: boolean;
    defaultChecked?: boolean;
    onChange?: (value: boolean) => void;
    'icon-checked'?: IconName;
    'icon-unchecked'?: IconName;
    'intent-checked'?: Intent;
    'intent-unchecked'?: Intent;
    label?: string;
    name?: string;

}

export function Checkbox(props: CheckboxProps) {
    const theme = React.useContext(CleanThemeContext);
    const fieldset = React.useContext(FieldsetContext);

    const controlled = props.checked !== undefined;
    const [internalChecked, setInternalChecked] = React.useState(props.defaultChecked ?? false);
    const checked = controlled ? props.checked === true : internalChecked;

    const requestChange = (value: boolean) => {
        if (!controlled) {
            setInternalChecked(value);
        }

        props.onChange?.(value);
    };

    const toggleRef = React.useRef<() => void>();
    toggleRef.current = () => requestChange(!checked);

    React.useEffect(() => {
        if (!fieldset) {
            return;
        }

        const connection = fieldset.labelActivated?.Event.Connect(() => {
            toggleRef.current?.();
        });

        return () => {
            connection?.Disconnect();
        };
    }, [fieldset]);

    const backgroundImage = CssHelper.resolveBackgroundImage(theme.components.checkbox.backgroundImage);

    const box = <imagebutton
        key={props.label !== undefined ? "CheckboxBox" : props.name ?? "Checkbox"}
        Size={UDim2.fromOffset(0, 0)}
        AutomaticSize={Enum.AutomaticSize.XY}
        LayoutOrder={props.label !== undefined ? 1 : undefined}
        Event={{
            Activated: () => {
                requestChange(!checked);
            }
        }}
        BackgroundTransparency={
            props.BackgroundTransparency ??
            theme.components.button.backgroundTransparency
        }
        BackgroundColor3={ColorHelper.getIntentColors(
            theme,
            props.intent,
            "default",
            theme.components.checkbox.intents,
        ).backgroundColor}
        AutoButtonColor={false}
        BorderSizePixel={0}

        Image={backgroundImage.Image}
        ImageColor3={backgroundImage.ImageColor3}
        ImageTransparency={backgroundImage.ImageTransparency}
        ScaleType={backgroundImage.ScaleType}
        SliceCenter={backgroundImage.SliceCenter}
        SliceScale={backgroundImage.SliceScale}
        TileSize={backgroundImage.TileSize}
    >
        <Corners radius={theme.components.checkbox.cornerRadius} />
        <Gradient value={theme.components.checkbox.backgroundGradient} />
        <uistroke
            key="Stroke"
            Thickness={theme.components.checkbox.borderThickness}
            BorderStrokePosition={Enum.BorderStrokePosition.Inner}
            Transparency={theme.components.checkbox.borderTransparency ?? 0}
            Color={ColorHelper.getIntentColors(
                theme,
                checked ? props['intent-checked'] ?? "success" : props['intent-unchecked'] ?? "primary",
                "default",
                theme.components.checkbox.intents,
            ).borderColor}
        />


        <Padding resolvedPadding={SpacingHelper.GetResolvedPadding(theme, props, theme.components.checkbox.spacing, theme.components.checkbox.padding)} />
        <Icon
            name="CheckboxIcon"
            scale={props.scale}
            icon={checked ? props['icon-checked'] ?? "check" : props['icon-unchecked']}
            color={
                ColorHelper.getIntentColors(
                    theme,
                    checked ? props['intent-checked'] ?? "success" : props['intent-unchecked'] ?? "primary",
                    "default",
                    theme.components.checkbox.intents,
                ).textColor
            } />
    </imagebutton>;

    if (props.label === undefined) {
        return box;
    }

    const labelTheme = theme.components.checkbox.label;

    return (
        <frame
            key={props.name ?? "Checkbox"}
            Size={UDim2.fromOffset(0, 0)}
            AutomaticSize={Enum.AutomaticSize.XY}
            BackgroundTransparency={1}
            BorderSizePixel={0}
        >
            <HStack
                valign="Center"
                Wraps={false}
                Padding={new UDim(0, labelTheme?.gap ?? math.ceil(SpacingHelper.GetPadding(theme, props.scale, theme.components.checkbox.spacing) / 2))}
            />
            {box}
            <imagebutton
                key="CheckboxLabel"
                LayoutOrder={2}
                Size={UDim2.fromOffset(0, 0)}
                AutomaticSize={Enum.AutomaticSize.XY}
                BackgroundTransparency={1}
                BorderSizePixel={0}
                AutoButtonColor={false}
                Selectable={false}
                Event={{
                    Activated: () => {
                        requestChange(!checked);
                    }
                }}
            >
                <Text
                    name="CheckboxLabelText"
                    text={props.label}
                    TextWrap={false}
                    typography={TypographyHelper.getTypography(theme, props.scale, labelTheme?.typography)}
                    TextColor3={labelTheme?.textColor}
                />
            </imagebutton>
        </frame>
    );
}
