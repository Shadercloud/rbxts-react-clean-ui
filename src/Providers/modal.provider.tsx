import React from "@rbxts/react";
import { ModalStackContext, ModalStackContextValue, ModalStackLayer } from "../Contexts/modal.context";
import { CustomInputService } from "../Helpers/input.helper";

interface ModalProviderProps {
    children?: React.ReactNode;
}

export function ModalProvider(props: ModalProviderProps) {
    const [stack, setStack] = React.useState<ModalStackLayer[]>([]);
    const stackRef = React.useRef(stack);

    React.useEffect(() => {
        stackRef.current = stack;
    }, [stack]);

    const register = React.useCallback((layer: ModalStackLayer) => {
        setStack((current) => [...current, layer]);
    }, []);

    const unregister = React.useCallback((id: string) => {
        setStack((current) => current.filter((layer) => layer.id !== id));
    }, []);

    const getLayerIndex = React.useCallback((id: string) => {
        return stack.findIndex((layer) => layer.id === id);
    }, [stack]);

    React.useEffect(() => {
        const connection = CustomInputService.InputBegan.Connect((input, gameProcessed) => {
            if (gameProcessed) return;
            if (input.KeyCode !== Enum.KeyCode.Escape && input.KeyCode !== Enum.KeyCode.ButtonB) return;

            const top = stackRef.current[stackRef.current.size() - 1];

            if (top !== undefined && top.closeOnEscape()) {
                top.requestClose();
            }
        });

        return () => {
            connection.Disconnect();
        };
    }, []);

    const value = React.useMemo<ModalStackContextValue>(
        () => ({
            register,
            unregister,
            getLayerIndex,
        }),
        [register, unregister, getLayerIndex],
    );

    return (
        <ModalStackContext.Provider value={value}>
            {props.children}
        </ModalStackContext.Provider>
    );
}
