declare class ModalStackProviderValidation {
    registeringLayersAssignsIncreasingIndicesInRegistrationOrder(): void;
    getLayerIndexReturnsNegativeOneForAnUnregisteredId(): void;
    unregisteringALayerRemovesItAndShiftsSubsequentIndicesDown(): void;
}
export = ModalStackProviderValidation;
