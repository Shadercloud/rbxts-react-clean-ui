import React from "@rbxts/react";
import { DroppableRegistration } from "../Providers";
export interface DroppableContextValue {
    registration?: DroppableRegistration;
}
export declare const DroppableContext: React.Context<DroppableContextValue | undefined>;
