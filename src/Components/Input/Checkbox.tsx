import React from "@rbxts/react";
import { Icon } from "../Surface";
import { CleanThemeContext } from "../../Contexts";
import { FieldsetContext } from "../Layout";
import { Corners, Padding } from "../Decorator";
import { ColorHelper, SpacingHelper } from "../../Helpers";
import { BackgroundElementProps, IconName, Intent, IntentElementProps, PaddingProps, ScalableElementProps, SpacedElementProps } from "../../Interfaces";

interface CheckboxProps extends IntentElementProps, PaddingProps, BackgroundElementProps, SpacedElementProps, ScalableElementProps {
    checked?: boolean;
    onChange?: (value: boolean) => void;
    'icon-checked'?: IconName;
    'icon-unchecked'?: IconName;
    'intent-checked'?: Intent;
    'intent-unchecked'?: Intent;

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

    return <imagebutton
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
        BackgroundColor3={ColorHelper.getIntentColor(
            theme,
            props.intent,
            "background",
            theme.components.button.intents,
            props.BackgroundColor3,
        )}
        AutoButtonColor={false}
    >
        <Corners radius={theme.components.checkbox.cornerRadius} />
        <uistroke
            Thickness={theme.components.button.borderThickness}
            BorderStrokePosition={Enum.BorderStrokePosition.Inner}
            Color={ColorHelper.getIntentColor(
                theme,
                checked ? props['intent-checked'] ?? "success" : props['intent-unchecked'] ?? "primary",
                "border",
                theme.components.checkbox.intents,
            )}
        />


        <Padding resolvedPadding={SpacingHelper.GetResolvedPadding(theme, props, theme.components.checkbox.spacing)} />
        <Icon
            scale={props.scale}
            icon={checked ? props['icon-checked'] ?? "check" : props['icon-unchecked']}
            color={
                ColorHelper.getIntentColor(
                    theme,
                    checked ? props['intent-checked'] ?? "success" : props['intent-unchecked'] ?? "primary",
                    "text",
                    theme.components.checkbox.intents,
                    props.BackgroundColor3,
                )
            } />
    </imagebutton>

}