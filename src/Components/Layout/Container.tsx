import React from "@rbxts/react";
import {
    PositionElementProps,
    SizeElementProps,
    ZIndexElementProps,
} from "../../Interfaces/";
import { SizeHelper, CssHelper } from "../../Helpers/";
import { CssBackgroundImage } from "../../Theme";
import { Group, GroupContext } from "./Group";

export interface ContainerProps
    extends SizeElementProps,
    PositionElementProps,
    ZIndexElementProps,
    React.InstanceProps<ImageLabel> {
    group?: boolean;
    backgroundImage?: Partial<CssBackgroundImage>;
    name?: string;
}

export const Container = React.forwardRef<ImageLabel, ContainerProps>(
    (props, ref) => {
        const group = React.useContext(GroupContext);

        const autoSize = SizeHelper.GetAutoSize(props);
        const isAutoSizeActive = autoSize !== Enum.AutomaticSize.None && autoSize !== "None";

        const centerViaLayout =
            props.center === true &&
            props.Position === undefined &&
            props.AnchorPoint === undefined &&
            isAutoSizeActive;

        const backgroundImage = CssHelper.resolveBackgroundImage(props.backgroundImage);

        const content = (
            <imagelabel
                key={props.name ?? "Container"}
                ref={ref}
                Archivable={props.Archivable}
                Tag={props.Tag}
                Active={props.Active}
                AnchorPoint={centerViaLayout ? Vector2.zero : SizeHelper.GetAnchor(props)}
                AutomaticSize={autoSize}
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
                Position={centerViaLayout ? UDim2.fromOffset(0, 0) : SizeHelper.GetPosition(props)}
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

                Image={backgroundImage.Image}
                ImageColor3={backgroundImage.ImageColor3}
                ImageTransparency={backgroundImage.ImageTransparency}
                ScaleType={backgroundImage.ScaleType}
                SliceCenter={backgroundImage.SliceCenter}
                SliceScale={backgroundImage.SliceScale}
                TileSize={backgroundImage.TileSize}

                Change={props.Change}
                Event={props.Event}
            >

                <Group.Element enabled={props.group}>
                    {props.children}
                </Group.Element>
            </imagelabel>
        );

        if (!centerViaLayout) {
            return content;
        }

        return (
            <frame
                key={props.name !== undefined ? `${props.name}CenterWrapper` : "ContainerCenterWrapper"}
                Size={UDim2.fromScale(1, 1)}
                BackgroundTransparency={1}
                ZIndex={props.ZIndex}
                LayoutOrder={props.LayoutOrder}
            >
                <uilistlayout
                    key="CenterLayout"
                    FillDirection={Enum.FillDirection.Horizontal}
                    HorizontalAlignment={Enum.HorizontalAlignment.Center}
                    VerticalAlignment={Enum.VerticalAlignment.Center}
                />
                {content}
            </frame>
        );
    },
);