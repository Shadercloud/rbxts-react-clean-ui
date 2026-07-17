import React from "@rbxts/react";

export interface NavigationContextValue {
    collapsed: boolean
}

export const NavigationContext = React.createContext<NavigationContextValue>({
    collapsed: false
});