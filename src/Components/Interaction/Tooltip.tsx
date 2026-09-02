import React from "@rbxts/react";
import { CleanThemeContext, OverlayConsumer } from "../../Contexts";
import { Text } from "../Typography";
import ReactRoblox from "@rbxts/react-roblox";
import { BoxShadow, Corners, Padding } from "../Decorator";
import { ColorHelper, CssHelper, SpacingHelper } from "../../Helpers";
import { IntentElementProps, PaddingProps } from "../../Interfaces";
import { BoxProps } from "../Surface";
import { useTween } from "@rbxts/react-ripple";

type TooltipPlacement = "Top" | "Bottom" | "Left" | "Right" | "Center"

interface TooltipTarget {
    position: Vector2;
    size: Vector2;
}

interface TooltipPopup extends BoxProps, IntentElementProps {
    content: React.ReactNode | string;
    overlay: Frame;
    target: TooltipTarget;
    fadeDuration: number;
    placement?: TooltipPlacement;
    visible: boolean;
}
function TooltipPopup(props: TooltipPopup) {
    const theme = React.useContext(CleanThemeContext);

    const [groupTransparency, transparencyTween] = useTween(1, {
        duration: props.fadeDuration,
        easing: "quadOut",
    });

    React.useEffect(() => {
        transparencyTween.setGoal(props.visible ? 0 : 1);
    }, [props.visible, transparencyTween]);

    let resolvedPadding = {
        top: 0,
        bottom: 0,
        left: 0,
        right: 0
    }

    const shadow = theme.components.tooltip.boxShadow ? CssHelper.parseCssShadow(theme.components.tooltip.boxShadow) : undefined;
    if (shadow !== undefined) {
        resolvedPadding.top += shadow.blurRadius.Offset + shadow.spread.Y.Offset - shadow.offset.Y.Offset;
        resolvedPadding.bottom += shadow.blurRadius.Offset + shadow.spread.Y.Offset + shadow.offset.Y.Offset;
        resolvedPadding.left += shadow.blurRadius.Offset + shadow.spread.X.Offset - shadow.offset.X.Offset;
        resolvedPadding.right += shadow.blurRadius.Offset + shadow.spread.X.Offset + shadow.offset.X.Offset;
    }


    const pointerSize = props.placement === "Center" ? 0 : theme.components.tooltip.pointerSize;

    let anchor = Vector2.zero;
    let position = props.target.position.sub(props.overlay.AbsolutePosition); // Top Left Corner
    let pointerRotation = 45;
    let pointerAnchor = new Vector2(0.5, 1);
    let pointerPosition = new UDim2(0.5, 0, 1, 0);

    const factor = 1.41421356;
    const pointerHeight = (factor * pointerSize) / 2;
    const pointerDiff = pointerHeight - (pointerSize / 2);

    switch (props.placement ?? "Top") {
        case "Top":
            anchor = new Vector2(0.5, 1);
            position = position.add(new Vector2(props.target.size.X / 2, 0));
            pointerPosition = new UDim2(0.5, (resolvedPadding.left - resolvedPadding.right) / 2, 1, -math.max(math.ceil(pointerDiff), resolvedPadding.bottom - pointerDiff));
            resolvedPadding.bottom = math.max(math.floor(pointerHeight), resolvedPadding.bottom);
            break;
        case "Bottom":
            anchor = new Vector2(0.5, 0);
            position = position.add(new Vector2(props.target.size.X / 2, props.target.size.Y))
            pointerAnchor = new Vector2(0.5, 0);
            pointerRotation = -135;
            pointerPosition = new UDim2(0.5, (resolvedPadding.left - resolvedPadding.right) / 2, 0, math.max(math.ceil(pointerDiff), resolvedPadding.top - pointerDiff));
            resolvedPadding.top = math.max(math.floor(pointerHeight), resolvedPadding.top);
            break;
        case "Left":
            anchor = new Vector2(1, 0.5);
            position = position.add(new Vector2(0, props.target.size.Y / 2));
            pointerRotation = -45;
            pointerAnchor = new Vector2(1, 0.5);
            pointerPosition = new UDim2(1, -math.max(math.ceil(pointerDiff), resolvedPadding.right - pointerDiff), 0.5, 0);
            resolvedPadding.right = math.max(math.floor(pointerHeight), resolvedPadding.right);
            break;
        case "Right":
            anchor = new Vector2(0, 0.5)
            position = position.add(new Vector2(props.target.size.X, props.target.size.Y / 2));
            pointerRotation = 135;
            pointerAnchor = new Vector2(0, 0.5);
            pointerPosition = new UDim2(0, math.max(math.ceil(pointerDiff), resolvedPadding.left - pointerDiff), 0.5, 0);
            resolvedPadding.left = math.max(math.floor(pointerHeight), resolvedPadding.left);
            break;
        case "Center":
            anchor = new Vector2(0.5, 0.5)
            position = position.add(new Vector2(props.target.size.X / 2, props.target.size.Y / 2));
            break;
    }





    const intent = ColorHelper.getIntentColors(theme, props.intent, "default", theme.components.tooltip.intents);

    const padding = SpacingHelper.ResolveNumberPadding(SpacingHelper.GetPadding(theme, props.spacing, theme.components.tooltip.spacing));

    return (
        <canvasgroup
            key={props.name ?? "Tooltip"}
            Position={UDim2.fromOffset(position.X, position.Y)}
            AnchorPoint={anchor}
            Size={UDim2.fromOffset(0, 0)}
            AutomaticSize={Enum.AutomaticSize.XY}
            GroupTransparency={groupTransparency}
            BackgroundTransparency={1}
        >
            <frame key="ShadowPadding" Size={UDim2.fromOffset(0, 0)} AutomaticSize={Enum.AutomaticSize.XY} BackgroundTransparency={1}>
                <Padding resolvedPadding={resolvedPadding} />
                <frame
                    key="Content"
                    Size={UDim2.fromOffset(0, 0)}
                    AutomaticSize={Enum.AutomaticSize.XY}
                    BackgroundColor3={intent.backgroundColor}
                    BackgroundTransparency={intent.backgroundTransparency}
                >
                    <BoxShadow {...props} value={theme.components.tooltip.boxShadow} />
                    <Corners radius={theme.components.button.cornerRadius} />
                    <Padding {...props as PaddingProps} resolvedPadding={padding} />
                    <uistroke
                        key="Stroke"
                        Thickness={props['border-thickness'] ?? theme.components.box.borderThickness}
                        BorderStrokePosition={Enum.BorderStrokePosition.Inner}
                        Color={props['border-color'] ?? intent.borderColor}
                    />

                    {typeIs(props.content, "string")
                        ? <Text name="TooltipText" text={props.content} TextColor3={intent.textColor} />
                        : props.content}
                </frame>
            </frame>
            {pointerSize > 0 && <frame key="Pointer" Size={UDim2.fromOffset(pointerSize, pointerSize)}
                AnchorPoint={pointerAnchor}
                Position={pointerPosition}
                BorderSizePixel={1}
                BackgroundColor3={intent.backgroundColor}
                BorderColor3={props['border-color'] ?? intent.borderColor}
                BackgroundTransparency={intent.backgroundTransparency}
                Rotation={45}
            >
                <uigradient
                    key="Gradient"
                    Transparency={
                        new NumberSequence([
                            new NumberSequenceKeypoint(0, 1),
                            new NumberSequenceKeypoint(0.4999, 1),
                            new NumberSequenceKeypoint(0.5, 0),
                            new NumberSequenceKeypoint(1, 0),
                        ])
                    }
                    Rotation={pointerRotation}

                >

                </uigradient>

            </frame>}
        </canvasgroup>
    );
}

