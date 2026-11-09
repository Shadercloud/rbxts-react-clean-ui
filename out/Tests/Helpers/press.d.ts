import { MountedElement } from "./layout";
export type PressKind = "MouseButton1" | "Touch";
export interface HeldPress {
    input: InputObject;
    finish: (state: Enum.UserInputState) => void;
}
export declare function withPress(kind: PressKind, fn: (press: HeldPress) => void): void;
export declare function gamepadInput(): InputObject;
export declare function releaseState(label: string): Enum.UserInputState;
export declare function hostHandler(mounted: MountedElement, instance: Instance, eventName: string): unknown;
