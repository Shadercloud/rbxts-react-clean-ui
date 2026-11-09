import { CssPadding, CssRadius } from "../../../Interfaces/";
declare class ContainerMountValidation {
    autoSizesToContent(): void;
    respectsExplicitSize(width: number, height: number): void;
    centeredExplicitSize(): void;
    centeredAutoSize(): void;
    namedContainerContainsChildren(): void;
    noDecoratorsByDefault(): void;
    zeroThicknessNoStroke(): void;
    strokeFromBorderProps(): void;
    outerBorderPosition(): void;
    paddingQuadSides(padding: CssPadding, top: number, right: number, bottom: number, left: number): void;
    paddingGrowsAutoSize(): void;
    cornerRadiusResolves(radius: CssRadius, scale: number, offset: number): void;
    zeroRadiusNoCorner(): void;
    centeredDecoratorsOnInner(): void;
}
export = ContainerMountValidation;
