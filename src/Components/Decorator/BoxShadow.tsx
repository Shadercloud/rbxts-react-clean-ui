import React from "@rbxts/react";
import { CssBoxShadow, CssShadow, ShadowElementProps } from "../../Interfaces/";
import { CssHelper } from "../../Helpers/";
import { CleanThemeContext } from "../../Contexts/";

interface BoxShadowProps extends ShadowElementProps {
    value?: CssShadow;
    completeShadow?: CssBoxShadow;
    color?: Color3;
    transparency?: number;
    zindex?: number;
    name?: string;
}

export function BoxShadow(props: BoxShadowProps) {
    let shadowProps: React.InstanceProps<UIShadow>;

    if (props.completeShadow) {
        shadowProps = CssHelper.ResolveShadow(props.completeShadow);
    } else {
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

        shadowProps = {
            Offset: shadow?.offset,
            BlurRadius: shadow?.blurRadius,
            Spread: shadow?.spread,
            Color: props.color ?? shadowTheme.color,
            Transparency: props.transparency ?? shadowTheme.transparency
        }
    }

    return (
        <uishadow
            key={props.name ?? "BoxShadow"}
            {...shadowProps}
            ZIndex={props.zindex ?? -1}
        />
    );
}