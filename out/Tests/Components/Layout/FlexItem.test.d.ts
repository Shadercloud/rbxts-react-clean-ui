type FlexAlign = "Left" | "Center" | "Right";
declare class FlexItemMountValidation {
    growsToFillRemaining(): void;
    modeNoneKeepsOwnSize(): void;
    alignPlacesChild(align: FlexAlign): void;
    allContained(): void;
    defaultHorizontalLayout(): void;
    verticalDirection(): void;
    layoutFalseDefersToChild(): void;
}
export = FlexItemMountValidation;
