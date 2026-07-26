import React from "@rbxts/react";
export interface DraggableContextValue {
    isDragging: boolean;
    beginDrag: (input: InputObject, handle: GuiObject) => void;
    updateDrag: (input: InputObject) => void;
    endDrag: (input: InputObject) => void;
}
export declare const DraggableContext: React.Context<DraggableContextValue | undefined>;
