import React, { Component } from "@rbxts/react";
import { BreakPointElementProps, SpacedElementProps } from "../../Interfaces/";
import { CleanThemeContext } from "../../Contexts";
interface RowProps extends SpacedElementProps, BreakPointElementProps {
}
interface RowState {
    width: number;
}
export declare class Row extends Component<RowProps, RowState> {
    static contextType: React.Context<import("../..").CleanTheme>;
    context: React.ContextType<typeof CleanThemeContext>;
    state: RowState;
    render(): React.JSX.Element;
}
export {};
