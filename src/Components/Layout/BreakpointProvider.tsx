import React from "@rbxts/react";
import { BreakPointElementProps } from "../../Interfaces/";
import { BreakpointContext, BreakpointContextValue, CleanThemeContext } from "../../Contexts";
import { BreakpointHelper } from "../../Helpers/";

export interface BreakpointProviderProps extends BreakPointElementProps {
    name?: string;
    LayoutOrder?: number;
    children?: React.ReactNode;
}

export const BreakpointProvider = React.forwardRef<Frame, BreakpointProviderProps>(
    (props, ref) => {
        const theme = React.useContext(CleanThemeContext);

        const breakpoints = props.breakpoints ?? theme.breakpoints;

        const frameRef = React.useRef<Frame>();
        const widthRef = React.useRef<number>(0);

        const [value, setValue] = React.useState<BreakpointContextValue>(() => ({
            width: 0,
            breakpoint: BreakpointHelper.getBreakpoint(0, breakpoints),
        }));

        const valueRef = React.useRef<BreakpointContextValue>(value);

        const resolve = (width: number) => {
            widthRef.current = width;

            const breakpoint = BreakpointHelper.getBreakpoint(width, breakpoints);

            if (breakpoint === valueRef.current.breakpoint) {
                return;
            }

            const resolved = { width: width, breakpoint: breakpoint };

            valueRef.current = resolved;
            setValue(resolved);
        };

        React.useEffect(() => {
            const instance = frameRef.current;

            resolve(instance !== undefined ? instance.AbsoluteSize.X : widthRef.current);
        }, [breakpoints]);

        const setFrame = React.useCallback(
            (instance: Frame | undefined) => {
                frameRef.current = instance;

                if (typeIs(ref, "function")) {
                    ref(instance);
                } else if (ref !== undefined) {
                    (ref as React.MutableRefObject<Frame | undefined>).current = instance;
                }
            },
            [ref],
        );

        return (
            <frame
                key={props.name ?? "BreakpointProvider"}
                ref={setFrame}
                LayoutOrder={props.LayoutOrder}
                Size={UDim2.fromScale(1, 1)}
                BackgroundTransparency={1}
                BorderSizePixel={0}
                Change={{
                    AbsoluteSize: (instance) => resolve(instance.AbsoluteSize.X),
                }}
            >
                <BreakpointContext.Provider value={value}>
                    {props.children}
                </BreakpointContext.Provider>
            </frame>
        );
    },
);
