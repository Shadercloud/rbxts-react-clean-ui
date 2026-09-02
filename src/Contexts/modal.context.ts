import React from "@rbxts/react";

export interface ModalStackLayer {
    id: string;
    closeOnEscape: () => boolean;
    requestClose: () => void;
}

export interface ModalStackContextValue {
    register: (layer: ModalStackLayer) => void;
    unregister: (id: string) => void;
    getLayerIndex: (id: string) => number;
}

export const ModalStackContext = React.createContext<ModalStackContextValue | undefined>(
    undefined,
);

export function useModalStack(): ModalStackContextValue {
    const context = React.useContext(ModalStackContext);

    assert(context !== undefined, "ModalProvider is missing.");

    return context;
}

// Per-instance, provided by each <Modal> around its own children so a
// header close button or footer button can close the nearest modal
// without the consumer threading their own handler down manually.
export const ModalCloseContext = React.createContext<(() => void) | undefined>(
    undefined,
);

export function useModalClose(): () => void {
    const context = React.useContext(ModalCloseContext);

    assert(context !== undefined, "useModalClose must be used inside a Modal.");

    return context;
}
