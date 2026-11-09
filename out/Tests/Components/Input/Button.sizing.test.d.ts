import { ButtonProps } from "../../../Components/Input/Button";
declare class ButtonSizingValidation {
    widthSizes(width: ButtonProps["width"], expected: number): void;
    widthCentersRow(): void;
    fillSharesEqually(): void;
    autoUnchanged(): void;
}
export = ButtonSizingValidation;
