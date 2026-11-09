import { CssRadiusToken, CssSize } from "../../Interfaces/css.types";
declare class RadiusTokenResolution {
    tokenResolves(token: CssRadiusToken, expected: number): void;
    sizePassesThrough(radius: CssSize): void;
    undefinedStaysUnset(): void;
}
export = RadiusTokenResolution;
