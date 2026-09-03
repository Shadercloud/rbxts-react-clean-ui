import React from "@rbxts/react";
import { CssBackgroundGradient } from "../../Interfaces/";
import { CssHelper } from "../../Helpers/";

interface GradientProps {
    // Partial<CssBackgroundGradient> so callers can pass an IntentScheme's
    // backgroundGradient (also Partial, since every IntentScheme field is
    // optional/overridable) straight through without narrowing first — same
    // reasoning as CssHelper.resolveBackgroundImage accepting
    // Partial<CssBackgroundImage>. A gradient with no `colors` set is simply
    // not a usable gradient, so it's cast back to the full type before being
    // handed to CssHelper, which (per its own contract) assumes `colors` is
    // present when `value` isn't undefined.
    value?: Partial<CssBackgroundGradient>;
    name?: string;
}

export function Gradient(props: GradientProps) {
    const resolved = CssHelper.resolveBackgroundGradient(props.value as CssBackgroundGradient | undefined);

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
