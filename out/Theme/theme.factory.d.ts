import { CleanTheme } from "./theme.template";
export type DeepPartial<T> = {
    [K in keyof T]?: T[K] extends object ? DeepPartial<T[K]> : T[K];
};
export declare function createTheme(overrides?: DeepPartial<CleanTheme>): CleanTheme;
export declare function extendTheme(baseTheme: CleanTheme, overrides: DeepPartial<CleanTheme>): CleanTheme;
