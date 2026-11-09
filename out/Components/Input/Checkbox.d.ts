import React from "@rbxts/react";
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
export declare function Checkbox(props: CheckboxProps): React.JSX.Element;
export {};
