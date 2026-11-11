declare class TextShrinkToFit {
    shrinksIntoSlot(kind: string): void;
    respectsSlotPadding(): void;
    stopsAtMinScale(): void;
    minScaleClamped(): void;
    neverScalesUp(): void;
    recoversWhenWidened(): void;
    shrinksIntoMaxWidth(): void;
    quietUnmount(kind: string): void;
}
export = TextShrinkToFit;
