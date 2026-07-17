import React = require("@rbxts/react")
import { ResolvedPadding } from "../../Interfaces";
import { GroupElement } from "../../Contexts";

interface GroupMeasureProps {
    enabled?: boolean;
    children?: React.ReactNode;
    padding?: ResolvedPadding;
    group?: GroupElement;
}

export function GroupMeasurement(props: GroupMeasureProps) {
    if (!props.enabled)
        return props.children
    return <frame
        BackgroundTransparency={1}
        AutomaticSize={Enum.AutomaticSize.XY}
        Change={{
            AbsoluteSize: (instance) => {
                props.group?.reportSize(new Vector2(
                    instance.AbsoluteSize.X + (props.padding?.left ?? 0) + (props.padding?.right ?? 0),
                    instance.AbsoluteSize.Y + (props.padding?.top ?? 0) + (props.padding?.bottom ?? 0),
                ),)
            },
        }}>{props.children}</frame>
}