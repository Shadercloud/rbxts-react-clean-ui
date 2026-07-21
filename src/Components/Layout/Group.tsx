import React, { Component, ReactComponent } from "@rbxts/react";
import { ResolvedPadding } from "../../Interfaces";
import { HttpService } from "@rbxts/services";

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
    const context = React.useContext(GroupContext);

    const id = React.useRef(HttpService.GenerateGUID(false)).current;

    const removeElementRef = React.useRef(context?.removeElement);
    removeElementRef.current = context?.removeElement;

    React.useEffect(() => {
        return () => {
            removeElementRef.current?.(id);
        };
    }, []);

    if (!props.enabled || context === undefined) {
        return props.children;
    }

    return <frame
        BackgroundTransparency={1}
        AutomaticSize={Enum.AutomaticSize.XY}
        Change={{
            AbsoluteSize: (instance) => {
                context.reportSize(id, new Vector2(
                    instance.AbsoluteSize.X + (props.padding?.left ?? 0) + (props.padding?.right ?? 0),
                    instance.AbsoluteSize.Y + (props.padding?.top ?? 0) + (props.padding?.bottom ?? 0),
                ),)
            },
        }}>{props.children}</frame>

}

interface Group2Props {
    children?: React.ReactNode;
    BackgroundTransparency?: number;
}

interface GroupState {
    size: Vector2;
    sizes: Map<string, Vector2>;
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

@ReactComponent
export class Group extends Component<Group2Props, GroupState> {
    static Element = GroupElement;
    static contextType = GroupContext;

    state: GroupState = {
        size: new Vector2(0, 0),
        sizes: new Map<string, Vector2>()
    }

    declare context: React.ContextType<typeof GroupContext>;

    render(): React.ReactNode {
        const context: GroupContextValue = {
            size: this.state.size,
            sizes: this.state.sizes,
            reportSize: (id, size) => {
                const current = this.state.sizes.get(id);

                if (
                    current !== undefined &&
                    current.X === size.X &&
                    current.Y === size.Y
                ) {
                    return;
                }

                this.setState((state) => {
                    const sizes = new Map<string, Vector2>();

                    for (const [elementId, elementSize] of state.sizes) {
                        sizes.set(elementId, elementSize);
                    }

                    sizes.set(id, size);

                    return {
                        sizes,
                        size: getMaxVector2(sizes) ?? new Vector2(0, 0),
                    };
                });
            },
            removeElement: (id) => {
                if (!this.state.sizes.has(id)) {
                    return;
                }

                this.setState((state) => {
                    const sizes = new Map<string, Vector2>();

                    for (const [elementId, elementSize] of state.sizes) {
                        if (elementId !== id) {
                            sizes.set(elementId, elementSize);
                        }
                    }

                    return {
                        sizes,
                        size: getMaxVector2(sizes) ?? new Vector2(0, 0),
                    };
                });
            },
        }
        return (
            <GroupContext.Provider value={context} >
                {this.props.children}
            </GroupContext.Provider >
        );
    }
}

