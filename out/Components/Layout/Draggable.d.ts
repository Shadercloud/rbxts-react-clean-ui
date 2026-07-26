import React, { Component, ReactNode } from "@rbxts/react";
import { DroppableRegistration, RegistryContext } from "../../Providers";
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
interface DraggableState {
    dragging: boolean;
    overlayPosition: Vector2;
    overlaySize: Vector2;
    placeholderPosition: UDim2;
    placeholderAnchorPoint: Vector2;
    placeholderLayoutOrder: number;
    placeholderZIndex: number;
}
export declare class Draggable extends Component<DraggableProps, DraggableState> {
    static Handle: typeof DragHandle;
    readonly state: DraggableState;
    static contextType: React.Context<import("../../Providers").RegistryContextValue | undefined>;
    context: React.ContextType<typeof RegistryContext>;
    rootRef: React.RefObject<GuiObject>;
    private readonly placeholderRef;
    private dragInformation;
    private usePlaceholder;
    private registration;
    componentDidMount(): void;
    componentWillUnmount(): void;
    private beginDrag;
    private updateDrag;
    private endDrag;
    private findDroppable;
    private readonly contextValue;
    render(): ReactNode;
}
export {};
