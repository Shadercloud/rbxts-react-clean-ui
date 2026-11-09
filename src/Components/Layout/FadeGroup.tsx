import React from "@rbxts/react";
import {
    PositionElementProps,
    SizeElementProps,
    ZIndexElementProps,
} from "../../Interfaces/";
import { SizeHelper } from "../../Helpers/";

export interface FadeGroupProps
    extends SizeElementProps,
    PositionElementProps,
    ZIndexElementProps,
    React.InstanceProps<CanvasGroup> {
    name?: string;
}

export const FadeGroup = React.forwardRef<CanvasGroup, FadeGroupProps>(
    (props, ref) => {
        const sizeConstraint = SizeHelper.GetSizeConstraint(props);

        return (
            <canvasgroup
                key={props.name ?? "FadeGroup"}
                ref={ref}
                Archivable={props.Archivable}
                Tag={props.Tag}
                Active={props.Active}
                AnchorPoint={SizeHelper.GetAnchor(props)}
                AutomaticSize={SizeHelper.GetAutoSize(props)}
                BackgroundColor3={props.BackgroundColor3}
                BackgroundTransparency={props.BackgroundTransparency ?? 1}
                BorderColor3={props.BorderColor3}
                BorderMode={props.BorderMode}
                BorderSizePixel={props.BorderSizePixel === undefined ? 0 : props.BorderSizePixel}
                ClipsDescendants={props.ClipsDescendants}
                GroupColor3={props.GroupColor3}
                GroupTransparency={props.GroupTransparency ?? 0}
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
                Size={SizeHelper.GetSize(props, UDim2.fromOffset(0, 0))}
                SizeConstraint={props.SizeConstraint}
                Visible={props.Visible}
                ZIndex={props.ZIndex}
                AutoLocalize={props.AutoLocalize}
                RootLocalizationTable={props.RootLocalizationTable}
                Change={props.Change}
                Event={props.Event}
            >
                {sizeConstraint !== undefined && (
                    <uisizeconstraint
                        key="SizeConstraint"
                        MinSize={sizeConstraint.MinSize}
                        MaxSize={sizeConstraint.MaxSize}
                    />
                )}
                {props.children}
            </canvasgroup>
        );
    },
);