interface TooltipProps extends BoxProps, IntentElementProps {
    content: React.ReactNode | string;
    children: React.ReactElement<React.InstanceProps<GuiObject>>;
    placement?: TooltipPlacement;
}


export function Tooltip(props: TooltipProps) {
    const targetRef = React.useRef<GuiObject>();

    const hideRequest = React.useRef(0);

    const [target, setTarget] = React.useState<TooltipTarget>();
    const [visible, setVisible] = React.useState(false);

    const theme = React.useContext(CleanThemeContext);
    const fadeDuration = theme.components.tooltip.fadeDuration;

    const show = () => {
        hideRequest.current += 1;

        if (targetRef.current?.AbsolutePosition)
            setTarget({
                position: targetRef.current?.AbsolutePosition,
                size: targetRef.current?.AbsoluteSize,
            })
        setVisible(true);
    };

    const hide = () => {
        setVisible(false);

        const request = hideRequest.current + 1;
        hideRequest.current = request;

        if (fadeDuration <= 0) {
            setTarget(undefined);
            return;
        }

        task.delay(fadeDuration, () => {
            // Do not remove it if the tooltip was shown again.
            if (hideRequest.current === request) {
                setTarget(undefined);
            }
        });
    };



    const child = React.cloneElement(props.children, {
        ref: targetRef,

        Event: {
            ...props.children.props.Event,

            MouseEnter: (guiObject: GuiObject, x: number, y: number) => {
                props.children.props.Event?.MouseEnter?.(guiObject, x, y);
                show();
            },

            MouseLeave: (guiObject: GuiObject, x: number, y: number) => {
                props.children.props.Event?.MouseLeave?.(guiObject, x, y);

                hide();

            },
        },
    });

    return (
        <>
            {child}

            {target !== undefined && (
                <OverlayConsumer
                    render={(overlay) => {
                        if (overlay === undefined) {
                            return undefined;
                        }
                        return ReactRoblox.createPortal(
                            <TooltipPopup
                                fadeDuration={fadeDuration}
                                {...props}
                                overlay={overlay}
                                target={target}
                                visible={visible}
                            />,
                            overlay,
                        );
                    }}
                />
            )}
        </>
    );
}