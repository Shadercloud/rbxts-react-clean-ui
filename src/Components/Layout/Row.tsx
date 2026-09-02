import React from "@rbxts/react";
import { Column } from "./Column";
import { BreakPointElementProps, BreakpointValue, SpacedElementProps } from "../../Interfaces/";
import { CleanThemeContext, RowContext } from "../../Contexts";
import { BreakpointHelper, SpacingHelper } from "../../Helpers/";

interface RowProps extends SpacedElementProps, BreakPointElementProps {
    name?: string;
}


export const Row = React.forwardRef<Frame, RowProps>(
    (props, ref) => {

        const theme = React.useContext(CleanThemeContext);

        const [width, setWidth] = React.useState<number>(0);

        const breakpoints = props.breakpoints ?? theme.breakpoints;
        const padding = new UDim(0, SpacingHelper.GetPadding(theme, props.spacing))

        return (
            <frame
                key={props.name ?? "Row"}
                ref={ref}
                Size={UDim2.fromScale(1, 1)}
                AutomaticSize={Enum.AutomaticSize.Y}
                BackgroundTransparency={1}
                Change={{
                    AbsoluteSize: (instance) => {
                        const nextWidth = instance.AbsoluteSize.X;

                        setWidth((currentWidth) =>
                            currentWidth === nextWidth ? currentWidth : nextWidth
                        );
                    },
                }}
            >
                <uilistlayout
                    key="RowLayout"
                    FillDirection={Enum.FillDirection.Horizontal}
                    SortOrder={Enum.SortOrder.LayoutOrder}
                    Padding={padding}
                    Wraps={true}
                />

                <RowContext.Provider
                    value={{
                        width: width,
                        children: React.Children.toArray(props.children).filter(
                            (child) =>
                                React.isValidElement(child) &&
                                child.type === Column,
                        ).size(),
                        padding: padding,
                        breakpoint: BreakpointHelper.getBreakpoint(width, breakpoints),
                    }}
                >
                    {props.children}
                </RowContext.Provider>
            </frame >
        );
    }
);