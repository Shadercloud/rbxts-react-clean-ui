import React from "@rbxts/react";
import {
    BorderElementProps,
    CssPadding,
    CssRadius,
    PositionElementProps,
    SizeElementProps,
    ZIndexElementProps,
} from "../../Interfaces/";
import { SizeHelper, CssHelper } from "../../Helpers/";
import { CssBackgroundImage } from "../../Theme";
import { CssBackgroundGradient } from "../../Interfaces/";
import { Corners, Gradient, Padding } from "../Decorator";
import { Group, GroupContext } from "./Group";

export interface ContainerProps
    extends SizeElementProps,
    PositionElementProps,
    ZIndexElementProps,
    BorderElementProps,
    React.InstanceProps<ImageLabel> {
    group?: boolean;
    backgroundImage?: Partial<CssBackgroundImage>;
    backgroundGradient?: Partial<CssBackgroundGradient>;
    padding?: CssPadding;
    cornerRadius?: CssRadius;
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
        const borderThickness = props.borderThickness ?? 0;
        const sizeConstraint = SizeHelper.GetSizeConstraint(props);

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
                BorderSizePixel={props.BorderSizePixel === undefined ? 0 : props.BorderSizePixel}
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
                <Gradient value={props.backgroundGradient} />

                {borderThickness > 0 && (
                    <uistroke
                        key="Stroke"
                        Thickness={borderThickness}
                        Color={props.borderColor}
                        Transparency={props.borderTransparency}
                        BorderStrokePosition={props.borderPosition === "outer" ? Enum.BorderStrokePosition.Outer : Enum.BorderStrokePosition.Inner}
                    />
                )}

                {props.padding !== undefined && <Padding resolvedPadding={CssHelper.parseCssQuad(props.padding)} />}

                <Corners radius={props.cornerRadius} />

                {sizeConstraint !== undefined && (
                    <uisizeconstraint
                        key="SizeConstraint"
                        MinSize={sizeConstraint.MinSize}
                        MaxSize={sizeConstraint.MaxSize}
                    />
                )}

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
                BorderSizePixel={0}
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