import React from "@rbxts/react";
import { CssShadow, ShadowElementProps } from "../../Interfaces/";
import { CssHelper } from "../../Helpers/";
import { CleanThemeContext } from "../../Contexts/";

interface BoxShadowProps extends ShadowElementProps {
    value?: CssShadow;
    color?: Color3;
    transparency?: number;
    zindex?: number;
}

export function BoxShadow(props: BoxShadowProps) {
    const theme = React.useContext(CleanThemeContext);

    const shadowTheme = theme.components.boxShadow;
    const shadowValue = props["box-shadow"] ?? props.value;

    if (shadowValue === undefined) {
        return undefined;
    }

    const shadow = CssHelper.parseCssShadow(shadowValue);

    if (shadow === undefined) {
        return undefined;
    }

    return (
        <uishadow
            Offset={shadow.offset}
            BlurRadius={shadow.blurRadius}
            Spread={shadow.spread}
            Color={props.color ?? shadowTheme.color}
            Transparency={props.transparency ?? shadowTheme.transparency}
            ZIndex={props.zindex ?? -1}
        />
    );
}