import React from "@rbxts/react";
import { GuiHelper } from "../../Helpers/";
import { DraggableRegistration, DraggableRegistryKey, DroppableRegistration, DroppableRegistryKey, RegistryContext } from "../../Providers";
import { CleanThemeContext, DraggableContext, DraggableContextValue, OverlayConsumer } from "../../Contexts";
import { createPortal } from "@rbxts/react-roblox";
import { Corners } from "../Decorator";
import { CustomInputService } from "../../Helpers";


type GuiObjectProps = React.InstanceProps<GuiObject>;
type GuiElement = React.ReactElement<GuiObjectProps>;


interface DragInformation {
    input: InputObject;
    inputStart: Vector2;
    positionStart: UDim2;
    absolutePositionStart: Vector2;
}

interface DragHandleProps {
    children: GuiElement;
}


function DragHandle({ children }: DragHandleProps) {
    const draggable = React.useContext(DraggableContext);

    assert(
        draggable !== undefined,
        "Draggable.Handle must be used inside a Draggable component",
    );

    const childEvents = children.props.Event;

    React.useEffect(() => {
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
                if (
                    input.UserInputType ===
                    Enum.UserInputType.MouseButton1 ||
                    input.UserInputType ===
                    Enum.UserInputType.Touch
                ) {
                    draggable.endDrag(input);
                }
            });

        return () => {
            inputChangedListener.Disconnect();
            inputEndedListener.Disconnect();
        };
    }, [draggable]);

    return React.cloneElement(children, {
        Active: true,

        Event: {
            ...childEvents,

            InputBegan: (
                instance: GuiObject,
                input: InputObject,
            ) => {
                childEvents?.InputBegan?.(instance, input);

                if (
                    input.UserInputType ===
                    Enum.UserInputType.MouseButton1 ||
                    input.UserInputType ===
                    Enum.UserInputType.Touch
                ) {
                    draggable.beginDrag(input, instance);
                }
            },
        },
    });
}

function Placeholder(props: React.InstanceProps<Frame>) {
    const theme = React.useContext(CleanThemeContext)
    return <frame
        {...props}
        BackgroundTransparency={theme.components.draggable.placeholder.backgroundTransparency}
        BackgroundColor3={theme.components.draggable.placeholder.backgroundColor}
    >
        <uistroke
            Thickness={theme.components.draggable.placeholder.borderThickness}
            BorderStrokePosition={Enum.BorderStrokePosition.Inner}
            Color={theme.components.draggable.placeholder.borderColor}
        />
        <Corners radius={theme.components.draggable.placeholder.cornerRadius} />
    </frame>
}

interface DraggableProps {
    onDropped?: (droppable?: DroppableRegistration) => void;
    onDragged?: (droppable?: DroppableRegistration) => void;
    onStartDrag?: () => void;
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

        const rootRef = React.useRef<GuiObject>();

        const placeholderRef = React.useRef<Frame>();

        const dragInformationRef = React.useRef<DragInformation>();

        const usePlaceholder = props.placeholder ?? true

        const registrationRef = React.useRef<DraggableRegistration>();

        const findDroppable = React.useCallback((instance: GuiObject, position: Vector2): DroppableRegistration | undefined => {
            let result: DroppableRegistration | undefined;

            GuiHelper.getGuiObjectsAtPosition(instance, position).forEach((guiObject: GuiObject) => {
                const registryEntry = registry?.get(
                    guiObject,
                    DroppableRegistryKey,
                );
                if (registryEntry) {
                    registryEntry?.drop(instance);
                    result = registryEntry;
                }
            })

            return result;
        }, [registry]);

        const beginDrag = React.useCallback((input: InputObject, handle: GuiObject): void => {
            const root = rootRef.current
            const registration = registrationRef.current;

            if (root === undefined)
                return;

            const allDraggables = registry?.getAll(
                DraggableRegistryKey,
            );

            if (
                allDraggables?.some(
                    (registration) =>
                        registration.draggable.isDragging,
                )
            )
                return;

            if (registration !== undefined)
                registration.draggable.isDragging = true;


            dragInformationRef.current = {
                input,
                inputStart: new Vector2(input.Position.X, input.Position.Y),
                absolutePositionStart: root.AbsolutePosition,
                positionStart: root.Position,
            };

            props.onStartDrag?.();

            setDragging(true);
            setOverlayPosition(root.AbsolutePosition);
            setOverlaySize(root.AbsoluteSize);
            setPlaceholderPosition({
                Position: root.Position,
                AnchorPoint: root.AnchorPoint,
                LayoutOrder: root.LayoutOrder,
                ZIndex: root.ZIndex,
            })

        }, [registry, props.onStartDrag]);

