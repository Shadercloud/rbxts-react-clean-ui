import React from "@rbxts/react";
type GuiObjectProps = React.InstanceProps<GuiObject>;
type GuiElement = React.ReactElement<GuiObjectProps>;
interface DroppableProps {
    id?: string;
    children: GuiElement;
    onDrop?: (draggedObject: GuiObject) => void;
}
export declare function Droppable(props: DroppableProps): React.JSX.Element;
export {};
