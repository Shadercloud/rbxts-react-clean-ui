import { ThemeTemplate } from "./theme.template";
export type DeepPartial<T> = {
    [K in keyof T]?: T[K] extends object ? DeepPartial<T[K]> : T[K];
};
export declare function createTheme(overrides?: DeepPartial<ThemeTemplate>): ThemeTemplate;
export declare function extendTheme(baseTheme: ThemeTemplate, overrides: DeepPartial<ThemeTemplate>): ThemeTemplate;
