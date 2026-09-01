import React from "@rbxts/react";
import { Column } from "./Column";
import { BreakPointElementProps, BreakpointValue, SpacedElementProps } from "../../Interfaces/";
import { CleanThemeContext, RowContext } from "../../Contexts";
import { BreakpointHelper, SpacingHelper } from "../../Helpers/";

interface RowProps extends SpacedElementProps, BreakPointElementProps {
}


export const Row = React.forwardRef<Frame, RowProps>(
    (props, ref) => {

        const theme = React.useContext(CleanThemeContext);

        const [width, setWidth] = React.useState<number>(0);

        const breakpoints = props.breakpoints ?? theme.breakpoints;
        const padding = new UDim(0, SpacingHelper.GetPadding(theme, props.spacing))

        const rowRef = React.useRef<Frame>();

        const setRowRef = (instance: Frame | undefined) => {
            rowRef.current = instance;
            if (typeIs(ref, "function")) {
                ref(instance);
            } else if (ref !== undefined && typeIs(ref, "table")) {
                ref.current = instance;
            }
        };

        React.useEffect(() => {
            const frame = rowRef.current;
            if (!frame) return;

            // Some renderers (e.g. the browser-based Loom scene preview) don't
            // back this ref with an instance that supports property-changed
            // signals, so guard the subscription instead of throwing and
            // losing breakpoint width tracking.
            let conn: RBXScriptConnection | undefined;
            pcall(() => {
                conn = frame.GetPropertyChangedSignal("AbsoluteSize").Connect(() => {
                    const nextWidth = frame.AbsoluteSize.X;
                    setWidth((currentWidth) =>
                        currentWidth === nextWidth ? currentWidth : nextWidth
                    );
                });
            });

            return () => {
                conn?.Disconnect();
            };
        }, []);

        return (
            <frame
                ref={setRowRef}
                Size={UDim2.fromScale(1, 1)}
                AutomaticSize={Enum.AutomaticSize.Y}
                BackgroundTransparency={1}
            >
                <uilistlayout
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