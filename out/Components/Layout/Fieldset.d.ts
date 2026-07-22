import React, { Component } from "@rbxts/react";
import { CleanThemeContext } from "../../Contexts";
import { Breakpoint, BreakPointElementProps } from "../../Interfaces";
export interface FieldsetContextValue {
    disabled: boolean;
    checkbox: boolean;
    labelActivated?: BindableEvent;
}
export declare const FieldsetContext: React.Context<FieldsetContextValue | undefined>;
interface FieldsetProps extends BreakPointElementProps {
    disabled?: boolean;
    checkbox?: boolean;
    wrap?: Breakpoint;
}
interface FieldsetSlotProps {
    children?: React.ReactNode;
}
declare function FieldsetLabel(props: FieldsetSlotProps): React.JSX.Element;
declare function FieldsetControl(props: FieldsetSlotProps): React.JSX.Element;
interface FieldsetState {
    width: number;
}
export declare class Fieldset extends Component<FieldsetProps, FieldsetState> {
    static Label: typeof FieldsetLabel;
    static Control: typeof FieldsetControl;
    static contextType: React.Context<import("../..").CleanTheme>;
    context: React.ContextType<typeof CleanThemeContext>;
    private readonly labelActivated;
    private fieldsetContext;
    private getFieldsetContext;
    componentWillUnmount(): void;
    render(): React.JSX.Element;
}
export {};
