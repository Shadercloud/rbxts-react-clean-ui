import React from "@rbxts/react";
import { ElementHelper, GuiHelper } from "../../Helpers/";
import { DraggableRegistration, DraggableRegistryKey, DroppableRegistration, DroppableRegistryKey, GlobalRegistry, RegistryContext } from "../../Providers";
import { CleanThemeContext, DragEventInfo, DragStateContext, DragStateContextValue, DraggableContext, DraggableContextValue, OverlayConsumer, useUiScale } from "../../Contexts";
import { createPortal } from "@rbxts/react-roblox";
import { Corners } from "../Decorator";
import { CustomInputService, toDesignPixels } from "../../Helpers";
import { OverlayScaleFrame } from "./UiScaleRoot.frame";


type GuiObjectProps = React.InstanceProps<GuiObject>;
type GuiElement = React.ReactElement<GuiObjectProps>;

const DEFAULT_INPUT_TYPES = [Enum.UserInputType.MouseButton1, Enum.UserInputType.Touch];

const PREVIEW_DRAG_STATE: DragStateContextValue = {
    preview: true,
    dragging: true,
};

interface DragInformation {
    root: GuiObject;
    input: InputObject;
    inputType: Enum.UserInputType;
    keyCode?: Enum.KeyCode;
    inputStart: Vector2;
    positionStart: UDim2;
    absolutePositionStart: Vector2;
}

interface DragHandleProps {
    children: GuiElement;
}

function toPoint(input: InputObject): Vector2 {
    return new Vector2(input.Position.X, input.Position.Y);
}

function createDragEventInfo(input: InputObject, dragInformation: DragInformation, id?: string): DragEventInfo {
    return {
        inputType: dragInformation.inputType,
        input,
        position: toPoint(input),
        id,
    };
}

function isInteractiveDescendantAtInput(handle: GuiObject, input: InputObject): boolean {
    const point = toPoint(input);

    return handle.GetDescendants().some((descendant) =>
        (descendant.IsA("GuiButton") || descendant.IsA("TextBox")) &&
        GuiHelper.isGuiObjectHitAtPoint(descendant, point),
    );
}


function DragHandle({ children }: DragHandleProps) {
    const draggable = React.useContext(DraggableContext);
    const dragState = React.useContext(DragStateContext);

    assert(
        draggable !== undefined,
        "Draggable.Handle must be used inside a Draggable component",
    );

    const inert = dragState.preview;

    React.useEffect(() => {
        if (inert) {
            return;
        }

        const inputChangedListener =
            CustomInputService.InputChanged.Connect((input) => {
                if (
                    input.UserInputType ===
                    Enum.UserInputType.MouseMovement ||
                    input.UserInputType ===
                    Enum.UserInputType.Touch
                ) {
                    draggable.updateDrag(input);
                }
            });

        const inputEndedListener =
            CustomInputService.InputEnded.Connect((input) => {
                draggable.endDrag(input);
            });

        return () => {
            inputChangedListener.Disconnect();
            inputEndedListener.Disconnect();
        };
    }, [draggable, inert]);

    if (inert) {
        return React.cloneElement(children, { Active: true });
    }

    return ElementHelper.cloneWithEvents(children, { Active: true }, {
        InputBegan: (
            instance: GuiObject,
            input: InputObject,
        ) => {
            if (!isInteractiveDescendantAtInput(instance, input)) {
                draggable.beginDrag(input, instance);
            }
        },
    });
}

function Placeholder(props: React.InstanceProps<Frame>) {
    const theme = React.useContext(CleanThemeContext)
    return <frame
        key="DraggablePlaceholder"
        BorderSizePixel={0}
        {...props}
        BackgroundTransparency={theme.components.draggable.placeholder.backgroundTransparency}
        BackgroundColor3={theme.components.draggable.placeholder.backgroundColor}
    >
        <uistroke
            key="Stroke"
            Thickness={theme.components.draggable.placeholder.borderThickness}
            BorderStrokePosition={Enum.BorderStrokePosition.Inner}
            Color={theme.components.draggable.placeholder.borderColor}
        />
        <Corners radius={theme.components.draggable.placeholder.cornerRadius} />
    </frame>
}

export interface DraggableProps {
    onDropped?: (droppable: DroppableRegistration | undefined, info: DragEventInfo) => void;
    onDragged?: (droppable: DroppableRegistration | undefined, info: DragEventInfo) => void;
    onStartDrag?: (info: DragEventInfo) => void;
    inputTypes?: Enum.UserInputType[];
    renderOverlay?: () => React.ReactNode;
    placeholder?: boolean;
    retainPosition?: boolean;
    children: GuiElement;
    id?: string;
}

interface PlaceholderPosition {
    Position: UDim2;
    AnchorPoint: Vector2;
    LayoutOrder: number;
    ZIndex: number;
}

type DraggableComponent = React.ForwardRefExoticComponent<
    DraggableProps & React.RefAttributes<Frame>
> & {
    Handle: typeof DragHandle;
};

