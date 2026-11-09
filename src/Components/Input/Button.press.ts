import React from "@rbxts/react";

export type PressOn = "down" | "up";

export type PressReleaseCallback = (button: ImageButton, input: InputObject) => void;

export function isPointerPress(input?: InputObject): boolean {
    if (input === undefined) {
        return false;
    }

    return input.UserInputType === Enum.UserInputType.MouseButton1
        || input.UserInputType === Enum.UserInputType.Touch;
}

export function usePressRelease(onRelease?: PressReleaseCallback) {
    const onReleaseRef = React.useRef(onRelease);
    onReleaseRef.current = onRelease;

    const connectionsRef = React.useRef<Map<InputObject, RBXScriptConnection>>();

    React.useEffect(() => {
        return () => {
            connectionsRef.current?.forEach((connection) => connection.Disconnect());
            connectionsRef.current?.clear();
        };
    }, []);

    return React.useCallback((button: ImageButton, input: InputObject) => {
        if (connectionsRef.current === undefined) {
            connectionsRef.current = new Map();
        }

        const connections = connectionsRef.current;

        if (connections.has(input)) {
            return;
        }

        const connection = input.GetPropertyChangedSignal("UserInputState").Connect(() => {
            if (input.UserInputState !== Enum.UserInputState.End && input.UserInputState !== Enum.UserInputState.Cancel) {
                return;
            }

            connection.Disconnect();
            connections.delete(input);
            onReleaseRef.current?.(button, input);
        });

        connections.set(input, connection);
    }, []);
}
