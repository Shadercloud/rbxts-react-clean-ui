import React, { Component } from "@rbxts/react";
import { ContainerProps } from "../Layout";
import { CleanThemeContext } from "../../Contexts";
type SliderValue = number | Vector2;
type SliderHandleIndex = 0 | 1;
type HighlightOption = "start" | "end" | "middle";
interface SliderProps extends ContainerProps {
    "max-value": number;
    "min-value"?: number;
    value?: SliderValue;
    step?: number;
    onDragged?: (value: SliderValue) => void;
    onChanged?: (value: SliderValue) => void;
    controlled?: boolean;
    range?: boolean;
    highlight?: HighlightOption;
}
interface SliderState {
    value: SliderValue;
    dragging: boolean;
    hoveredHandle?: SliderHandleIndex;
}
export declare class Slider extends Component<SliderProps, SliderState> {
    private inputChangedListener?;
    private inputEndedListener?;
    private isDragging;
    private activeHandle?;
    containerRef: React.RefObject<Frame>;
    static contextType: React.Context<import("../..").CleanTheme>;
    context: React.ContextType<typeof CleanThemeContext>;
    state: SliderState;
    private getInitialValue;
    /**
     * Returns the value currently used to render the slider.
     */
    private getCurrentValue;
    /**
     * Converts an input position into a single slider value.
     */
    private getNumberFromInput;
    /**
     * Converts a single input value into either a number or Vector2,
     * depending on whether range mode is enabled.
     */
    private getValueFromInput;
    private beginDragging;
    componentDidMount(): void;
    componentWillUnmount(): void;
    render(): React.ReactNode;
}
export {};
