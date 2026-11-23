declare class UiScaleRootMountValidation {
    fillsHost(scale: number): void;
    fillsScreenGui(scale: number): void;
    uiScaleSet(scale: number): void;
    childScaled(scale: number, expectedWidth: number, expectedHeight: number): void;
    transparent(): void;
    zIndexForwarded(zIndex: number | undefined, expected: number): void;
    treeShapeAtOne(): void;
    customName(): void;
    forwardsRef(): void;
    nestedComposes(): void;
}
export = UiScaleRootMountValidation;
