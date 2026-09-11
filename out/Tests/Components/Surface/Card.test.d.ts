declare class CardMountValidation {
    mountsWithSize(): void;
    defaultPropsContained(): void;
    shortHeaderContained(): void;
    longHeaderContained(): void;
    longHeaderFixedWidth(): void;
    headerTextFits(variant: string, title: string, hostWidth: number): void;
    sectionsDoNotOverlap(): void;
    centeredInHost(): void;
    leftAlignedByDefault(): void;
    respectsExplicitSize(width: number, height: number): void;
    growsWithContent(): void;
    resizeKeepsContained(): void;
}
export = CardMountValidation;
