import React from "@rbxts/react";
import { FlexItem } from "./FlexItem";
import { Container } from "./Container";
import { HStack } from "./HStack";
import { CleanThemeContext } from "../../Contexts";
import { Breakpoint, BreakPointElementProps } from "../../Interfaces";
import { BreakpointHelper } from "../../Helpers";


export interface FieldsetContextValue {
    disabled: boolean;
    checkbox: boolean;
    labelActivated: BindableEvent;
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
                        context.labelActivated.Fire();
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


type FieldsetComponent = React.ForwardRefExoticComponent<
    FieldsetProps & React.RefAttributes<ImageLabel>
> & {
    Label: typeof FieldsetLabel;
    Control: typeof FieldsetControl;
};

const Fieldset = React.forwardRef<ImageLabel, FieldsetProps>(
    (props, ref) => {

        const theme = React.useContext(CleanThemeContext);

        const [width, setWidth] = React.useState<number>(0);

        const labelActivated = React.useRef(new Instance("BindableEvent")).current;

        React.useEffect(() => {
            return () => {
                labelActivated.Destroy();
            };
        }, []);

        const fieldsetContext = React.useMemo<FieldsetContextValue>(() => {
            return {
                disabled: props.disabled ?? false,
                checkbox: props.checkbox ?? false,
                labelActivated,
            };
        }, [props.disabled, props.checkbox]);

        const breakpoints = props.breakpoints ?? theme.breakpoints;
        const breakpoint = BreakpointHelper.getBreakpoint(width, breakpoints)
        const wrap = BreakpointHelper.compare(breakpoint, "<=", props.wrap ?? "lg");

        return (
            <FieldsetContext.Provider value={fieldsetContext}>
                <Container
                    ref={ref}
                    Change={{
                        AbsoluteSize: (instance) => {
                            setWidth(instance.AbsoluteSize.X);
                        },
                    }}>
                    <HStack
                        Wraps={wrap}
                        valign="Center"
                        HorizontalFlex={Enum.UIFlexAlignment.Fill}
                    >
                        {props.children}
                    </HStack>
                </Container>
            </FieldsetContext.Provider>
        );
    }) as FieldsetComponent;

Fieldset.Label = FieldsetLabel;
Fieldset.Control = FieldsetControl;

export { Fieldset };