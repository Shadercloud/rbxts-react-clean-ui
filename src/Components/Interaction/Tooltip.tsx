import React from "@rbxts/react";
import { GuiService } from "@rbxts/services";
import { CleanThemeContext, DragStateContext, OverlayConsumer } from "../../Contexts";
import { Text } from "../Typography";
import ReactRoblox from "@rbxts/react-roblox";
import { BoxShadow, Corners, Padding } from "../Decorator";
import { ColorHelper, CssHelper, ElementHelper, SizeHelper, SpacingHelper } from "../../Helpers";
import { IntentElementProps, PaddingProps } from "../../Interfaces";
import { BoxProps } from "../Surface";
import { useTween } from "@rbxts/react-ripple";
import { TooltipPlacement, computeTooltipLayout, getTooltipSafeArea } from "./Tooltip.placement";

interface TooltipTarget {
    position: Vector2;
    size: Vector2;
}

interface TooltipFrame {
    position: Vector2;
    size: Vector2;
    topbarBottom: number;
}

interface TooltipPopup extends BoxProps, IntentElementProps {
    content: React.ReactNode | string;
    overlay: Frame;
    target: TooltipTarget;
    fadeDuration: number;
    placement?: TooltipPlacement;
    visible: boolean;
}

function getTopbarBottom(overlay: Frame): number {
    const surface = overlay.FindFirstAncestorWhichIsA("ScreenGui");

    if (surface === undefined || surface.ScreenInsets === Enum.ScreenInsets.TopbarSafeInsets) {
        return 0;
    }

    const originY = surface.ScreenInsets === Enum.ScreenInsets.CoreUISafeInsets ? GuiService.GetGuiInset()[0].Y : 0;

    return GuiService.TopbarInset.Max.Y - originY - overlay.AbsolutePosition.Y;
}

function readFrame(overlay: Frame): TooltipFrame {
    return {
        position: overlay.AbsolutePosition,
        size: overlay.AbsoluteSize,
        topbarBottom: getTopbarBottom(overlay),
    };
}

