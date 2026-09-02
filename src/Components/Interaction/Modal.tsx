import React from "@rbxts/react";
import ReactRoblox from "@rbxts/react-roblox";
import { GuiService } from "@rbxts/services";
import { useTween } from "@rbxts/react-ripple";
import { CleanThemeContext, ModalCloseContext, OverlayConsumer, useModalStack } from "../../Contexts";
import { SizeHelper } from "../../Helpers";
import { IntentElementProps } from "../../Interfaces";
import { Draggable } from "../Layout";
import { BoxProps, Card } from "../Surface";

export interface ModalProps extends BoxProps, IntentElementProps {
    open?: boolean;
    defaultOpen?: boolean;
    onOpenChange?: (open: boolean) => void;
    closeOnBackdropClick?: boolean;
    closeOnEscape?: boolean;
    draggable?: boolean;
    initialFocus?: React.RefObject<GuiObject>;
    children?: React.ReactNode;
}

let nextModalId = 0;

function generateModalId() {
    nextModalId++;
    return `modal-${nextModalId}`;
}

// GuiService.SelectedObject can only be set to a descendant of a PlayerGui —
// it throws otherwise (e.g. a ui-labs Studio plugin preview, or any other
// non-PlayerGui host). Focus is a non-essential enhancement, so failures here
// are swallowed rather than crashing the whole render.
function trySetSelectedObject(target: GuiObject | undefined) {
    pcall(() => {
        GuiService.SelectedObject = target;
    });
}

function getPanelContentSize(automaticSize: Enum.AutomaticSize | "None" | "X" | "Y" | "XY"): UDim2 {
    const autoWidth = automaticSize === Enum.AutomaticSize.X || automaticSize === Enum.AutomaticSize.XY || automaticSize === "X" || automaticSize === "XY";
    const autoHeight = automaticSize === Enum.AutomaticSize.Y || automaticSize === Enum.AutomaticSize.XY || automaticSize === "Y" || automaticSize === "XY";

    return UDim2.fromScale(autoWidth ? 0 : 1, autoHeight ? 0 : 1);
}

