import React from "@rbxts/react";
export interface PreferredTextSizePinProps {
    size: Enum.FontSize;
    scaled?: boolean | React.Binding<boolean>;
    minTextSize?: number;
    maxTextSize?: number;
    shrinkScale?: React.Binding<number>;
}
export declare function usePinsPreferredTextSize(scaled: boolean | React.Binding<boolean> | undefined): boolean;
export declare function usePreferredTextSizePin(size: Enum.FontSize, scaled: boolean | React.Binding<boolean> | undefined, minTextSize?: number, maxTextSize?: number): number | undefined;
export declare function PreferredTextSizePin(props: PreferredTextSizePinProps): React.JSX.Element | undefined;
