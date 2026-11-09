import React from "@rbxts/react";
import { CssHelper, SizeHelper } from "../../Helpers";
import { CleanThemeContext } from "../../Contexts";
import { ButtonFlag, CssBoxShadow, CssRadius, CssShadow } from "../../Interfaces";
import { FieldStateStyle, FieldStateStyles, InnerShadowStyle } from "../../Theme";
import { BoxShadow } from "../Decorator";

export function resolveFieldState(disabled: boolean | undefined, focused: boolean, hovered: boolean): ButtonFlag {
    if (disabled) return "disabled";
    if (focused) return "focus";
    if (hovered) return "hover";

    return "default";
}

export function resolveFieldStateStyle(states: FieldStateStyles | undefined, state: ButtonFlag): FieldStateStyle {
    if (states === undefined || state === "default") return {};

    return states[state] ?? {};
}

interface FieldBoxShadowProps {
    value?: CssShadow | CssBoxShadow;
    name?: string;
}

export function FieldBoxShadow(props: FieldBoxShadowProps) {
    const value = props.value;

    if (value === undefined) {
        return undefined;
    }

    if (typeIs(value, "table")) {
        const complete = value as CssBoxShadow;

        if (CssHelper.parseCssShadow(complete.shadow) === undefined) {
            return undefined;
        }

        return <BoxShadow name={props.name} completeShadow={complete} />;
    }

    return <BoxShadow name={props.name} value={value as CssShadow} />;
}

interface FieldInnerShadowProps {
    value: InnerShadowStyle;
    cornerRadius?: CssRadius;
    inset: number;
}

export function FieldInnerShadow(props: FieldInnerShadowProps) {
    const theme = React.useContext(CleanThemeContext);
    const ref = React.useRef<Frame>();
    const [height, setHeight] = React.useState(0);

    React.useEffect(() => {
        const frame = ref.current;

        if (frame !== undefined) {
            setHeight(frame.AbsoluteSize.Y);
        }
    }, []);

    const inset = math.max(0, props.inset);
    const radius = props.cornerRadius !== undefined ? SizeHelper.toRadius(theme, props.cornerRadius) : new UDim();
    const innerRadius = new UDim(radius.Scale, math.max(0, radius.Offset - inset));
    const fade = height > 0 ? props.value.size / height : 0;

    const transparency = fade >= 1
        ? new NumberSequence(props.value.transparency, 1)
        : new NumberSequence([
            new NumberSequenceKeypoint(0, props.value.transparency),
            new NumberSequenceKeypoint(math.max(fade, 0.001), 1),
            new NumberSequenceKeypoint(1, 1),
        ]);

    return (
        <frame
            key="InnerShadow"
            ref={ref}
            Position={UDim2.fromOffset(inset, inset)}
            Size={new UDim2(1, -2 * inset, 1, -2 * inset)}
            BackgroundColor3={props.value.color}
            BackgroundTransparency={0}
            BorderSizePixel={0}
            Visible={fade > 0}
            Change={{
                AbsoluteSize: (rbx) => setHeight(rbx.AbsoluteSize.Y),
            }}
        >
            {(innerRadius.Scale !== 0 || innerRadius.Offset !== 0) && <uicorner key="Corners" CornerRadius={innerRadius} />}
            <uigradient key="Fade" Rotation={90} Transparency={transparency} />
        </frame>
    );
}
