import React from "@rbxts/react";
import { Icon } from "../Surface";
import { CleanThemeContext } from "../../Contexts";
import { FieldsetContext } from "../Layout";
import { Corners, Gradient, Padding } from "../Decorator";
import { ColorHelper, CssHelper, SpacingHelper } from "../../Helpers";
import { BackgroundElementProps, IconName, Intent, IntentElementProps, PaddingProps, ScalableElementProps, SpacedElementProps } from "../../Interfaces";

interface CheckboxProps extends IntentElementProps, PaddingProps, BackgroundElementProps, SpacedElementProps, ScalableElementProps {
    checked?: boolean;
    onChange?: (value: boolean) => void;
    'icon-checked'?: IconName;
    'icon-unchecked'?: IconName;
    'intent-checked'?: Intent;
    'intent-unchecked'?: Intent;
    name?: string;

}

export function Checkbox(props: CheckboxProps) {
    const theme = React.useContext(CleanThemeContext);
    const fieldset = React.useContext(FieldsetContext);

    const [checked, setChecked] = React.useState(props.checked ?? false);

    React.useEffect(() => {
        if (!fieldset) {
            return;
        }

        const connection = fieldset.labelActivated?.Event.Connect(() => {
            setChecked((current) => !current);
        });

        return () => {
            connection?.Disconnect();
        };
    }, [fieldset]);

    React.useEffect(() => {
        props.onChange?.(checked);
    }, [checked]);

    const backgroundImage = CssHelper.resolveBackgroundImage(theme.components.checkbox.backgroundImage);

    return <imagebutton
        key={props.name ?? "Checkbox"}
        Size={UDim2.fromOffset(0, 0)}
        AutomaticSize={Enum.AutomaticSize.XY}
        Event={{
            Activated: () => {
                setChecked(!checked);
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
            theme.components.button.intents,
        ).backgroundColor}
        AutoButtonColor={false}

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
    </imagebutton>

}