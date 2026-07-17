import React from "@rbxts/react";
import { HttpService } from "@rbxts/services";

export interface GroupContextValue {
    size?: Vector2;
    reportSize: (id: string, size: Vector2) => void;
    removeElement: (id: string) => void;
}

export const GroupContext = React.createContext<GroupContextValue | undefined>(undefined);

export interface GroupElement { groupSize: Vector2 | undefined; reportSize: (size: Vector2) => void; }

export function useGroupElement(enabled?: boolean): GroupElement | undefined {
    if (!enabled)
        return undefined

    const context = React.useContext(GroupContext);
    const id = React.useRef(HttpService.GenerateGUID(false)).current;

    const removeElementRef = React.useRef(context?.removeElement);
    removeElementRef.current = context?.removeElement;

    React.useEffect(() => {
        return () => {
            removeElementRef.current?.(id);
        };
    }, []);

    const reportSize = React.useCallback(
        (size: Vector2) => {
            context?.reportSize(id, size);
        },
        [context?.size, id],
    );

    return {
        groupSize: context?.size,
        reportSize,
    };
}