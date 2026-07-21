import React from "@rbxts/react";
export interface OverlayContextValue {
    overlay?: Frame;
}
export declare const OverlayContext: React.Context<OverlayContextValue>;
export interface OverlayProviderProps {
    children?: React.ReactNode;
}
