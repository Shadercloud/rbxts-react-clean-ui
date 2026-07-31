import React from "@rbxts/react";
import { DraggableContextValue } from "../Contexts";

// This registry is used to keep a global map of GuiObjects => React components
// For example Droppable zones use this to register themselves

export interface RegistryKey<T extends defined> {
    readonly name: string;
}


export interface DroppableRegistration {
    guiObject: GuiObject;
    id?: string;
    drop: (draggedObject: GuiObject) => void;
}

export const DroppableRegistryKey: RegistryKey<DroppableRegistration> = {
    name: "Droppable",
};

export interface DraggableRegistration {
    guiObject: GuiObject;
    id?: string;
    draggable: DraggableContextValue;
}

export const DraggableRegistryKey: RegistryKey<DraggableRegistration> = {
    name: "Draggable",
};

export interface RegistryContextValue {
    register: <T extends defined>(
        guiObject: GuiObject,
        key: RegistryKey<T>,
        value: T,
    ) => void;

    unregister: <T extends defined>(
        guiObject: GuiObject,
        key: RegistryKey<T>,
    ) => void;

    get: <T extends defined>(
        guiObject: GuiObject,
        key: RegistryKey<T>,
    ) => T | undefined;

    getAll: <T extends defined>(
        key: RegistryKey<T>,
    ) => T[];
    GetNextId: () => string;
}

export const RegistryContext = React.createContext<
    RegistryContextValue | undefined
>(undefined);

export interface RegistryProviderProps {
    children?: React.ReactNode;
}

export function RegistryProvider(props: RegistryProviderProps) {
    const entries = React.useRef(
        new Map<string, Map<GuiObject, unknown>>(),
    );

    const register = <T extends defined>(
        guiObject: GuiObject,
        key: RegistryKey<T>,
        value: T,
    ): void => {
        let keyEntries = entries.current.get(key.name);

        if (keyEntries === undefined) {
            keyEntries = new Map<GuiObject, unknown>();
            entries.current.set(key.name, keyEntries);
        }

        keyEntries.set(guiObject, value);
    };

    const unregister = <T extends defined>(
        guiObject: GuiObject,
        key: RegistryKey<T>,
    ): void => {
        const keyEntries = entries.current.get(key.name);

        if (keyEntries === undefined) {
            return;
        }

        keyEntries.delete(guiObject);

        if (keyEntries.size() === 0) {
            entries.current.delete(key.name);
        }
    };

    const get = <T extends defined>(
        guiObject: GuiObject,
        key: RegistryKey<T>,
    ): T | undefined => {
        return entries.current
            .get(key.name)
            ?.get(guiObject) as T | undefined;
    };

    const getAll = <T extends defined>(
        key: RegistryKey<T>,
    ): T[] => {
        const keyEntries = entries.current.get(key.name);

        if (keyEntries === undefined) {
            return [];
        }

        const result = new Array<T>();

        for (const [, value] of keyEntries) {
            result.push(value as T);
        }

        return result;
    };

    const GetNextId = (): string => {
        return "1";
    }

    const contextValue: RegistryContextValue = {
        register,
        unregister,
        get,
        getAll,
        GetNextId
    };

    return (
        <RegistryContext.Provider value={contextValue}>
            {props.children}
        </RegistryContext.Provider>
    );
}

export function useRegistryRegistration<T extends defined>(
    key: RegistryKey<T>,
    createRegistration: (guiObject: GuiObject) => T,
    dependencies: React.DependencyList,
) {
    const registry = React.useContext(RegistryContext);
    const [guiObject, setGuiObject] = React.useState<GuiObject>();

    const registration = React.useMemo<T | undefined>(() => {
        if (guiObject === undefined) {
            return undefined;
        }

        return createRegistration(guiObject);
    }, [guiObject, ...dependencies]);

    React.useEffect(() => {
        if (
            registry === undefined ||
            guiObject === undefined ||
            registration === undefined
        ) {
            return;
        }

        registry.register(
            guiObject,
            key,
            registration,
        );

        return () => {
            registry.unregister(
                guiObject,
                key,
            );
        };
    }, [registry, guiObject, key, registration]);

    return {
        ref: setGuiObject,
        guiObject,
        registration,
    };
}