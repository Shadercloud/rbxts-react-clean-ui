import React from "@rbxts/react";

export interface OverlayContextValue {
    overlay?: Frame;
}

export const OverlayContext = React.createContext<OverlayContextValue>({});

export interface OverlayProviderProps {
    children?: React.ReactNode;
}
