declare class GamepadHelperChecks {
    gamepadTypes(name: string): void;
    otherTypes(name: string): void;
    missingIsOutside(): void;
    scopeAndDescendants(): void;
    siblingsAndAncestorsOutside(): void;
    trySetSwallowsErrors(): void;
}
export = GamepadHelperChecks;
