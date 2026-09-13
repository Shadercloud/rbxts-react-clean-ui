import React from "@rbxts/react";
import { Workspace } from "@rbxts/services";
import { Breakpoint, BreakpointValue, ResponsiveValue } from "../Interfaces/responsive.types";
import { BreakpointHelper } from "../Helpers/breakpoint.helper";
import { SizeHelper } from "../Helpers/size.helper";
import { CleanThemeContext } from "./theme.context";

export interface BreakpointContextValue {
    width: number;
    breakpoint: Breakpoint;
}

export const BreakpointContext = React.createContext<BreakpointContextValue | undefined>(
    undefined,
);

function getViewportBreakpoint(breakpoints: BreakpointValue<number>): Breakpoint | undefined {
    const camera = Workspace.CurrentCamera;

    if (camera === undefined) {
        return undefined;
    }

    return BreakpointHelper.getBreakpoint(camera.ViewportSize.X, breakpoints);
}

export function useBreakpoint(): Breakpoint {
    const context = React.useContext(BreakpointContext);
    const theme = React.useContext(CleanThemeContext);

    const [viewportBreakpoint, setViewportBreakpoint] = React.useState<Breakpoint>(
        () => (context === undefined ? getViewportBreakpoint(theme.breakpoints) : undefined) ?? "xs",
    );

    React.useEffect(() => {
        if (context !== undefined) {
            return;
        }

        let viewportConnection: RBXScriptConnection | undefined;

        const update = () => {
            const resolved = getViewportBreakpoint(theme.breakpoints);

            if (resolved !== undefined) {
                setViewportBreakpoint(resolved);
            }
        };

        const bindCamera = () => {
            viewportConnection?.Disconnect();
            viewportConnection = undefined;

            const camera = Workspace.CurrentCamera;

            if (camera !== undefined) {
                viewportConnection = camera.GetPropertyChangedSignal("ViewportSize").Connect(update);
            }

            update();
        };

        const cameraConnection = Workspace.GetPropertyChangedSignal("CurrentCamera").Connect(bindCamera);

        bindCamera();

        return () => {
            cameraConnection.Disconnect();
            viewportConnection?.Disconnect();
        };
    }, [context === undefined, theme.breakpoints]);

    return context !== undefined ? context.breakpoint : viewportBreakpoint;
}

export function useBreakpointValue<T>(value: ResponsiveValue<T> | undefined): T | undefined {
    const breakpoint = useBreakpoint();

    return SizeHelper.resolveResponsiveValue(value, breakpoint);
}
