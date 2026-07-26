import React from "@rbxts/react";
import {
    PositionElementProps,
    SizeElementProps,
    ZIndexElementProps,
} from "../../Interfaces/";
import { SizeHelper } from "../../Helpers/";
import { Group, GroupContext } from "./Group";

export interface ContainerProps
    extends SizeElementProps,
    PositionElementProps,
    ZIndexElementProps,
    React.InstanceProps<Frame> {
    group?: boolean;
}

export const Container = React.forwardRef<Frame, ContainerProps>(
    (props, ref) => {
        const group = React.useContext(GroupContext);

        return (
            <frame
                ref={ref}
                Archivable={props.Archivable}
                Tag={props.Tag}
                Active={props.Active}
                AnchorPoint={SizeHelper.GetAnchor(props)}
                AutomaticSize={SizeHelper.GetAutoSize(props)}
                BackgroundColor3={props.BackgroundColor3}
                BackgroundTransparency={
                    props.BackgroundTransparency ?? 1
                }
                BorderColor3={props.BorderColor3}
                BorderMode={props.BorderMode}
                BorderSizePixel={props.BorderSizePixel}
                ClipsDescendants={props.ClipsDescendants}
                Interactable={props.Interactable}
                LayoutOrder={props.LayoutOrder}
                NextSelectionDown={props.NextSelectionDown}
                NextSelectionLeft={props.NextSelectionLeft}
                NextSelectionRight={props.NextSelectionRight}
                NextSelectionUp={props.NextSelectionUp}
                Position={SizeHelper.GetPosition(props)}
                Rotation={props.Rotation}
                Selectable={props.Selectable}
                SelectionGroup={props.SelectionGroup}
                SelectionImageObject={props.SelectionImageObject}
                SelectionOrder={props.SelectionOrder}
                Size={SizeHelper.GetSize(
                    props,
                    UDim2.fromOffset(
                        props.group ? group?.size?.X ?? 0 : 0,
                        0,
                    ),
                )}
                SizeConstraint={props.SizeConstraint}
                Visible={props.Visible}
                ZIndex={props.ZIndex}

                AutoLocalize={props.AutoLocalize}
                RootLocalizationTable={props.RootLocalizationTable}

                Style={props.Style}

                Change={props.Change}
                Event={props.Event}
            >
                <Group.Element enabled={props.group}>
                    {props.children}
                </Group.Element>
            </frame>
        );
    },
);