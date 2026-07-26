import React from "@rbxts/react";
import { DroppableRegistration, DroppableRegistryKey, RegistryContext, useRegistryRegistration } from "../../Providers/";
import { DroppableContext } from "../../Contexts";

type GuiObjectProps = React.InstanceProps<GuiObject>;
type GuiElement = React.ReactElement<GuiObjectProps>;


interface DroppableProps {
    id?: string;
    children: GuiElement;
    onDrop?: (draggedObject: GuiObject) => void;
}

export function Droppable(props: DroppableProps) {
    const {
        ref,
        registration,
    } = useRegistryRegistration(
        DroppableRegistryKey,
        (guiObject): DroppableRegistration => ({
            guiObject,
            id: props.id,

            drop: (draggedObject) => {
                props.onDrop?.(draggedObject);
            },
        }),
        [props.id, props.onDrop],
    );
    const child = React.cloneElement(props.children, {
        ref: ref,
    });

    return (
        <DroppableContext.Provider
            value={{
                registration: registration,
            }}
        >
            {child}
        </DroppableContext.Provider>
    );
}
