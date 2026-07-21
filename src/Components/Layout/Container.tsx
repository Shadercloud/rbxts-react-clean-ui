import React from "@rbxts/react";
import { PositionElementProps, SizeElementProps, ZIndexElementProps } from "../../Interfaces/";
import { SizeHelper } from "../../Helpers/";
import { Group, GroupContext } from "./Group";

interface ContainerProps extends SizeElementProps, PositionElementProps, ZIndexElementProps {
    BackgroundTransparency?: number;
    BackgroundColor3?: Color3;
    group?: boolean;
    children?: React.ReactNode;
    Change?: React.InstanceChangeEvent<Frame> | undefined
}

export function Container(props: ContainerProps) {
    const group = React.useContext(GroupContext)

    return <frame
        Size={SizeHelper.GetSize(props, UDim2.fromOffset(props.group ? group?.size?.X ?? 0 : 0, 0))}
        AutomaticSize={SizeHelper.GetAutoSize(props)}
        Position={SizeHelper.GetPosition(props)}
        AnchorPoint={SizeHelper.GetAnchor(props)}
        BackgroundTransparency={props.BackgroundTransparency ?? 1}
        BackgroundColor3={props.BackgroundColor3}
        ZIndex={props.ZIndex}
        Change={props.Change}
    >
        <Group.Element enabled={props.group}>
            {props.children}
        </Group.Element>
    </frame>

}