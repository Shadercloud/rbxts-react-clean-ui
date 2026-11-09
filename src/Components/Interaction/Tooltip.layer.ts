import React from "@rbxts/react";

export interface TooltipLayer {
    depth: number;
    retain?: () => () => void;
}

export const TooltipLayerContext = React.createContext<TooltipLayer>({ depth: 0 });

const hoveredDepths = new Map<object, number>();
const listeners = new Set<() => void>();

export function setTooltipHovered(owner: object, depth: number | undefined) {
    if (hoveredDepths.get(owner) === depth) {
        return;
    }

    if (depth === undefined) {
        hoveredDepths.delete(owner);
    } else {
        hoveredDepths.set(owner, depth);
    }

    const snapshot = [...listeners];

    for (const listener of snapshot) {
        listener();
    }
}

export function isTooltipCovered(depth: number, owner: object): boolean {
    for (const [other, hoveredDepth] of hoveredDepths) {
        if (other !== owner && hoveredDepth >= depth) {
            return true;
        }
    }

    return false;
}

export function subscribeTooltipHover(listener: () => void): () => void {
    listeners.add(listener);

    return () => {
        listeners.delete(listener);
    };
}
