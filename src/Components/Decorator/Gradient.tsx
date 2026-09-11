import React from "@rbxts/react";
import { CssBackgroundGradient } from "../../Interfaces/";
import { CssHelper } from "../../Helpers/";

interface GradientProps {
    value?: Partial<CssBackgroundGradient>;
    name?: string;
}

export function Gradient(props: GradientProps) {
    const resolved = CssHelper.resolveBackgroundGradient(props.value);

    if (resolved === undefined) {
        return undefined;
    }

    return (
        <uigradient
            key={props.name ?? "Gradient"}
            {...resolved}
        />
    );
}
