import React, { Binding } from "@rbxts/react";
import { Container, ContainerProps } from "./Container";

interface FlexItemProps extends ContainerProps {
    children?: React.ReactNode;
    align?: Enum.HorizontalAlignment | "Right" | "Left" | "Center" | React.Binding<Enum.HorizontalAlignment>
    mode?: Enum.UIFlexMode | "Grow" | "None" | "Shrink" | "Fill" | "Custom" | Binding<Enum.UIFlexMode>
    GrowRatio?: number;
    ShrinkRatio?: number;
    ItemLineAlignment?: Enum.ItemLineAlignment;
    HorizontalFlex?: Enum.UIFlexAlignment | "None" | "SpaceAround" | "Fill" | Binding<Enum.UIFlexAlignment>
    direction?: "horizontal" | "vertical";
    layout?: boolean;

}
export const FlexItem = React.forwardRef<ImageLabel, FlexItemProps>(
    (props, ref) => {

        return (
            <Container {...props} ref={ref} name={props.name ?? "FlexItem"}>
                <uiflexitem
                    key="FlexItemConstraint"
                    FlexMode={props.mode ?? "Grow"}
                    GrowRatio={props.GrowRatio}
                    ShrinkRatio={props.ShrinkRatio}
                    ItemLineAlignment={props.ItemLineAlignment}
                />
                {props.layout !== false && (
                    <uilistlayout
                        key="FlexItemLayout"
                        HorizontalFlex={props.HorizontalFlex}
                        FillDirection={props.direction === "vertical" ? Enum.FillDirection.Vertical : Enum.FillDirection.Horizontal}
                        HorizontalAlignment={props.align} />
                )}
                {props.children}
            </Container>
        );
    })
