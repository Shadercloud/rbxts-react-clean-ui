import React, { Component } from "@rbxts/react";
import { CssSize, ScalableElementProps, SpacedElementProps } from "../../Interfaces";
interface SelectProps extends ScalableElementProps, SpacedElementProps, React.InstanceProps<TextBox> {
    selected?: number;
    'max-height'?: CssSize;
    onChange?: (value: number) => void;
    Event?: React.InstanceEvent<TextBox>;
}
interface SelectState {
    selected: number;
    open: boolean;
    dropdownSize: UDim2;
    dropdownPosition: UDim2;
}
interface SelectOptionProps {
    text?: string;
    children?: React.ReactNode;
    Event?: React.InstanceEvent<ImageButton>;
    index?: number;
    BackgroundColor3?: Color3;
}
declare function SelectOption(props: SelectOptionProps): React.JSX.Element;
declare class Select extends Component<SelectProps, SelectState> {
    static Option: typeof SelectOption;
    state: SelectState;
    private buttonRef;
    render(): React.JSX.Element;
}
export { Select };
