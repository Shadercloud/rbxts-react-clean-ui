import React from "@rbxts/react";
import { TooltipPlacement } from "../../Components/Interaction/Tooltip.placement";
import { DefaultTheme } from "../../Theme";
export declare const FAST_TOOLTIP: {
    fadeDuration: number;
    closeDelay: number;
    longPressDelay: number;
};
export declare const FAST_THEME: import("../../Theme").ThemeTemplate;
export declare const HOLD_SECONDS = 0.3;
export type TooltipTheme = typeof DefaultTheme;
export declare function assertNoPopup(host: Instance, message: string, name?: string): void;
export interface TipOptions {
    name?: string;
    trigger?: string;
    content?: React.ReactNode | string;
    placement?: TooltipPlacement;
    position?: UDim2;
    open?: boolean;
    disabled?: boolean;
    interactive?: boolean;
    pinOnPress?: boolean;
    longPress?: boolean;
}
export declare function tip(options?: TipOptions): React.JSX.Element;
export declare function tipApp(options?: TipOptions, theme?: TooltipTheme): React.JSX.Element;
export declare function coverApp(cover: TipOptions, under?: TipOptions): React.JSX.Element;
export type ParentMode = "plain" | "interactive" | "pinOnPress";
export declare function nestedApp(mode: ParentMode, childOpen: boolean): React.JSX.Element;
export declare function waitForTrigger(host: Instance, name?: string): Frame;
export declare function pressInput(kind?: "MouseButton1" | "Touch"): InputObject;
export interface TouchPress {
    input: InputObject;
    finish: (state: Enum.UserInputState) => void;
}
export declare function touchPress(): TouchPress;
export declare function waitForShown(host: Instance, name?: string, seconds?: number): CanvasGroup;
export declare function assertStaysShown(host: Instance, seconds: number, message: string, name?: string): void;
export declare function fadesBy(popup: CanvasGroup, deadline: number): boolean;