export function Modal(props: ModalProps) {
    const theme = React.useContext(CleanThemeContext);
    const stack = useModalStack();

    const idRef = React.useRef<string>();

    if (idRef.current === undefined) {
        idRef.current = generateModalId();
    }

    const id = idRef.current;

    const closeOnBackdropClick = props.closeOnBackdropClick ?? true;
    const closeOnEscape = props.closeOnEscape ?? true;
    const isControlled = props.open !== undefined;

    const [uncontrolledOpen, setUncontrolledOpen] = React.useState(props.defaultOpen ?? false);
    const open = props.open ?? uncontrolledOpen;
    const [shouldRender, setShouldRender] = React.useState(open);

    const dismissingRef = React.useRef(false);
    const fadeThreadRef = React.useRef<thread>();
    const panelRef = React.useRef<ImageLabel>();
    const previousSelectionRef = React.useRef<GuiObject | undefined>();

    const onOpenChangeRef = React.useRef(props.onOpenChange);

    React.useEffect(() => {
        onOpenChangeRef.current = props.onOpenChange;
    }, [props.onOpenChange]);

    const requestClose = React.useCallback(() => {
        if (!isControlled) {
            setUncontrolledOpen(false);
        }

        onOpenChangeRef.current?.(false);
    }, [isControlled]);

    const requestCloseRef = React.useRef(requestClose);

    React.useEffect(() => {
        requestCloseRef.current = requestClose;
    }, [requestClose]);

    const closeOnEscapeRef = React.useRef(closeOnEscape);

    React.useEffect(() => {
        closeOnEscapeRef.current = closeOnEscape;
    }, [closeOnEscape]);

    const fadeDuration = theme.components.modal.fadeDuration;
    const backdropGoalTransparency = theme.components.modal.backdrop.backgroundTransparency;

    const [backdropTransparency, backdropTween] = useTween(1, {
        duration: fadeDuration,
        easing: "quadOut",
    });

    const [panelTransparency, panelTween] = useTween(1, {
        duration: fadeDuration,
        easing: "quadOut",
    });

    const beginExit = React.useCallback(() => {
        if (dismissingRef.current) {
            return;
        }

        dismissingRef.current = true;

        if (fadeDuration <= 0) {
            setShouldRender(false);
            return;
        }

        fadeThreadRef.current = task.delay(fadeDuration, () => {
            fadeThreadRef.current = undefined;
            setShouldRender(false);
        });
    }, [fadeDuration]);

    // Public open state vs. animated-unmount state: closing must finish its
    // fade before the portal actually disappears, so `shouldRender` lags
    // `open` on the way down (see beginExit above).
    React.useEffect(() => {
        if (open) {
            const fadeThread = fadeThreadRef.current;

            if (fadeThread !== undefined) {
                task.cancel(fadeThread);
                fadeThreadRef.current = undefined;
            }

            dismissingRef.current = false;
            setShouldRender(true);
        } else if (shouldRender) {
            beginExit();
        }
    }, [open]);

    React.useEffect(() => {
        if (!shouldRender) {
            return;
        }

        backdropTween.setGoal(open ? backdropGoalTransparency : 1);
        panelTween.setGoal(open ? 0 : 1);
    }, [open, shouldRender, backdropGoalTransparency]);

    React.useEffect(() => {
        return () => {
            const fadeThread = fadeThreadRef.current;

            if (fadeThread !== undefined) {
                task.cancel(fadeThread);
            }
        };
    }, []);

    // Registers with the shared modal stack only while actually visible
    // (including through the closing fade), so escape only ever targets the
    // topmost visible modal. closeOnEscape/requestClose are read through
    // refs kept current every render (see above) so this effect only needs
    // to run when shouldRender flips.
    React.useEffect(() => {
        if (!shouldRender) {
            return;
        }

        stack.register({
            id,
            closeOnEscape: () => closeOnEscapeRef.current,
            requestClose: () => requestCloseRef.current(),
        });

        return () => {
            stack.unregister(id);
        };
    }, [shouldRender]);

    // Scoped per-instance so nested modals restore focus to whatever was
    // selected right before THEY opened, not a single shared value.
    React.useEffect(() => {
        if (!shouldRender) {
            return;
        }

        previousSelectionRef.current = GuiService.SelectedObject;
        trySetSelectedObject(props.initialFocus?.current ?? panelRef.current);

        return () => {
            trySetSelectedObject(previousSelectionRef.current);
        };
    }, [shouldRender]);

    if (!shouldRender) {
        return undefined;
    }

    const layerIndex = stack.getLayerIndex(id);
    const backdropZIndex = theme.components.modal.baseZIndex + layerIndex * theme.components.modal.zIndexStep;

    return (
        <OverlayConsumer
            render={(overlay) => {
                if (overlay === undefined) {
                    return undefined;
                }

                const panelChildren = props.draggable
                    ? React.Children.map(props.children, (child) =>
                        React.isValidElement(child) && child.type === Card.Header
                            ? <Draggable.Handle>{child as React.ReactElement<React.InstanceProps<GuiObject>>}</Draggable.Handle>
                            : child,
                    )
                    : props.children;
                const panelSizingProps = {
                    ...props,
                    width: props.width ?? theme.components.modal.width,
                };
                const panelSize = SizeHelper.GetSize(panelSizingProps);
                const panelAutomaticSize = SizeHelper.GetAutoSize(panelSizingProps);
                const panelContentSize = typeIs(panelAutomaticSize, "table") && "map" in panelAutomaticSize
                    ? panelAutomaticSize.map(getPanelContentSize)
                    : getPanelContentSize(panelAutomaticSize);

                const panel = (
                    <imagebutton
                        key="ModalPanelInputShield"
                        Active={true}
                        AnchorPoint={props.draggable ? new Vector2(0.5, 0.5) : undefined}
                        AutoButtonColor={false}
                        AutomaticSize={panelAutomaticSize}
                        BackgroundTransparency={1}
                        ImageTransparency={1}
                        Position={props.draggable ? UDim2.fromScale(0.5, 0.5) : undefined}
                        Size={panelSize}
                        Event={{ Activated: () => { } }}
                    >
                        <Card
                            {...props}
                            name={props.name ?? "Modal"}
                            ref={panelRef}
                            Selectable={true}
                            Size={panelContentSize}
                            AutomaticSize={panelAutomaticSize}
                            width={undefined}
                            height={undefined}
                        >
                            {panelChildren}
                        </Card>
                    </imagebutton>
                );

                return ReactRoblox.createPortal(
                    <imagebutton
                        key="ModalBackdrop"
                        Size={UDim2.fromScale(1, 1)}
                        AutoButtonColor={false}
                        Active={true}
                        BackgroundColor3={theme.components.modal.backdrop.backgroundColor}
                        BackgroundTransparency={backdropTransparency}
                        ZIndex={backdropZIndex}
                        Event={{
                            Activated: () => {
                                if (closeOnBackdropClick) {
                                    requestClose();
                                }
                            },
                        }}
                    >
                        <canvasgroup
                            key="ModalPanel"
                            Size={UDim2.fromScale(1, 1)}
                            BackgroundTransparency={1}
                            GroupTransparency={panelTransparency}
                            ZIndex={2}
                        >
                            {!props.draggable && (
                                <uilistlayout
                                    key="CenterLayout"
                                    FillDirection={Enum.FillDirection.Horizontal}
                                    HorizontalAlignment={Enum.HorizontalAlignment.Center}
                                    VerticalAlignment={Enum.VerticalAlignment.Center}
                                />
                            )}
                            <ModalCloseContext.Provider value={requestClose}>
                                {props.draggable ? (
                                    <Draggable placeholder={false} retainPosition>
                                        {panel}
                                    </Draggable>
                                ) : panel}
                            </ModalCloseContext.Provider>
                        </canvasgroup>
                    </imagebutton>,
                    overlay,
                );
            }}
        />
    );
}
