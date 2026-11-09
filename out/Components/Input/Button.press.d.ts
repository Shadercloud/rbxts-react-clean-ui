export type PressOn = "down" | "up";
export type PressReleaseCallback = (button: ImageButton, input: InputObject) => void;
export declare function isPointerPress(input?: InputObject): boolean;
export declare function usePressRelease(onRelease?: PressReleaseCallback): (button: ImageButton, input: InputObject) => void;
