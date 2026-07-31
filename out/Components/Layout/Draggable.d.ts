import React from "@rbxts/react";
import { DroppableRegistration } from "../../Providers";
type GuiObjectProps = React.InstanceProps<GuiObject>;
type GuiElement = React.ReactElement<GuiObjectProps>;
interface DragHandleProps {
    children: GuiElement;
}
declare function DragHandle({ children }: DragHandleProps): React.ReactElement<GuiObjectProps, string | React.JSXElementConstructor<any>>;
interface DraggableProps {
    onDropped?: (droppable?: DroppableRegistration) => void;
    onDragged?: (droppable?: DroppableRegistration) => void;
    onStartDrag?: () => void;
    placeholder?: boolean;
    retainPosition?: boolean;
    children: GuiElement;
    id?: string;
}
type DraggableComponent = React.ForwardRefExoticComponent<DraggableProps & React.RefAttributes<Frame>> & {
    Handle: typeof DragHandle;
};
declare const Draggable: DraggableComponent;
export { Draggable };
