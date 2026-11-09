import { PressKind } from "../../Helpers/press";
declare class HoverButtonPressDownValidation {
    firesOnBegan(kind: PressKind): void;
    gamepadPassesThrough(): void;
    releasesOnEnd(state: string): void;
    inactiveBlocks(): void;
    hoverSetActivated(): void;
    upUnchanged(mode: string): void;
}
export = HoverButtonPressDownValidation;
