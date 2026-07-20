import React, { Component } from "@rbxts/react";
import { CleanThemeContext } from "../../Contexts";
import { Breakpoint, BreakPointElementProps } from "../../Interfaces";
interface FieldsetProps extends BreakPointElementProps {
    disabled?: boolean;
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
    render(): React.JSX.Element;
}
export {};
