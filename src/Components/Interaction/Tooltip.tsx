import React from "@rbxts/react";
import { CleanThemeContext, OverlayConsumer } from "../../Contexts";
import { Text } from "../Typography";
import ReactRoblox from "@rbxts/react-roblox";
import { BoxShadow, Corners, Padding } from "../Decorator";
import { ColorHelper, CssHelper, SpacingHelper } from "../../Helpers";
import { IntentElementProps } from "../../Interfaces";
import { BoxProps } from "../Surface";

type TooltipPlacement = "Top" | "Bottom" | "Left" | "Right"

interface TooltipTarget {
    position: Vector2;
    size: Vector2;
}

interface TooltipPopup extends BoxProps, IntentElementProps {
    content: React.ReactNode | string;
    overlay: Frame;
    target: TooltipTarget
    placement?: TooltipPlacement;
}
function TooltipPopup(props: TooltipPopup) {
    const theme = React.useContext(CleanThemeContext);

    let anchor = Vector2.zero;
    let position = props.target.position.sub(props.overlay.AbsolutePosition); // Top Left Corner
    switch (props.placement ?? "Top") {
        case "Top":
            anchor = new Vector2(0.5, 1);
            position = position.add(new Vector2(props.target.size.X / 2, 0))
            break;
        case "Bottom":
            anchor = new Vector2(0.5, 0);
            position = position.add(new Vector2(props.target.size.X / 2, props.target.size.Y))
            break;
        case "Left":
            anchor = new Vector2(1, 0.5)
            position = position.add(new Vector2(0, props.target.size.Y / 2))
            break;
        case "Right":
            anchor = new Vector2(0, 0.5)
            position = position.add(new Vector2(props.target.size.X, props.target.size.Y / 2))
            break;
    }

    const intent = ColorHelper.getIntentColors(theme, props.intent, "default", theme.components.tooltip.intents);

    const shadow = theme.components.tooltip.boxShadow ? CssHelper.parseCssShadow(theme.components.tooltip.boxShadow) : undefined;
    const padding = SpacingHelper.ResolveNumberPadding(SpacingHelper.GetPadding(theme, props.spacing, theme.components.tooltip.spacing));

    return (
        <canvasgroup
            Position={UDim2.fromOffset(position.X, position.Y)}
            AnchorPoint={anchor}
            Size={UDim2.fromOffset(0, 0)}
            AutomaticSize={Enum.AutomaticSize.XY}
            BackgroundTransparency={1}
        >
            {shadow !== undefined &&
                <Padding resolvedPadding={{
                    top: shadow.blurRadius.Offset + shadow.spread.Y.Offset - shadow.offset.Y.Offset,
                    bottom: shadow.blurRadius.Offset + shadow.spread.Y.Offset + shadow.offset.Y.Offset,
                    left: shadow.blurRadius.Offset + shadow.spread.X.Offset - shadow.offset.X.Offset,
                    right: shadow.blurRadius.Offset + shadow.spread.X.Offset + shadow.offset.X.Offset
                }} />
            }
            <frame
                Size={UDim2.fromOffset(0, 0)}
                AutomaticSize={Enum.AutomaticSize.XY}
                BackgroundColor3={intent.backgroundColor}
                BackgroundTransparency={intent.backgroundTransparency}
            >
                <BoxShadow {...props} value={theme.components.box.boxShadow} />
                <Corners radius={theme.components.button.cornerRadius} />
                <Padding {...props} resolvedPadding={padding} />
                <uistroke
                    Thickness={props['border-thickness'] ?? theme.components.box.borderThickness}
                    BorderStrokePosition={Enum.BorderStrokePosition.Inner}
                    Color={props['border-color'] ?? intent.borderColor}
                />

                {typeIs(props.content, "string")
                    ? <Text text={props.content} TextColor3={intent.textColor} />
                    : props.content}
            </frame>
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

    const [target, setTarget] = React.useState<TooltipTarget>();

    const show = () => {
        if (targetRef.current?.AbsolutePosition)
            setTarget({
                position: targetRef.current?.AbsolutePosition,
                size: targetRef.current?.AbsoluteSize,
            })
    };

    const hide = () => {
        setTarget(undefined);
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
                                {...props}
                                overlay={overlay}
                                target={target}
                            />,
                            overlay,
                        );
                    }}
                />
            )}
        </>
    );
}