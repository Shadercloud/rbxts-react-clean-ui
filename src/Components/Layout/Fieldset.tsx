import React, { Component, ReactComponent } from "@rbxts/react";
import { FlexItem } from "./FlexItem";
import { Container } from "./Container";
import { HStack } from "./HStack";
import { CleanThemeContext } from "../../Contexts";
import { Breakpoint, BreakPointElementProps, BreakpointValue } from "../../Interfaces";
import { BreakpointHelper } from "../../Helpers";


export interface FieldsetContextValue {
    disabled: boolean;
    checkbox: boolean;
    labelActivated?: BindableEvent;
}

export const FieldsetContext = React.createContext<FieldsetContextValue | undefined>(
    undefined,
);

interface FieldsetProps extends BreakPointElementProps {
    disabled?: boolean;
    checkbox?: boolean;
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
            <imagebutton Size={UDim2.fromOffset(0, 0)} BackgroundTransparency={1} AutomaticSize={Enum.AutomaticSize.XY}
            Event={{
                Activated: () => {
                    context.labelActivated?.Fire();
                }
            }}>
                {props.children}
            </imagebutton>
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
            ShrinkRatio={context.checkbox ? 0 : 1}
            GrowRatio={context.checkbox ? 0 : 1}
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

    private readonly labelActivated = new Instance("BindableEvent");

    private fieldsetContext: FieldsetContextValue = {
        disabled: false,
        checkbox: false,
        labelActivated: this.labelActivated,
    };

    private getFieldsetContext(): FieldsetContextValue {
        const disabled = this.props.disabled ?? false;
        const checkbox = this.props.checkbox ?? false;

        if (
            this.fieldsetContext.disabled !== disabled ||
            this.fieldsetContext.checkbox !== checkbox
        ) {
            this.fieldsetContext = {
                disabled,
                checkbox,
                labelActivated: this.labelActivated,
            };
        }

        return this.fieldsetContext;
    }

    public componentWillUnmount() {
        this.labelActivated.Destroy();
    }

    public render() {
        const context = this.getFieldsetContext();

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