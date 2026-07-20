import React, { Component, ReactComponent } from "@rbxts/react";
import { Column } from "./Column";
import { BreakPointElementProps, BreakpointValue, SpacedElementProps } from "../../Interfaces/";
import { CleanThemeContext, RowContext } from "../../Contexts";
import { BreakpointHelper, SpacingHelper } from "../../Helpers/";

interface RowProps extends SpacedElementProps, BreakPointElementProps {
}

interface RowState {
    width: number;
}

@ReactComponent
export class Row extends Component<RowProps, RowState> {
    static contextType = CleanThemeContext;

    declare context: React.ContextType<typeof CleanThemeContext>;

    public state: RowState = {
        width: 0,
    };

    public render() {
        const breakpoints: BreakpointValue<number> = (this.props.breakpoints !== undefined ? this.props.breakpoints : this.context.breakpoints)
        const padding = new UDim(0, SpacingHelper.GetPadding(this.context, this.props.spacing))

        return (
            <frame
                Size={UDim2.fromScale(1, 1)}
                AutomaticSize={Enum.AutomaticSize.Y}
                BackgroundTransparency={1}
                Change={{
                    AbsoluteSize: (instance) => {
                        const width = instance.AbsoluteSize.X;

                        if (width !== this.state.width) {
                            this.setState({ width });
                        }
                    },
                }}
            >
                <uilistlayout
                    FillDirection={Enum.FillDirection.Horizontal}
                    SortOrder={Enum.SortOrder.LayoutOrder}
                    Padding={padding}
                    Wraps={true}
                />

                <RowContext.Provider
                    value={{
                        width: this.state.width,
                        children: React.Children.toArray(this.props.children).filter(
                            (child) =>
                                React.isValidElement(child) &&
                                child.type === Column,
                        ).size(),
                        padding: padding,
                        breakpoint: BreakpointHelper.getBreakpoint(this.state.width, breakpoints),
                    }}
                >
                    {this.props.children}
                </RowContext.Provider>
            </frame >
        );
    }
}