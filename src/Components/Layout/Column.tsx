import React, { Component, ReactComponent } from "@rbxts/react";
import { RowContext } from "../../Contexts/";
import { ResponsiveGridSpan } from "../../Interfaces/";
import { BreakpointHelper } from "../../Helpers/";


interface ColumnProps {
    span?: ResponsiveGridSpan | number | `${number}`;
}

@ReactComponent
export class Column extends Component<ColumnProps> {
    public static contextType = RowContext;

    public declare context: React.ContextType<typeof RowContext>;

    private getSpan(): number {
        const span = this.props.span;

        if (span === undefined) {
            return math.floor(
                12 / math.max(this.context.children, 1),
            );
        }

        if (typeIs(span, "number")) {
            return span;
        }

        if (typeIs(span, "string")) {
            return tonumber(span) ?? 12;
        }

        return BreakpointHelper.getValue(
            this.context.breakpoint,
            span,
        ) ?? 12;
    }

    public render() {
        const span = this.getSpan();

        const fraction = math.floor((span / 12) * 1000) / 1000;
        const padding = this.context.padding;

        const widthScale =
            fraction + ((fraction - 1) * padding.Scale);

        const widthOffset =
            (fraction - 1) * padding.Offset;

        return (
            <frame
                Size={new UDim2(widthScale, widthOffset, 0, 0)}
                AutomaticSize={Enum.AutomaticSize.Y}
                BackgroundTransparency={1}
            >
                {this.props.children}
            </frame>
        );
    }
}