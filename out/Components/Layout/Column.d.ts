import React, { Component } from "@rbxts/react";
import { RowContext } from "../../Contexts/";
import { ResponsiveGridSpan } from "../../Interfaces/";
interface ColumnProps {
    span?: ResponsiveGridSpan | number | `${number}`;
}
export declare class Column extends Component<ColumnProps> {
    static contextType: React.Context<import("../../Contexts/row.context").RowContextValue>;
    context: React.ContextType<typeof RowContext>;
    private getSpan;
    render(): React.JSX.Element;
}
export {};
