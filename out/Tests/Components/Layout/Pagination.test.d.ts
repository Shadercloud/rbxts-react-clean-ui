declare class PaginationMountValidation {
    allPages(): void;
    startWindow(): void;
    endWindow(): void;
    zeroSiblings(): void;
    twoSiblings(): void;
    firstPageState(): void;
    lastPageState(): void;
    noItemStrokeByDefault(): void;
    itemStrokeWhenThemed(): void;
    customChildren(): void;
    customList(): void;
    visualOrder(): void;
    constantItemCount(): void;
    cursorPrevNextOnly(): void;
    cursorNextNeedsFlag(label: string, nextEnabled: boolean): void;
    cursorEmitsFloored(): void;
    cursorListEmpty(): void;
    totalPagesIgnoresFlag(): void;
}
export = PaginationMountValidation;
