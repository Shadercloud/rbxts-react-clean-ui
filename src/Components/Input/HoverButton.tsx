import React from "@rbxts/react";
import { BorderElementProps, ButtonFlag } from "../../Interfaces";
import { isPointerPress, PressOn, PressReleaseCallback, usePressRelease } from "./Button.press";

export interface HoverButtonContextValue {
    hover: boolean;
    isSelected: boolean;
}

export const HoverButtonContext = React.createContext<HoverButtonContextValue | undefined>(
    undefined,
);

type ImageButtonProps = React.InstanceProps<ImageButton>;

type HoverButtonStateProps = ImageButtonProps & BorderElementProps;

interface HoverButtonProps extends BorderElementProps {
    default: HoverButtonStateProps;
    hover?: HoverButtonStateProps;
    focus?: HoverButtonStateProps;
    isSelected?: boolean;
    children?: React.ReactNode;
    name?: string;
    pressOn?: PressOn;
    onRelease?: PressReleaseCallback;
}

export function HoverButton(propSet: HoverButtonProps) {
    const [hovering, setHovering] = React.useState(false);
    const trackRelease = usePressRelease(propSet.onRelease);

    const state: ButtonFlag = propSet.isSelected
        ? "focus"
        : hovering
            ? "hover"
            : "default";


    const stateProps = propSet[state];


    const props: HoverButtonStateProps = {
        ...propSet.default,
        ...stateProps,
    };

    const borderThickness = props.borderThickness ?? propSet.borderThickness ?? 0;
    const borderPosition = props.borderPosition ?? propSet.borderPosition;

    const defaultEvents = propSet.default.Event;
    const stateEvents = stateProps?.Event;
    const activated = stateEvents?.Activated ?? defaultEvents?.Activated;
    const inputBegan = stateEvents?.InputBegan ?? defaultEvents?.InputBegan;

    return (
        <HoverButtonContext.Provider value={{
            hover: hovering,
            isSelected: propSet.isSelected === true
        }}>
            <imagebutton
                key={propSet.name ?? "HoverButton"}
                Active={props.Active}
                AnchorPoint={props.AnchorPoint}
                Archivable={props.Archivable}
                AutoButtonColor={props.AutoButtonColor}
                AutomaticSize={props.AutomaticSize}
                BackgroundColor3={props.BackgroundColor3}
                BackgroundTransparency={props.BackgroundTransparency}
                BorderColor3={props.BorderColor3}
                BorderMode={props.BorderMode}
                BorderSizePixel={props.BorderSizePixel === undefined ? 0 : props.BorderSizePixel}
                ClipsDescendants={props.ClipsDescendants}
                LayoutOrder={props.LayoutOrder}
                Modal={props.Modal}
                NextSelectionDown={props.NextSelectionDown}
                NextSelectionLeft={props.NextSelectionLeft}
                NextSelectionRight={props.NextSelectionRight}
                NextSelectionUp={props.NextSelectionUp}
                Position={props.Position}
                Rotation={props.Rotation}
                Selectable={props.Selectable}
                SelectionBehaviorDown={props.SelectionBehaviorDown}
                SelectionBehaviorLeft={props.SelectionBehaviorLeft}
                SelectionBehaviorRight={props.SelectionBehaviorRight}
                SelectionBehaviorUp={props.SelectionBehaviorUp}
                SelectionGroup={props.SelectionGroup}
                Size={props.Size}
                SizeConstraint={props.SizeConstraint}
                Visible={props.Visible}
                ZIndex={props.ZIndex}
                Image={props.Image}
                ImageColor3={props.ImageColor3}
                ImageRectOffset={props.ImageRectOffset}
                ImageRectSize={props.ImageRectSize}
                ImageTransparency={props.ImageTransparency}
                ResampleMode={props.ResampleMode}
                ScaleType={props.ScaleType}
                SliceCenter={props.SliceCenter}
                SliceScale={props.SliceScale}
                TileSize={props.TileSize}
                Event={{
                    ...defaultEvents,
                    ...stateEvents,

                    MouseEnter: (button, x, y) => {
                        setHovering(true);

                        stateEvents?.MouseEnter?.(button, x, y);

                        if (stateEvents !== defaultEvents) {
                            defaultEvents?.MouseEnter?.(button, x, y);
                        }
                    },

                    MouseLeave: (button, x, y) => {
                        setHovering(false);

                        stateEvents?.MouseLeave?.(button, x, y);

                        if (stateEvents !== defaultEvents) {
                            defaultEvents?.MouseLeave?.(button, x, y);
                        }
                    },

                    ...(propSet.pressOn === "down" ? {
                        Activated: (button: ImageButton, inputObject: InputObject, clickCount: number) => {
                            if (isPointerPress(inputObject)) {
                                return;
                            }

                            activated?.(button, inputObject, clickCount);
                        },

                        InputBegan: (button: ImageButton, inputObject: InputObject) => {
                            inputBegan?.(button, inputObject);

                            if (props.Active === false || !isPointerPress(inputObject)) {
                                return;
                            }

                            activated?.(button, inputObject, 1);

                            if (propSet.onRelease !== undefined) {
                                trackRelease(button, inputObject);
                            }
                        },
                    } : {}),
                }}
                Change={props.Change}
                Tag={props.Tag}
            >
                {borderThickness > 0 && (
                    <uistroke
                        key="Stroke"
                        Thickness={borderThickness}
                        Color={props.borderColor ?? propSet.borderColor}
                        Transparency={props.borderTransparency ?? propSet.borderTransparency}
                        BorderStrokePosition={borderPosition === "outer" ? Enum.BorderStrokePosition.Outer : Enum.BorderStrokePosition.Inner}
                    />
                )}
                {propSet.children}
            </imagebutton>
        </HoverButtonContext.Provider>
    );
}