import { Breakpoint } from "../../../Interfaces/";
declare class FieldsetMountValidation {
    inlineAtWideWidth(): void;
    controlFillsRemainingWidth(): void;
    checkboxControlKeepsContentWidth(): void;
    wrapFollowsBreakpoint(hostWidth: number, wrap: Breakpoint, expectedWraps: boolean): void;
    allContained(): void;
}
export = FieldsetMountValidation;
