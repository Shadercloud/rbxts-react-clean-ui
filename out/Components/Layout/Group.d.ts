import React, { Component } from "@rbxts/react";
import { ResolvedPadding } from "../../Interfaces";
interface GroupContextValue {
    size: Vector2;
    sizes: Map<string, Vector2>;
    reportSize: (id: string, size: Vector2) => void;
    removeElement: (id: string) => void;
}
export declare const GroupContext: React.Context<GroupContextValue | undefined>;
interface GroupElementProps {
    enabled?: boolean;
    padding?: ResolvedPadding;
    children?: React.ReactNode;
}
declare function GroupElement(props: GroupElementProps): boolean | ReadonlyMap<React.Key, React.ReactNode> | {
    readonly [key: string]: React.ReactNode;
    readonly [key: number]: React.ReactNode;
} | readonly React.ReactNode[] | React.JSX.Element | undefined;
interface Group2Props {
    children?: React.ReactNode;
    BackgroundTransparency?: number;
}
interface GroupState {
    size: Vector2;
    sizes: Map<string, Vector2>;
}
export declare class Group extends Component<Group2Props, GroupState> {
    static Element: typeof GroupElement;
    static contextType: React.Context<GroupContextValue | undefined>;
    state: GroupState;
    context: React.ContextType<typeof GroupContext>;
    render(): React.ReactNode;
}
export {};
