import React from "@rbxts/react";
import { PaddingProps } from "../../Interfaces/";
import { CleanThemeContext } from "../../Contexts/";
import { SpacingHelper } from "../../Helpers";


export function Padding(props: PaddingProps) {
    const theme = React.useContext(CleanThemeContext);

    const padding = props.resolvedPadding !== undefined ? props.resolvedPadding : SpacingHelper.GetResolvedPadding(theme, props);

    return (
        <uipadding
            PaddingTop={new UDim(0, padding.top)}
            PaddingBottom={new UDim(0, padding.bottom)}
            PaddingLeft={new UDim(0, padding.left)}
            PaddingRight={new UDim(0, padding.right)}
        />
    );
}