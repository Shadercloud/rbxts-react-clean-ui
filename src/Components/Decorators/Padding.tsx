import React from "@rbxts/react";
import { SpacedElementProps } from "../../Interfaces/";
import { CleanThemeContext } from "../../Contexts/";

export function Padding(props: SpacedElementProps) {
    const theme = React.useContext(CleanThemeContext);

    const amount = theme.spacing[
        props.spacing ?? theme.default.spacing
    ];

    const padding = new UDim(0, amount);

    return (
        <uipadding
            PaddingTop={padding}
            PaddingBottom={padding}
            PaddingLeft={padding}
            PaddingRight={padding}
        />
    );
}