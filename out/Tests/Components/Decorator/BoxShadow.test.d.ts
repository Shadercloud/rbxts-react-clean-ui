import { CssShadow } from "../../../Interfaces/";
declare class BoxShadowMountValidation {
    cssValueShadow(): void;
    completeShadow(): void;
    zeroShadowEmitsNothing(value: CssShadow): void;
    noValueEmitsNothing(): void;
}
export = BoxShadowMountValidation;
