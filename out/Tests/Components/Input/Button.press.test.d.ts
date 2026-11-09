import { PressKind } from "../../Helpers/press";
declare class ButtonPressDownValidation {
    firesOnBegan(kind: PressKind): void;
    gamepadPassesThrough(): void;
    releasesOnEnd(state: string): void;
    touchesTrackedSeparately(): void;
    disabledBlocks(): void;
    disabledMidHold(): void;
    unmountDropsRelease(): void;
    callerInputBeganFirst(): void;
    upUnchanged(mode: string): void;
}
export = ButtonPressDownValidation;
