import React from "@rbxts/react";
import { BackgroundElementProps, IconName, Intent, IntentElementProps, PaddingProps, ScalableElementProps, SpacedElementProps } from "../../Interfaces";
interface CheckboxProps extends IntentElementProps, PaddingProps, BackgroundElementProps, SpacedElementProps, ScalableElementProps {
    onChange?: (value: boolean) => void;
    'icon-checked'?: IconName;
    'icon-unchecked'?: IconName;
    'intent-checked'?: Intent;
    'intent-unchecked'?: Intent;
}
export declare function Checkbox(props: CheckboxProps): React.JSX.Element;
export {};
