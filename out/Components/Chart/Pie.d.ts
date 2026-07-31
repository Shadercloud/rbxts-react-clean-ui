import React from "@rbxts/react";
import { ScaleSize } from "../../Interfaces";
type PieLabel = {
    text?: string;
    spacing?: ScaleSize | "None";
    content?: React.ReactNode;
    BackgroundColor3?: Color3;
    BorderColor3?: Color3;
};
type PieValue = {
    value: number;
    color?: Color3;
    label?: string | PieLabel;
};
interface PieProps {
    key?: string;
    values: PieValue[];
    ['label-distance']?: number;
    ['label-hover']?: boolean;
    ['Label-hidden']?: boolean;
    ['label-spacing']?: ScaleSize | "None";
    ['hover-darken']?: number;
    onChangeSelected?: (index: number, value?: PieValue) => void;
    onClick?: (index: number, value: PieValue) => void;
}
export declare function Pie(props: PieProps): React.JSX.Element;
export {};
