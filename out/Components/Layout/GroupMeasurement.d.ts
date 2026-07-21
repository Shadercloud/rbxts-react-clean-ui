import React = require("@rbxts/react");
import { ResolvedPadding } from "../../Interfaces";
import { GroupElement } from "../../Contexts";
interface GroupMeasureProps {
    enabled?: boolean;
    children?: React.ReactNode;
    padding?: ResolvedPadding;
    group?: GroupElement;
}
export declare function GroupMeasurement(props: GroupMeasureProps): boolean | React.JSX.Element | ReadonlyMap<React.Key, React.ReactNode> | {
    readonly [key: string]: React.ReactNode;
    readonly [key: number]: React.ReactNode;
} | readonly React.ReactNode[] | undefined;
export {};
