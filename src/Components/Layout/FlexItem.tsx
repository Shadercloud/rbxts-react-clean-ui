import React, { Binding } from "@rbxts/react";

interface FlexItemProps {
    children?: React.ReactNode;
    align?: Enum.HorizontalAlignment | "Right" | "Left" | "Center" | React.Binding<Enum.HorizontalAlignment>
    mode?: Enum.UIFlexMode | "Grow" | "None" | "Shrink" | "Fill" | "Custom" | Binding<Enum.UIFlexMode>
}

export function FlexItem(props: FlexItemProps) {

    return (
        <frame BackgroundTransparency={1} AutomaticSize={Enum.AutomaticSize.XY}>
            <uiflexitem FlexMode={props.mode ?? "Grow"} />
            <uilistlayout FillDirection={Enum.FillDirection.Horizontal} HorizontalAlignment={props.align} />
            {props.children}
        </frame>
    );
}