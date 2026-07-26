import React from "@rbxts/react";
import { DroppableRegistration } from "../Providers";

export interface DroppableContextValue {
    registration?: DroppableRegistration;
}


export const DroppableContext = React.createContext<DroppableContextValue | undefined>(
    undefined,
);