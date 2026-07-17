import React from "@rbxts/react";
export interface GroupContextValue {
    size?: Vector2;
    reportSize: (id: string, size: Vector2) => void;
    removeElement: (id: string) => void;
}
export declare const GroupContext: React.Context<GroupContextValue | undefined>;
export interface GroupElement {
    groupSize: Vector2 | undefined;
    reportSize: (size: Vector2) => void;
}
export declare function useGroupElement(enabled?: boolean): GroupElement | undefined;
