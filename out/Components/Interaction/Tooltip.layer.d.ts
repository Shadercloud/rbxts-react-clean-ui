import React from "@rbxts/react";
export interface TooltipLayer {
    depth: number;
    retain?: () => () => void;
}
export declare const TooltipLayerContext: React.Context<TooltipLayer>;
export declare function setTooltipHovered(owner: object, depth: number | undefined): void;
export declare function isTooltipCovered(depth: number, owner: object): boolean;
export declare function subscribeTooltipHover(listener: () => void): () => void;
