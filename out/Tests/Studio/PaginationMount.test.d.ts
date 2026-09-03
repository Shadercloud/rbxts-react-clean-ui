declare class PaginationMountValidation {
    rendersEveryPageWithoutEllipsesWhenTotalFitsTheVisibleWindow(): void;
    rendersTheStartWindowWithOneRightEllipsis(): void;
    rendersTheEndWindowWithOneLeftEllipsis(): void;
    siblingCountZeroOnlyKeepsTheCurrentPageBetweenEllipses(): void;
    siblingCountTwoKeepsTwoPagesOnEachSideOfTheCurrentPage(): void;
    currentPageUsesSelectedStylingAndPreviousIsDisabledAtTheStart(): void;
    nextIsDisabledAtTheEndWhilePreviousRemainsInteractive(): void;
    suppliedChildrenReplaceTheDefaultLayout(): void;
    explicitListChildrenReplaceAutomaticallyComputedItems(): void;
    pageWindowStaysInAscendingVisualOrderAcrossConsecutivePageChanges(): void;
    windowedPaginationRendersTheSameTotalItemCountAtEveryPage(): void;
}
export = PaginationMountValidation;
