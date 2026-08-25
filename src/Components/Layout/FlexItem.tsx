import React, { Binding } from "@rbxts/react";
import { Container, ContainerProps } from "./Container";

interface FlexItemProps extends ContainerProps {
    children?: React.ReactNode;
    align?: Enum.HorizontalAlignment | "Right" | "Left" | "Center" | React.Binding<Enum.HorizontalAlignment>
    mode?: Enum.UIFlexMode | "Grow" | "None" | "Shrink" | "Fill" | "Custom" | Binding<Enum.UIFlexMode>
    GrowRatio?: number;
    ShrinkRatio?: number;
    HorizontalFlex?: Enum.UIFlexAlignment | "None" | "SpaceAround" | "Fill" | Binding<Enum.UIFlexAlignment>

}
export const FlexItem = React.forwardRef<Frame, FlexItemProps>(
    (props, ref) => {

        return (
            <Container {...props} ref={ref}>
                <uiflexitem
                    FlexMode={props.mode ?? "Grow"}
                    GrowRatio={props.GrowRatio}
                    ShrinkRatio={props.ShrinkRatio}
                />
                <uilistlayout
                    HorizontalFlex={props.HorizontalFlex}
                    FillDirection={Enum.FillDirection.Horizontal}
                    HorizontalAlignment={props.align} />
                {props.children}
            </Container>
        );
    })