import React from "@rbxts/react";
import { PositionElementProps, SizeElementProps, ZIndexElementProps } from "../../Interfaces/";
import { SizeHelper } from "../../Helpers/";
import { useGroupElement } from "../../Contexts";
import { GroupMeasurement } from "./GroupMeasurement";

interface ContainerProps extends SizeElementProps, PositionElementProps, ZIndexElementProps {
    BackgroundTransparency?: number;
    BackgroundColor3?: Color3;
    group?: boolean;
    children?: React.ReactNode;
}

export function Container(props: ContainerProps) {
    const group = useGroupElement(props.group);
    return <frame
        Size={SizeHelper.GetSize(props, UDim2.fromOffset(group?.groupSize?.X ?? 0, 0))}
        AutomaticSize={SizeHelper.GetAutoSize(props)}
        Position={SizeHelper.GetPosition(props)}
        AnchorPoint={SizeHelper.GetAnchor(props)}
        BackgroundTransparency={props.BackgroundTransparency ?? 1}
        BackgroundColor3={props.BackgroundColor3}
        ZIndex={props.ZIndex}
    >
        <GroupMeasurement enabled={props.group} group={group}>
            {props.children}
        </GroupMeasurement>
    </frame>

}