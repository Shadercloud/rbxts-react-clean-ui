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
export declare const ModalStackContext: React.Context<ModalStackContextValue | undefined>;
export declare function useModalStack(): ModalStackContextValue;
export declare const ModalCloseContext: React.Context<(() => void) | undefined>;
export declare function useModalClose(): () => void;
