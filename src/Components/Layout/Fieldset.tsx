import React, { Component, ReactComponent } from "@rbxts/react";
import { FlexItem } from "./FlexItem";
import { Container } from "./Container";
import { HStack } from "./HStack";
import { CleanThemeContext } from "../../Contexts";
import { Breakpoint, BreakPointElementProps, BreakpointValue } from "../../Interfaces";
import { BreakpointHelper } from "../../Helpers";


interface FieldsetContextValue {
    disabled: boolean;
}

const FieldsetContext = React.createContext<FieldsetContextValue | undefined>(
    undefined,
);

interface FieldsetProps extends BreakPointElementProps {
    disabled?: boolean;
    wrap?: Breakpoint;
}

interface FieldsetSlotProps {
    children?: React.ReactNode;
}

function FieldsetLabel(props: FieldsetSlotProps) {
    const context = React.useContext(FieldsetContext);

    assert(
        context !== undefined,
        "Fieldset.Label must be used inside a Fieldset",
    );

    return (
        <FlexItem
            mode="Custom"
            ShrinkRatio={0}
            GrowRatio={0}
        >
            {props.children}
        </FlexItem>
    );
}

function FieldsetControl(props: FieldsetSlotProps) {
    const context = React.useContext(FieldsetContext);

    assert(
        context !== undefined,
        "Fieldset.Control must be used inside a Fieldset",
    );

    return (
        <FlexItem
            mode="Custom"
            ShrinkRatio={1}
            GrowRatio={1}
        >
            {props.children}
        </FlexItem>
    );
}

interface FieldsetState {
    width: number;
}

@ReactComponent
export class Fieldset extends Component<FieldsetProps, FieldsetState> {
    public static Label = FieldsetLabel;
    public static Control = FieldsetControl;

    static contextType = CleanThemeContext;

    declare context: React.ContextType<typeof CleanThemeContext>;

    public render() {
        const context: FieldsetContextValue = {
            disabled: this.props.disabled ?? false,
        };

        let wrap = false;

        const breakpoints: BreakpointValue<number> = (this.props.breakpoints !== undefined ? this.props.breakpoints : this.context.breakpoints);
        const breakpoint = BreakpointHelper.getBreakpoint(this.state.width ?? 0, breakpoints)
        if (BreakpointHelper.compare(breakpoint, "<=", this.props.wrap ?? "lg"))
            wrap = true;




        return (
            <FieldsetContext.Provider value={context}>
                <Container Change={{
                    AbsoluteSize: (instance) => {
                        const width = instance.AbsoluteSize.X;

                        if (width !== this.state.width) {
                            this.setState({ width });
                        }
                    },
                }}>
                    <HStack
                        Wraps={wrap}
                        valign="Center"
                        HorizontalFlex={Enum.UIFlexAlignment.Fill}
                    >
                        {this.props.children}
                    </HStack>
                </Container>
            </FieldsetContext.Provider>
        );
    }
}