const Draggable = React.forwardRef<Frame, DraggableProps>(
    (props, _ref) => {
        const [dragging, setDragging] = React.useState<boolean>(false);
        const [overlayPosition, setOverlayPosition] = React.useState<Vector2>(Vector2.zero);
        const [overlaySize, setOverlaySize] = React.useState<Vector2>(Vector2.zero);
        const [placeholderPosition, setPlaceholderPosition] = React.useState<PlaceholderPosition>({
            Position: UDim2.fromOffset(0, 0),
            AnchorPoint: Vector2.zero,
            LayoutOrder: 0,
            ZIndex: 1,
        })

        const registry = React.useContext(RegistryContext);

        const parentDragState = React.useContext(DragStateContext);

        const uiScale = useUiScale();

        const rootRef = React.useRef<GuiObject>();

        const placeholderRef = React.useRef<Frame>();

        const dragInformationRef = React.useRef<DragInformation>();

        const hoveredRef = React.useRef<DroppableRegistration>();

        const idRef = React.useRef<string>();
        idRef.current = props.id;

        const usePlaceholder = props.placeholder ?? true

        const inputTypes = props.inputTypes ?? DEFAULT_INPUT_TYPES;

        const registrationRef = React.useRef<DraggableRegistration>();

        const findDroppable = React.useCallback((position: Vector2): DroppableRegistration | undefined => {
            let result: DroppableRegistration | undefined;

            for (const registryEntry of GlobalRegistry.getAll(DroppableRegistryKey)) {
                if (!GuiHelper.isGuiObjectHitAtPoint(registryEntry.guiObject, position))
                    continue;

                if (result === undefined || GuiHelper.isRenderedAbove(registryEntry.guiObject, result.guiObject))
                    result = registryEntry;
            }

            return result;
        }, []);

        const beginDrag = React.useCallback((input: InputObject): void => {
            const root = rootRef.current
            const registration = registrationRef.current;

            if (root === undefined || dragInformationRef.current !== undefined)
                return;

            if (!inputTypes.includes(input.UserInputType))
                return;

            const allDraggables = GlobalRegistry.getAll(
                DraggableRegistryKey,
            );

            if (
                allDraggables.some(
                    (registration) =>
                        registration.draggable.isDragging,
                )
            )
                return;

            if (registration !== undefined)
                registration.draggable.isDragging = true;


            const dragInformation: DragInformation = {
                root,
                input,
                inputType: input.UserInputType,
                keyCode: input.KeyCode,
                inputStart: toPoint(input),
                absolutePositionStart: root.AbsolutePosition,
                positionStart: root.Position,
            };

            dragInformationRef.current = dragInformation;
            hoveredRef.current = undefined;

            props.onStartDrag?.(createDragEventInfo(input, dragInformation, props.id));

            setDragging(true);
            setOverlayPosition(root.AbsolutePosition);
            setOverlaySize(root.AbsoluteSize);
            setPlaceholderPosition({
                Position: root.Position,
                AnchorPoint: root.AnchorPoint,
                LayoutOrder: root.LayoutOrder,
                ZIndex: root.ZIndex,
            })

        }, [props.onStartDrag, props.id, inputTypes]);

        const updateDrag = React.useCallback((input: InputObject): void => {
            const root = rootRef.current;
            const dragInformation = dragInformationRef.current;

            if (root === undefined || dragInformation === undefined)
                return;

            const inputPosition = toPoint(input);

            const delta = inputPosition.sub(dragInformation.inputStart);

            const info = createDragEventInfo(input, dragInformation, props.id);
            const dropRegisteration: DroppableRegistration | undefined = findDroppable(inputPosition);
            const hovered = hoveredRef.current;

            if (hovered?.guiObject !== dropRegisteration?.guiObject) {
                hoveredRef.current = dropRegisteration;
                hovered?.dragLeave?.(root, info);
                dropRegisteration?.dragEnter?.(root, info);
            }

            props.onDragged?.(dropRegisteration, info);

            setOverlayPosition(dragInformation.absolutePositionStart.add(delta));

        }, [findDroppable, props.onDragged, props.id]);

        const endDrag = React.useCallback((input: InputObject): void => {
            const root = rootRef.current;
            const dragInformation = dragInformationRef.current;
            const registration = registrationRef.current;

            if (root === undefined || dragInformation === undefined)
                return;

            if (
                input.UserInputType !== dragInformation.inputType ||
                input.KeyCode !== dragInformation.keyCode
            )
                return;

            if (registration)
                registration.draggable.isDragging = false;

            const inputPosition = toPoint(input);
            const info = createDragEventInfo(input, dragInformation, props.id);
            const dropRegisteration: DroppableRegistration | undefined = findDroppable(inputPosition);
            const hovered = hoveredRef.current;

            dragInformationRef.current = undefined;
            hoveredRef.current = undefined;

            dropRegisteration?.drop(root, info);
            hovered?.dragLeave?.(root, info);

            props.onDropped?.(dropRegisteration, info);

            if (props.retainPosition) {
                const parent = root.Parent;

                if (parent?.IsA("GuiObject")) {
                    const delta = inputPosition.sub(
                        dragInformation.inputStart,
                    );

                    const finalOverlayPosition =
                        dragInformation.absolutePositionStart.add(delta);

                    const localTopLeft = toDesignPixels(
                        finalOverlayPosition.sub(parent.AbsolutePosition),
                        uiScale,
                    );

                    const anchorOffset = toDesignPixels(
                        root.AbsoluteSize.mul(root.AnchorPoint),
                        uiScale,
                    );

                    root.Position = UDim2.fromOffset(
                        localTopLeft.X + anchorOffset.X,
                        localTopLeft.Y + anchorOffset.Y,
                    );
                }
            }

            setDragging(false);

        }, [findDroppable, props.onDropped, props.retainPosition, props.id, uiScale]);

        const contextValue = React.useMemo<DraggableContextValue>(() => ({
            isDragging: dragInformationRef.current !== undefined,
            beginDrag,
            updateDrag,
            endDrag,
        }), [beginDrag, updateDrag, endDrag]);


        React.useEffect(() => {
            const root = rootRef.current;

            if (root === undefined || parentDragState.preview) {
                return;
            }

            const registration: DraggableRegistration = {
                guiObject: root,
                id: props.id,
                draggable: contextValue,
            };

            registrationRef.current = registration;

            registry?.register(
                root,
                DraggableRegistryKey,
                registration,
            );

            GlobalRegistry.register(
                root,
                DraggableRegistryKey,
                registration,
            );

            return () => {
                registry?.unregister(
                    registration.guiObject,
                    DraggableRegistryKey,
                );

                if (GlobalRegistry.get(registration.guiObject, DraggableRegistryKey) === registration) {
                    GlobalRegistry.unregister(
                        registration.guiObject,
                        DraggableRegistryKey,
                    );
                }

                if (registrationRef.current === registration) {
                    registrationRef.current = undefined;
                }
            };
        }, [
            registry,
            props.id,
            contextValue,
            parentDragState.preview,
        ]);

        React.useEffect(() => {
            return () => {
                const dragInformation = dragInformationRef.current;
                const hovered = hoveredRef.current;

                hoveredRef.current = undefined;

                if (dragInformation !== undefined && hovered !== undefined) {
                    hovered.dragLeave?.(dragInformation.root, createDragEventInfo(dragInformation.input, dragInformation, idRef.current));
                }
            };
        }, []);

        const dragStateValue = React.useMemo<DragStateContextValue>(() => ({
            preview: parentDragState.preview,
            dragging: parentDragState.dragging || dragging,
        }), [parentDragState.preview, parentDragState.dragging, dragging]);

        const original = React.cloneElement(props.children, {
            ref: rootRef,
            Visible: !dragging
        })

        const designOverlaySize = toDesignPixels(overlaySize, uiScale);

        const placeholder = (
            <Placeholder
                ref={placeholderRef}
                Position={placeholderPosition.Position}
                AnchorPoint={placeholderPosition.AnchorPoint}
                Size={UDim2.fromOffset(
                    designOverlaySize.X,
                    designOverlaySize.Y,
                )}
                AutomaticSize={Enum.AutomaticSize.None}
                BackgroundTransparency={0.3}
                LayoutOrder={placeholderPosition.LayoutOrder}
                ZIndex={placeholderPosition.ZIndex}
            />
        );

        return (
            <DraggableContext.Provider value={contextValue}>
                <DragStateContext.Provider value={dragStateValue}>
                    {usePlaceholder && dragging && placeholder}
                    {original}
                </DragStateContext.Provider>
                <OverlayConsumer
                    render={(overlay) => {
                        if (
                            !dragging ||
                            overlay === undefined
                        ) {
                            return undefined;
                        }
                        const localPosition = toDesignPixels(
                            overlayPosition.sub(
                                overlay.AbsolutePosition,
                            ),
                            uiScale,
                        );

                        const position = UDim2.fromOffset(
                            localPosition.X,
                            localPosition.Y,
                        );

                        const size = UDim2.fromOffset(
                            designOverlaySize.X,
                            designOverlaySize.Y,
                        );

                        const preview = props.renderOverlay !== undefined
                            ? (
                                <frame
                                    key="DragOverlay"
                                    Position={position}
                                    Size={size}
                                    BackgroundTransparency={1}
                                    BorderSizePixel={0}
                                    ZIndex={100001}
                                >
                                    {props.renderOverlay()}
                                </frame>
                            )
                            : React.cloneElement(props.children, {
                                Position: position,
                                Size: size,
                                AnchorPoint: Vector2.zero,
                                AutomaticSize: Enum.AutomaticSize.None,
                                Visible: true,
                                ZIndex: 100001,
                            });

                        return createPortal(
                            <OverlayScaleFrame ZIndex={100001}>
                                <DragStateContext.Provider value={PREVIEW_DRAG_STATE}>
                                    {preview}
                                </DragStateContext.Provider>
                            </OverlayScaleFrame>,
                            overlay,
                        );

                    }}
                />
            </DraggableContext.Provider>
        );
    }) as DraggableComponent;

Draggable.Handle = DragHandle;

export { Draggable }
