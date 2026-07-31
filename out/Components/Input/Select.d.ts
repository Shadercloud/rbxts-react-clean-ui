import React from "@rbxts/react";
import { CssSize, ScalableElementProps, SpacedElementProps } from "../../Interfaces";
interface SelectProps extends ScalableElementProps, SpacedElementProps, React.InstanceProps<TextBox> {
    selected?: number;
    'max-height'?: CssSize;
    onChange?: (selected: number, value?: string) => void;
    Event?: React.InstanceEvent<TextBox>;
}
interface SelectOptionProps {
    text?: string;
    children?: React.ReactNode;
    Event?: React.InstanceEvent<ImageButton>;
    index?: number;
    value?: string;
    BackgroundColor3?: Color3;
}
declare function SelectOption(props: SelectOptionProps): React.JSX.Element;
type SelectComponent = React.ForwardRefExoticComponent<SelectProps & React.RefAttributes<Frame>> & {
    Option: typeof SelectOption;
};
declare const Select: SelectComponent;
export { Select };
