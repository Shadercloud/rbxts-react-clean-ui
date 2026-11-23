import React from "@rbxts/react";

export const IgnorePreferredTextSizeContext = React.createContext<boolean>(false);

export function useIgnorePreferredTextSize(): boolean {
    return React.useContext(IgnorePreferredTextSizeContext);
}
