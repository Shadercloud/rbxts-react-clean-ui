import React from "@rbxts/react";
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
    name?: string;
}
declare function GroupElement(props: GroupElementProps): boolean | React.JSX.Element | ReadonlyMap<React.Key, React.ReactNode> | {
    readonly [key: string]: React.ReactNode;
    readonly [key: number]: React.ReactNode;
} | readonly React.ReactNode[] | undefined;
interface GroupProps {
    children?: React.ReactNode;
    BackgroundTransparency?: number;
}
type GroupComponent = React.ForwardRefExoticComponent<GroupProps & React.RefAttributes<Frame>> & {
    Element: typeof GroupElement;
};
declare const Group: GroupComponent;
export { Group };
