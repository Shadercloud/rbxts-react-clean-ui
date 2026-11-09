import { CssRadiusToken, CssSize } from "../../../Interfaces/";
declare class CornersMountValidation {
    numericRadius(): void;
    percentRadiusAndName(): void;
    zeroRadiusEmitsNothing(radius: CssSize): void;
    noRadiusEmitsNothing(): void;
    tokenFromTheme(token: CssRadiusToken): void;
    tokenFollowsTheme(): void;
    zeroTokenEmitsNothing(): void;
}
export = CornersMountValidation;
