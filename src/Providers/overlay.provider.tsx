import React, { useState } from "@rbxts/react";
import { OverlayProviderProps, OverlayContext } from "../Contexts";

export function OverlayProvider(props: OverlayProviderProps) {
    const [overlay, setOverlay] = useState<Frame>();

    return (
        <OverlayContext.Provider
            value={{
                overlay,
            }}
        >
            {props.children}

            <frame
                ref={(instance) => {
                    setOverlay(instance);
                }}
                Size={UDim2.fromScale(1, 1)}
                BackgroundTransparency={1}
                ZIndex={100000}
                Active={false}
            />
        </OverlayContext.Provider>
    );
}