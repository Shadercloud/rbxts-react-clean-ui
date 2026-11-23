import React from "@rbxts/react";
export interface OverlayContextValue {
    overlay?: Frame;
    scale?: number;
}
export declare const OverlayContext: React.Context<OverlayContextValue>;
export interface OverlayProviderProps {
    children?: React.ReactNode;
}
interface OverlayConsumerProps {
    render: (overlay: Frame | undefined) => React.ReactNode;
}
export declare function OverlayConsumer(props: OverlayConsumerProps): React.ReactNode;
export {};