        const updateDrag = React.useCallback((input: InputObject): void => {
            const root = rootRef.current;
            const dragInformation = dragInformationRef.current;

            if (root === undefined || dragInformation === undefined)
                return;

            const inputPosition = new Vector2(
                input.Position.X,
                input.Position.Y,
            );

            const delta = inputPosition.sub(dragInformation.inputStart);

            const dropRegisteration: DroppableRegistration | undefined = findDroppable(root, new Vector2(input.Position.X, input.Position.Y));
            props.onDragged?.(dropRegisteration);

            setOverlayPosition(dragInformation.absolutePositionStart.add(delta));

        }, [findDroppable, props.onDragged]);

        const endDrag = React.useCallback((input: InputObject): void => {
            const root = rootRef.current;
            const dragInformation = dragInformationRef.current;
            const registration = registrationRef.current;

            if (root === undefined || dragInformation === undefined)
                return;

            if (registration)
                registration.draggable.isDragging = false;

            const dropRegisteration: DroppableRegistration | undefined = findDroppable(root, new Vector2(input.Position.X, input.Position.Y))

            dragInformationRef.current = undefined;

            props.onDropped?.(dropRegisteration);

            if (props.retainPosition) {
                const parent = root.Parent;

                if (parent?.IsA("GuiObject")) {
                    const inputPosition = new Vector2(
                        input.Position.X,
                        input.Position.Y,
                    );

                    const delta = inputPosition.sub(
                        dragInformation.inputStart,
                    );

                    const finalOverlayPosition =
                        dragInformation.absolutePositionStart.add(delta);

                    const localTopLeft = finalOverlayPosition.sub(
                        parent.AbsolutePosition,
                    );

                    const anchorOffset = root.AbsoluteSize.mul(
                        root.AnchorPoint,
                    );

                    root.Position = UDim2.fromOffset(
                        localTopLeft.X + anchorOffset.X,
                        localTopLeft.Y + anchorOffset.Y,
                    );
                }
            }

            setDragging(false);

        }, [findDroppable, props.onDropped, props.retainPosition]);

        const contextValue = React.useMemo<DraggableContextValue>(() => ({
            isDragging: false,
            beginDrag,
            updateDrag,
            endDrag,
        }), [beginDrag, updateDrag, endDrag]);


        React.useEffect(() => {
            const root = rootRef.current;

            if (registry === undefined || root === undefined) {
                return;
            }

            const registration: DraggableRegistration = {
                guiObject: root,
                id: props.id,
                draggable: contextValue,
            };

            registrationRef.current = registration;

            registry.register(
                root,
                DraggableRegistryKey,
                registration,
            );

            return () => {
                registry.unregister(
                    registration.guiObject,
                    DraggableRegistryKey,
                );

                if (registrationRef.current === registration) {
                    registrationRef.current = undefined;
                }
            };
        }, [
            registry,
            props.id,
            contextValue,
        ]);

        const original = React.cloneElement(props.children, {
            ref: rootRef,
            Visible: !dragging
        })

        const placeholder = (
            <Placeholder
                ref={placeholderRef}
                Position={placeholderPosition.Position}
                AnchorPoint={placeholderPosition.AnchorPoint}
                Size={UDim2.fromOffset(
                    overlaySize.X,
                    overlaySize.Y,
                )}
                AutomaticSize={Enum.AutomaticSize.None}
                BackgroundTransparency={0.3}
                LayoutOrder={placeholderPosition.LayoutOrder}
                ZIndex={placeholderPosition.ZIndex}
            />
        );

        return (
            <DraggableContext.Provider value={contextValue}>
                {usePlaceholder && dragging && placeholder}
                {original}
                <OverlayConsumer
                    render={(overlay) => {
                        if (
                            !dragging ||
                            overlay === undefined
                        ) {
                            return undefined;
                        }
                        const localPosition =
                            overlayPosition.sub(
                                overlay.AbsolutePosition,
                            );


                        return createPortal(
                            React.cloneElement(props.children, {
                                Position: UDim2.fromOffset(
                                    localPosition.X,
                                    localPosition.Y,
                                ),

                                Size: UDim2.fromOffset(
                                    overlaySize.X,
                                    overlaySize.Y,
                                ),

                                AnchorPoint: Vector2.zero,
                                AutomaticSize: Enum.AutomaticSize.None,
                                Visible: true,
                                ZIndex: 100001,
                            }),
                            overlay,
                        );

                    }}
                />
            </DraggableContext.Provider>
        );
    }) as DraggableComponent;

Draggable.Handle = DragHandle;

export { Draggable }
