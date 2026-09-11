declare class ColumnMountValidation {
    fullWidthByDefault(): void;
    spanFraction(span: number | `${number}`, expectedWidth: number): void;
    autoHeightFromContent(): void;
}
export = ColumnMountValidation;
