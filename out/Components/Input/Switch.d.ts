import React from "@rbxts/react";
import { BackgroundElementProps, IntentElementProps, ZIndexElementProps } from "../../Interfaces";
export interface SwitchProps extends IntentElementProps, BackgroundElementProps, ZIndexElementProps {
    checked?: boolean;
    onChange?: (value: boolean) => void;
    disabled?: boolean;
    name?: string;
}
export declare function Switch(props: SwitchProps): React.JSX.Element;
