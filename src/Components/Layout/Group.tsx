import React from "@rbxts/react";
import { ResolvedPadding } from "../../Interfaces";
// import { HttpService } from "@rbxts/services";
import { RegistryContext } from "../../Providers";

interface GroupContextValue {
    size: Vector2;
    sizes: Map<string, Vector2>;
    reportSize: (id: string, size: Vector2) => void
    removeElement: (id: string) => void;
}

export const GroupContext = React.createContext<GroupContextValue | undefined>(
    undefined,
);

interface GroupElementProps {
    enabled?: boolean;
    padding?: ResolvedPadding;
    children?: React.ReactNode;
}

function GroupElement(props: GroupElementProps) {
    const registry = React.useContext(RegistryContext);
    const context = React.useContext(GroupContext);
    const id = React.useRef(registry?.GetNextId() ?? "").current;

    const enabled = props.enabled === true && context !== undefined;

    React.useEffect(() => {
        if (!enabled) {
            context?.removeElement(id);
            return;
        }

        return () => {
            context.removeElement(id);
        };
    }, [enabled, context?.removeElement]);

    if (!enabled) {
        return props.children;
    }

    const horizontalPadding =
        (props.padding?.left ?? 0) +
        (props.padding?.right ?? 0);

    const verticalPadding =
        (props.padding?.top ?? 0) +
        (props.padding?.bottom ?? 0);

    return (
        <frame
            BackgroundTransparency={1}
            AutomaticSize={Enum.AutomaticSize.XY}
            Change={{
                AbsoluteSize: (instance) => {
                    context.reportSize(
                        id,
                        new Vector2(
                            instance.AbsoluteSize.X + horizontalPadding,
                            instance.AbsoluteSize.Y + verticalPadding,
                        ),
                    );
                },
            }}
        >
            {props.children}
        </frame>
    );
}

interface GroupProps {
    children?: React.ReactNode;
    BackgroundTransparency?: number;
}

function getMaxVector2(
    map: ReadonlyMap<string, Vector2>,
): Vector2 | undefined {
    let max: Vector2 | undefined;

    for (const [, vector] of map) {
        if (max === undefined) {
            max = vector;
        } else {
            max = new Vector2(
                math.max(max.X, vector.X),
                math.max(max.Y, vector.Y),
            );
        }
    }

    return max;
}


type GroupComponent = React.ForwardRefExoticComponent<
    GroupProps & React.RefAttributes<Frame>
> & {
    Element: typeof GroupElement;
};


const Group = React.forwardRef<Frame, GroupProps>(
    (props, _ref) => {

        const [sizes, setSizes] = React.useState<Map<string, Vector2>>(new Map<string, Vector2>())
        const size = React.useMemo(
            () => getMaxVector2(sizes) ?? Vector2.zero,
            [sizes],
        );

        const reportSize = React.useCallback(
            (id: string, reportedSize: Vector2) => {
                setSizes((currentSizes) => {
                    const current = currentSizes.get(id);

                    if (
                        current !== undefined &&
                        current.X === reportedSize.X &&
                        current.Y === reportedSize.Y
                    ) {
                        return currentSizes;
                    }

                    const newSizes = new Map<string, Vector2>();

                    for (const [elementId, elementSize] of currentSizes) {
                        newSizes.set(elementId, elementSize);
                    }

                    newSizes.set(id, reportedSize);

                    return newSizes;
                });
            },
            [],
        );

        const removeElement = React.useCallback((id: string) => {
            setSizes((currentSizes) => {
                if (!currentSizes.has(id)) {
                    return currentSizes;
                }

                const newSizes = new Map<string, Vector2>();

                for (const [elementId, elementSize] of currentSizes) {
                    if (elementId !== id) {
                        newSizes.set(elementId, elementSize);
                    }
                }

                return newSizes;
            });
        }, []);

        const context = React.useMemo<GroupContextValue>(
            () => ({
                size,
                sizes,
                reportSize,
                removeElement,
            }),
            [size, sizes, reportSize, removeElement],
        );
        return (
            <GroupContext.Provider value={context} >
                {props.children}
            </GroupContext.Provider >
        );
    }) as GroupComponent;

Group.Element = GroupElement;

export { Group };