import React from "@rbxts/react";
import { GroupContext, GroupContextValue, useGroupElement } from "../../Contexts";
import { GroupMeasurement } from "./GroupMeasurement";

interface GroupProps {
    children?: React.ReactNode;
    BackgroundTransparency?: number;
    group?: boolean;
}

export function Group(props: GroupProps) {
    const sizes = React.useRef(new Map<string, Vector2>());
    const [size, setSize] = React.useState<Vector2>();

    const parentGroup = useGroupElement(props.group);

    const recalculateSize = () => {
        let largestSize = new Vector2(0, 0);

        sizes.current.forEach((elementSize) => {
            largestSize = new Vector2(math.max(largestSize.X, elementSize.X), math.max(largestSize.Y, elementSize.Y));
        });

        setSize(largestSize.X > 0 || largestSize.Y > 0 ? largestSize : undefined);
    };

    const reportSize = (id: string, absoluteSize: Vector2) => {
        print(id, absoluteSize)
        if (sizes.current.get(id)?.X === absoluteSize.X && sizes.current.get(id)?.Y === absoluteSize.Y) {
            return;
        }

        sizes.current.set(id, absoluteSize);
        recalculateSize();
    };

    const removeElement = (id: string) => {
        sizes.current.delete(id);
        recalculateSize();
    };

    const context = React.useMemo<GroupContextValue>(
        () => ({
            size,
            reportSize,
            removeElement,
        }),
        [size],
    );

    return (
        <frame
            AutomaticSize={Enum.AutomaticSize.XY}
            Size={UDim2.fromOffset(parentGroup?.groupSize?.X ?? 0, 0)}
            BackgroundTransparency={1}
            Change={{
                AbsoluteSize: (instance) => {
                    parentGroup?.reportSize(instance.AbsoluteSize);

                },
            }}
        >
            <GroupContext.Provider value={context}>
                <GroupMeasurement enabled={props.group} group={parentGroup}>
                    {props.children}
                </GroupMeasurement>
            </GroupContext.Provider>
        </frame>
    );
}