import React from "@rbxts/react";
import { CssSize, ScalableElementProps, SpacedElementProps } from "../../Interfaces";
import { CssBackgroundImage } from "../../Theme";
export interface SelectProps extends ScalableElementProps, SpacedElementProps, React.InstanceProps<ImageLabel> {
    selected?: number;
    'max-height'?: CssSize;
    backgroundImage?: CssBackgroundImage;
    onChange?: (selected: number, value?: string) => void;
    name?: string;
    searchable?: boolean;
    searchPlaceholder?: string;
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
interface SelectOptGroupProps {
    label: string;
    children?: React.ReactNode;
}
declare function SelectOptGroup(_props: SelectOptGroupProps): undefined;
type SelectComponent = React.ForwardRefExoticComponent<SelectProps & React.RefAttributes<ImageLabel>> & {
    Option: typeof SelectOption;
    OptGroup: typeof SelectOptGroup;
};
declare const Select: SelectComponent;
export { Select };
