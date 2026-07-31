import React from "@rbxts/react";
import { RowContext } from "../../Contexts/";
import { Breakpoint, ResponsiveGridSpan } from "../../Interfaces/";
import { BreakpointHelper } from "../../Helpers/";


interface ColumnProps {
    span?: ResponsiveGridSpan | number | `${number}`;
}

function resolveSpan(
    span: ColumnProps["span"],
    children: number,
    breakpoint: Breakpoint,
): number {
    if (span === undefined) {
        return math.floor(12 / math.max(children, 1));
    }

    if (typeIs(span, "number")) {
        return span;
    }

    if (typeIs(span, "string")) {
        return tonumber(span) ?? 12;
    }

    return BreakpointHelper.getValue(breakpoint, span) ?? 12;
}

export const Column = React.forwardRef<Frame, ColumnProps>(
    (props, ref) => {

        const context = React.useContext(RowContext);

        const span = resolveSpan(props.span, context.children, context.breakpoint);

        const fraction = math.floor((span / 12) * 1000) / 1000;
        const padding = context.padding;

        const widthScale =
            fraction + ((fraction - 1) * padding.Scale);

        const widthOffset =
            (fraction - 1) * padding.Offset;

        return (
            <frame
                ref={ref}
                Size={new UDim2(widthScale, widthOffset, 0, 0)}
                AutomaticSize={Enum.AutomaticSize.Y}
                BackgroundTransparency={1}
            >
                {props.children}
            </frame >
        );
    });