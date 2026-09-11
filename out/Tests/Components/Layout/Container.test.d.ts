declare class ContainerMountValidation {
    autoSizesToContent(): void;
    respectsExplicitSize(width: number, height: number): void;
    centeredExplicitSize(): void;
    centeredAutoSize(): void;
    namedContainerContainsChildren(): void;
}
export = ContainerMountValidation;
