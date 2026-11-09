import React from "@rbxts/react";
import { useGamepadSelection } from "../../Helpers/gamepad.helper";

export interface GamepadSelectionGuardProps {
    enabled?: boolean;
    children?: React.ReactNode;
}

export function GamepadSelectionGuard(props: GamepadSelectionGuardProps) {
    useGamepadSelection(undefined, {
        enabled: props.enabled ?? true,
        clearOnSelectionChange: true,
    });

    return <>{props.children}</>;
}
