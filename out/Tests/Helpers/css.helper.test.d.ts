import { CssBackgroundGradient } from "../../Interfaces/css.types";
declare class CssBackgroundGradientResolution {
    undefinedValue(): void;
    colorlessValue(label: string, value: Partial<CssBackgroundGradient>): void;
    singleColorSolid(): void;
    sequencePassthrough(): void;
    evenSpacing(): void;
    shortStopsFallback(): void;
    endpointsForced(): void;
    outOfOrderStops(): void;
    sharedStopKeepsOrder(label: string, colors: Color3[], stops: number[], expected: Array<[number, Color3]>): void;
    clampsStops(label: string, stops: number[], expected: Array<[number, Color3]>): void;
    uniformTransparency(input: number, expected: number): void;
    transparencyPassthrough(): void;
    rotationAndOffset(): void;
}
export = CssBackgroundGradientResolution;
