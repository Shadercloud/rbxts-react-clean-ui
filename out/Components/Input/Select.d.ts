import React from "@rbxts/react";
import { CssBackgroundGradient, CssSize, ScalableElementProps, SizeElementProps, SpacedElementProps } from "../../Interfaces";
import { CssBackgroundImage } from "../../Theme";
export interface SelectProps extends ScalableElementProps, SpacedElementProps, Pick<SizeElementProps, "width">, React.InstanceProps<ImageLabel> {
    selected?: number;
    'max-height'?: CssSize;
    backgroundImage?: CssBackgroundImage;
    backgroundGradient?: CssBackgroundGradient;
    onChange?: (selected: number, value?: string) => void;
    name?: string;
    searchable?: boolean;
    searchPlaceholder?: string;
    disabled?: boolean;
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