function TooltipPopup(props: TooltipPopup) {
    const theme = React.useContext(CleanThemeContext);

    const contentRef = React.useRef<Frame>();
    const [contentSize, setContentSize] = React.useState<Vector2>();
    const [frame, setFrame] = React.useState(() => readFrame(props.overlay));

    const [groupTransparency, transparencyTween] = useTween(1, {
        duration: props.fadeDuration,
        easing: "quadOut",
    });

    const measured = contentSize !== undefined;

    React.useEffect(() => {
        transparencyTween.setGoal(props.visible && measured ? 0 : 1);
    }, [props.visible, measured, transparencyTween]);

    React.useEffect(() => {
        const overlay = props.overlay;
        const update = () => {
            const latest = readFrame(overlay);
            setFrame((current) =>
                current.position === latest.position && current.size === latest.size && current.topbarBottom === latest.topbarBottom
                    ? current
                    : latest,
            );
        };

        update();

        const connections = [
            overlay.GetPropertyChangedSignal("AbsoluteSize").Connect(update),
            overlay.GetPropertyChangedSignal("AbsolutePosition").Connect(update),
            GuiService.GetPropertyChangedSignal("TopbarInset").Connect(update),
        ];

        return () => {
            for (const connection of connections) {
                connection.Disconnect();
            }
        };
    }, [props.overlay]);

    React.useEffect(() => {
        const content = contentRef.current;

        if (content === undefined) {
            return;
        }

        const update = () => {
            const size = content.AbsoluteSize;

            if (size.X > 0 || size.Y > 0) {
                setContentSize(size);
            }
        };

        update();

        const sizeChanged = content.GetPropertyChangedSignal("AbsoluteSize").Connect(update);

        return () => {
            sizeChanged.Disconnect();
        };
    }, []);

    const shadowPadding = {
        top: 0,
        bottom: 0,
        left: 0,
        right: 0
    }

    const shadow = theme.components.tooltip.boxShadow !== undefined && theme.components.tooltip.boxShadow !== 0 ? CssHelper.parseCssShadow(theme.components.tooltip.boxShadow) : undefined;
    if (shadow !== undefined) {
        shadowPadding.top += shadow.blurRadius.Offset + shadow.spread.Y.Offset - shadow.offset.Y.Offset;
        shadowPadding.bottom += shadow.blurRadius.Offset + shadow.spread.Y.Offset + shadow.offset.Y.Offset;
        shadowPadding.left += shadow.blurRadius.Offset + shadow.spread.X.Offset - shadow.offset.X.Offset;
        shadowPadding.right += shadow.blurRadius.Offset + shadow.spread.X.Offset + shadow.offset.X.Offset;
    }

    const contentWidth = contentSize?.X ?? 0;
    const contentHeight = contentSize?.Y ?? 0;
    const cornerRadius = SizeHelper.toUDim(theme.components.button.cornerRadius);
    const targetPosition = props.target.position.sub(frame.position);

    const layout = computeTooltipLayout({
        target: {
            left: targetPosition.X,
            top: targetPosition.Y,
            right: targetPosition.X + props.target.size.X,
            bottom: targetPosition.Y + props.target.size.Y,
        },
        content: { width: contentWidth, height: contentHeight },
        bounds: getTooltipSafeArea(
            { width: frame.size.X, height: frame.size.Y },
            theme.components.tooltip.edgeMargin,
            frame.topbarBottom,
        ),
        placement: props.placement,
        pointerSize: theme.components.tooltip.pointerSize,
        shadow: shadowPadding,
        cornerRadius: cornerRadius.Offset + cornerRadius.Scale * math.min(contentWidth, contentHeight),
    });

    const resolvedPadding = layout.padding;
    const pointer = layout.pointer;
    const pointerSize = pointer !== undefined ? theme.components.tooltip.pointerSize : 0;

    const intent = ColorHelper.getIntentColors(theme, props.intent, "default", theme.components.tooltip.intents);

    const padding = SpacingHelper.ResolveNumberPadding(SpacingHelper.GetPadding(theme, props.spacing, theme.components.tooltip.spacing));

    return (
        <canvasgroup
            key={props.name ?? "Tooltip"}
            Position={UDim2.fromOffset(layout.position.x, layout.position.y)}
            AnchorPoint={new Vector2(layout.anchor.x, layout.anchor.y)}
            Size={UDim2.fromOffset(0, 0)}
            AutomaticSize={Enum.AutomaticSize.XY}
            GroupTransparency={measured ? groupTransparency : 1}
            BackgroundTransparency={1}
            BorderSizePixel={0}
        >
            <frame key="ShadowPadding" Size={UDim2.fromOffset(0, 0)} AutomaticSize={Enum.AutomaticSize.XY} BackgroundTransparency={1} BorderSizePixel={0}>
                <Padding resolvedPadding={resolvedPadding} />
                <frame
                    key="Content"
                    ref={contentRef}
                    Size={UDim2.fromOffset(0, 0)}
                    AutomaticSize={Enum.AutomaticSize.XY}
                    BackgroundColor3={intent.backgroundColor}
                    BackgroundTransparency={intent.backgroundTransparency}
                    BorderSizePixel={0}
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
            {pointer !== undefined && <frame key="Pointer" Size={UDim2.fromOffset(pointerSize, pointerSize)}
                AnchorPoint={new Vector2(pointer.anchor.x, pointer.anchor.y)}
                Position={new UDim2(pointer.scale.x, pointer.offset.x, pointer.scale.y, pointer.offset.y)}
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
                    Rotation={pointer.rotation}

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
    disabled?: boolean;
    open?: boolean;
}


export function Tooltip(props: TooltipProps) {
    const targetRef = React.useRef<GuiObject>();

    const hideRequest = React.useRef(0);

    const hoveredRef = React.useRef(false);
    const shownRef = React.useRef(false);

    const [target, setTarget] = React.useState<TooltipTarget>();
    const [visible, setVisible] = React.useState(false);

    const theme = React.useContext(CleanThemeContext);
    const dragState = React.useContext(DragStateContext);
    const fadeDuration = theme.components.tooltip.fadeDuration;

    const suppressed = props.disabled === true || dragState.preview || dragState.dragging;
    const suppressedRef = React.useRef(suppressed);
    suppressedRef.current = suppressed;

    const controlled = props.open !== undefined;
    const controlledRef = React.useRef(controlled);
    controlledRef.current = controlled;

    const captureTarget = () => {
        if (targetRef.current?.AbsolutePosition)
            setTarget({
                position: targetRef.current?.AbsolutePosition,
                size: targetRef.current?.AbsoluteSize,
            })
    };

    const show = () => {
        shownRef.current = true;
        hideRequest.current += 1;

        captureTarget();
        setVisible(true);
    };

    const hide = () => {
        shownRef.current = false;
        setVisible(false);

        const request = hideRequest.current + 1;
        hideRequest.current = request;

        if (fadeDuration <= 0) {
            setTarget(undefined);
            return;
        }

        task.delay(fadeDuration, () => {
            if (hideRequest.current === request) {
                setTarget(undefined);
            }
        });
    };

    React.useEffect(() => {
        if (suppressed) {
            hoveredRef.current = false;
        }

        const wanted = !suppressed && (props.open ?? hoveredRef.current);

        if (wanted && !shownRef.current) {
            show();
        } else if (!wanted && shownRef.current) {
            hide();
        }
    }, [suppressed, props.open]);

    React.useEffect(() => {
        const instance = targetRef.current;

        if (!visible || instance === undefined) {
            return;
        }

        const positionChanged = instance.GetPropertyChangedSignal("AbsolutePosition").Connect(captureTarget);
        const sizeChanged = instance.GetPropertyChangedSignal("AbsoluteSize").Connect(captureTarget);

        return () => {
            positionChanged.Disconnect();
            sizeChanged.Disconnect();
        };
    }, [visible]);

    const child = ElementHelper.cloneWithEvents(props.children, { ref: targetRef }, {
        MouseEnter: () => {
            hoveredRef.current = true;

            if (!controlledRef.current && !suppressedRef.current) {
                show();
            }
        },

        MouseLeave: () => {
            hoveredRef.current = false;

            if (!controlledRef.current) {
                hide();
            }
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