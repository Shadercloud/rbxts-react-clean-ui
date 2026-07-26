import React from "@rbxts/react";

export interface OverlayContextValue {
    overlay?: Frame;
}

export const OverlayContext = React.createContext<OverlayContextValue>({});

export interface OverlayProviderProps {
    children?: React.ReactNode;
}


interface OverlayConsumerProps {
    render: (overlay: Frame | undefined) => React.ReactNode;
}

export function OverlayConsumer(props: OverlayConsumerProps) {
    const overlayContext = React.useContext(OverlayContext);

    return props.render(overlayContext?.overlay);
}