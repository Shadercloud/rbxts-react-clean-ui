import React from "@rbxts/react";
import { Breakpoint, BreakPointElementProps } from "../../Interfaces";
export interface FieldsetContextValue {
    disabled: boolean;
    checkbox: boolean;
    labelActivated: BindableEvent;
}
export declare const FieldsetContext: React.Context<FieldsetContextValue | undefined>;
interface FieldsetProps extends BreakPointElementProps {
    disabled?: boolean;
    checkbox?: boolean;
    wrap?: Breakpoint;
    name?: string;
}
interface FieldsetSlotProps {
    children?: React.ReactNode;
}
declare function FieldsetLabel(props: FieldsetSlotProps): React.JSX.Element;
declare function FieldsetControl(props: FieldsetSlotProps): React.JSX.Element;
type FieldsetComponent = React.ForwardRefExoticComponent<FieldsetProps & React.RefAttributes<ImageLabel>> & {
    Label: typeof FieldsetLabel;
    Control: typeof FieldsetControl;
};
declare const Fieldset: FieldsetComponent;
export { Fieldset };
