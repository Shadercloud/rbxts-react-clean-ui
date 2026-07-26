import React from "@rbxts/react";

export interface DraggableContextValue {
    isDragging: boolean,
    beginDrag: (
        input: InputObject,
        handle: GuiObject,
    ) => void;
    updateDrag: (input: InputObject) => void;
    endDrag: (input: InputObject) => void;
}

export const DraggableContext = React.createContext<DraggableContextValue | undefined>(
    undefined,
);
