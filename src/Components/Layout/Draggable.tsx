import React, { Component, ReactComponent, ReactNode, useContext } from "@rbxts/react";
import { GuiHelper } from "../../Helpers/";
import { DraggableRegistration, DraggableRegistryKey, DroppableRegistration, DroppableRegistryKey, RegistryContext } from "../../Providers";
import { CleanThemeContext, DraggableContext, DraggableContextValue, OverlayConsumer } from "../../Contexts";
import { createPortal } from "@rbxts/react-roblox";
import { Corners } from "../Decorator";
import { UserInputService } from "@rbxts/services";
import { Environment } from "@rbxts/ui-labs";


type GuiObjectProps = React.InstanceProps<GuiObject>;
type GuiElement = React.ReactElement<GuiObjectProps>;

interface ConnectableSignal<TArgs extends unknown[]> {
    Connect(callback: (...args: TArgs) => void): {
        Disconnect(): void;
    };
}

interface InputSignalsLike {
    InputBegan: ConnectableSignal<
        [input: InputObject, gameProcessed: boolean]
    >;

    InputChanged: ConnectableSignal<
        [input: InputObject, gameProcessed: boolean]
    >;

    InputEnded: ConnectableSignal<
        [input: InputObject, gameProcessed: boolean]
    >;
}
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

    const useUserInputService = !Environment.IsStory();

    const inputSignals: InputSignalsLike = Environment.IsStory()
        ? Environment.InputListener
        : UserInputService;

    React.useEffect(() => {

        const inputChangedListener =
            inputSignals.InputChanged.Connect((input) => {
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
            inputSignals.InputEnded.Connect((input) => {
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
    }, [draggable, useUserInputService]);

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
    const theme = useContext(CleanThemeContext)
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

interface DraggableState {
    dragging: boolean;
    overlayPosition: Vector2;
    overlaySize: Vector2;

    placeholderPosition: UDim2;
    placeholderAnchorPoint: Vector2;
    placeholderLayoutOrder: number;
    placeholderZIndex: number;
}

@ReactComponent
export class Draggable extends Component<DraggableProps, DraggableState> {
    static Handle = DragHandle;

    public readonly state: DraggableState = {
        dragging: false,
        overlayPosition: Vector2.zero,
        overlaySize: Vector2.zero,
        placeholderPosition: UDim2.fromOffset(0, 0),
        placeholderAnchorPoint: Vector2.zero,
        placeholderLayoutOrder: 0,
        placeholderZIndex: 1,
    };

    public static contextType = RegistryContext;

    public declare context: React.ContextType<typeof RegistryContext>;

    public rootRef = React.createRef<GuiObject>();

    private readonly placeholderRef = React.createRef<Frame>();

    private dragInformation: DragInformation | undefined;

    private usePlaceholder = this.props.placeholder ?? true

    private registration: DraggableRegistration | undefined;

    componentDidMount(): void {
        const registry = this.context;
        const root = this.rootRef.current;

        if (
            registry === undefined ||
            root === undefined
        ) {
            return;
        }

        const registration: DraggableRegistration = {
            guiObject: root,
            id: this.props.id,
            draggable: this.contextValue,
        };

        this.registration = registration;

        registry.register(
            root,
            DraggableRegistryKey,
            registration,
        );
    }

    componentWillUnmount(): void {
        const registry = this.context;
        const registration = this.registration;

        if (
            registry === undefined ||
            registration === undefined
        ) {
            return;
        }

        registry.unregister(
            registration.guiObject,
            DraggableRegistryKey,
        );

        this.registration = undefined;
    }

    private beginDrag = (input: InputObject, handle: GuiObject) => {
        const root = this.rootRef.current
        if (root === undefined) {
            return;
        }

        const allDraggables = this.context?.getAll(
            DraggableRegistryKey,
        );

        if (
            allDraggables?.some(
                (registration) =>
                    registration.draggable.isDragging,
            )
        )
            return;

        if (this.registration !== undefined)
            this.registration.draggable.isDragging = true;


        this.dragInformation = {
            input,
            inputStart: new Vector2(input.Position.X, input.Position.Y),
            absolutePositionStart: root.AbsolutePosition,
            positionStart: root.Position,
        };

        this.props.onStartDrag?.();

        this.setState({
            dragging: true,

            overlayPosition: root.AbsolutePosition,
            overlaySize: root.AbsoluteSize,

            placeholderPosition: root.Position,
            placeholderAnchorPoint: root.AnchorPoint,
            placeholderLayoutOrder: root.LayoutOrder,
            placeholderZIndex: root.ZIndex,
        });
    };

    private updateDrag = (input: InputObject) => {
        const root = this.rootRef.current;
        const drag = this.dragInformation;

        if (root === undefined || drag === undefined) return;

        const inputPosition = new Vector2(
            input.Position.X,
            input.Position.Y,
        );

        const delta = inputPosition.sub(drag.inputStart);

        const overlayPosition =
            drag.absolutePositionStart.add(delta);

        const dropRegisteration: DroppableRegistration | undefined = this.findDroppable(root, new Vector2(input.Position.X, input.Position.Y));
        this.props.onDragged?.(dropRegisteration);

        this.setState({
            overlayPosition: overlayPosition
        })
    }

    private endDrag = (input: InputObject) => {
        const root = this.rootRef.current;
        const drag = this.dragInformation;

        if (root === undefined || drag === undefined) return;

        if (this.registration)
            this.registration.draggable.isDragging = false;

        const dropRegisteration: DroppableRegistration | undefined = this.findDroppable(root, new Vector2(input.Position.X, input.Position.Y))

        this.dragInformation = undefined;

        this.props.onDropped?.(dropRegisteration);

        if (this.props.retainPosition) {
            const parent = root.Parent;

            if (parent?.IsA("GuiObject")) {
                const localTopLeft = this.state.overlayPosition.sub(
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

        this.setState({ dragging: false });
    }

    private findDroppable(instance: GuiObject, position: Vector2): DroppableRegistration | undefined {
        let result: DroppableRegistration | undefined;

        GuiHelper.getGuiObjectsAtPosition(instance, position).forEach((guiObject: GuiObject) => {
            const registryEntry = this.context?.get(
                guiObject,
                DroppableRegistryKey,
            );
            if (registryEntry) {
                registryEntry?.drop(instance);
                result = registryEntry;
            }
        })

        return result;
    }

    private readonly contextValue: DraggableContextValue = {
        isDragging: false,
        beginDrag: this.beginDrag,
        updateDrag: this.updateDrag,
        endDrag: this.endDrag
    };

    render(): ReactNode {
        const original = React.cloneElement(this.props.children, {
            ref: this.rootRef,
            Visible: !this.state.dragging
        })

        const placeholder = (
            <Placeholder
                ref={this.placeholderRef}
                Position={this.state.placeholderPosition}
                AnchorPoint={this.state.placeholderAnchorPoint}
                Size={UDim2.fromOffset(
                    this.state.overlaySize.X,
                    this.state.overlaySize.Y,
                )}
                AutomaticSize={Enum.AutomaticSize.None}
                BackgroundTransparency={0.3}
                LayoutOrder={this.state.placeholderLayoutOrder}
                ZIndex={this.state.placeholderZIndex}
            />
        );

        return (
            <DraggableContext.Provider value={this.contextValue}>
                {this.usePlaceholder && this.state.dragging && placeholder}
                {original}
                <OverlayConsumer
                    render={(overlay) => {
                        if (
                            !this.state.dragging ||
                            overlay === undefined
                        ) {
                            return undefined;
                        }
                        const localPosition =
                            this.state.overlayPosition.sub(
                                overlay.AbsolutePosition,
                            );


                        return createPortal(
                            React.cloneElement(this.props.children, {
                                Position: UDim2.fromOffset(
                                    localPosition.X,
                                    localPosition.Y,
                                ),

                                Size: UDim2.fromOffset(
                                    this.state.overlaySize.X,
                                    this.state.overlaySize.Y,
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
    }
}