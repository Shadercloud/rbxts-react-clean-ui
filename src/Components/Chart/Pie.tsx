import React, { useState } from "@rbxts/react";
import { GuiService } from "@rbxts/services";
import { BoxShadow, Corners, Padding } from "../Decorator";
import { CleanThemeContext } from "../../Contexts";
import { Text } from "../Typography";
import { CssHelper, SpacingHelper, TypographyHelper } from "../../Helpers";
import { ScaleSize } from "../../Interfaces";

type PieLabel = {
    text?: string;
    spacing?: ScaleSize | "None";
    content?: React.ReactNode;
    BackgroundColor3?: Color3;
    BorderColor3?: Color3;
}

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

type Section = "Top" | "Bottom" | "Left" | "Right";

function Segment(props: { section: Section; color: Color3; fill: number }) {
    const sizeX = props.section === "Left" || props.section === "Right" ? 0.5 : 1;
    const sizeY = props.section === "Left" || props.section === "Right" ? 1 : 0.5;
    let anchor = new Vector2(1, 0.5);
    let zeroed = 0;
    if (props.section === "Right") {
        zeroed = 180;
        anchor = new Vector2(0, 0.5);
    } else if (props.section === "Top") {
        zeroed = 90;
        anchor = new Vector2(0.5, 1);
    } else if (props.section === "Bottom") {
        zeroed = 270;
        anchor = new Vector2(0.5, 0);
    }

    return (
        <frame
            Size={UDim2.fromScale(sizeX, sizeY)}
            AnchorPoint={anchor}
            Position={UDim2.fromScale(0.5, 0.5)}
            ClipsDescendants
            BorderSizePixel={0}
            BackgroundTransparency={1}
            BackgroundColor3={Color3.fromHex("#FFFFFF")}
        >
            <frame
                BackgroundColor3={props.color}
                Size={UDim2.fromScale(sizeX === 1 ? 1 : 2, sizeY === 1 ? 1 : 2)}
                AnchorPoint={new Vector2(0.5, 0.5)}
                BorderSizePixel={0}
                Position={UDim2.fromScale(anchor.X, anchor.Y)}
            >
                <uicorner CornerRadius={new UDim(0.5, 0)} />
                <uigradient
                    Transparency={
                        new NumberSequence([
                            new NumberSequenceKeypoint(0, 1),
                            new NumberSequenceKeypoint(0.4999, 1),
                            new NumberSequenceKeypoint(0.5, 0),
                            new NumberSequenceKeypoint(1, 0),
                        ])
                    }
                    Rotation={zeroed + props.fill * 180}
                />
            </frame>

        </frame>
    );
}

function getCirclePosition(normalized: number, radius: number = 0.3): UDim2 {
    const centerX = 0.5;
    const centerY = 0.5;

    // Convert 0 → 1 into radians (0 → 2π)
    const angle = normalized * math.pi * 2 + math.pi;

    const x = centerX + math.cos(angle) * radius;
    const y = centerY + math.sin(angle) * radius;

    return UDim2.fromScale(x, y);
}

export function Pie(props: PieProps) {
    const theme = React.useContext(CleanThemeContext);

    const [state, setState] = useState({
        hover: -1
    });

    const changeHover = (index: number): void => {
        if (state.hover === index) return
        setState({ hover: index })
        props.onChangeSelected?.(index, index >= 0 ? props.values[index] : undefined)
    }

    const segments: React.Element[] = [];
    const labels: React.Element[] = [];
    const totalValue = props.values.reduce((sum, obj) => sum + obj.value, 0);
    let section: Section = "Top";
    let sectionRemaining: number = 1;
    let totalPercent = 0
    props.values.forEach((v: PieValue, index: number) => {
        const percent = v.value / totalValue;

        totalPercent += (percent / 2)

        const fill = percent * 2;
        let color = v.color ?? theme.components.pie.colors[index % theme.components.pie.colors.size()]
        if (index === state.hover) {
            const d = props['hover-darken'] ?? 0.2
            color = color.Lerp((d < 0 ? new Color3(1, 1, 1) : new Color3(0, 0, 0)), math.abs(d))
        }

        segments.push(<Segment section={section} color={color} fill={-sectionRemaining} />);
        sectionRemaining -= fill;
        if (sectionRemaining <= 0) {
            section = "Bottom";
            if (sectionRemaining < 0)
                segments.push(<Segment section={section} color={color} fill={-sectionRemaining} />);
            sectionRemaining = 1 + sectionRemaining;
        }
        if (!props["Label-hidden"] && v.label && (!props["label-hover"] || state.hover === index)) {
            const label = v.label;
            const isTextLabel = typeIs(label, "string") || label.text !== undefined;

            const position =
                props.values.size() === 1
                    ? UDim2.fromScale(0.5, 0.5)
                    : getCirclePosition(totalPercent, props["label-distance"]);

            if (isTextLabel) {
                const text = typeIs(label, "string") ? label : (label.text as string);
                const spacing = typeIs(label, "string") ? props["label-spacing"] : label.spacing;
                const background = !typeIs(label, "string") && label.BackgroundColor3 !== undefined ? label.BackgroundColor3 :
                    theme.components.pie.labels.backgroundColor ?? theme.components.box.backgroundColor;
                const border = !typeIs(label, "string") && label.BorderColor3 !== undefined ? label.BorderColor3 :
                    theme.components.pie.labels.borderColor ?? theme.components.box.borderColor;

                labels.push(
                    <frame
                        Size={UDim2.fromScale(0, 0)}
                        AutomaticSize={Enum.AutomaticSize.XY}
                        AnchorPoint={new Vector2(0.5, 0.5)}
                        Position={position}
                        BackgroundColor3={background}
                        BackgroundTransparency={
                            theme.components.pie.labels.backgroundTransparency ??
                            theme.components.box.backgroundTransparency
                        }
                    >
                        <Text
                            text={text}
                            typography={TypographyHelper.getTypography(
                                theme,
                                "md",
                                theme.components.pie.labels.typography,
                            )}
                        />

                        <Corners
                            radius={
                                theme.components.pie.labels.cornerRadius ??
                                theme.components.box.cornerRadius
                            }
                        />

                        <uistroke
                            Thickness={
                                theme.components.pie.labels.borderThickness ??
                                theme.components.box.borderThickness
                            }
                            BorderStrokePosition={Enum.BorderStrokePosition.Inner}
                            Color={border}
                        />

                        <Padding
                            resolvedPadding={SpacingHelper.ResolveNumberPadding(
                                SpacingHelper.GetPadding(
                                    theme,
                                    spacing,
                                    theme.components.pie.labels.spacing,
                                ),
                            )}
                        />

                        <BoxShadow />
                    </frame>,
                );
            } else if (label.content !== undefined) {
                labels.push(
                    <frame
                        Size={UDim2.fromScale(0, 0)}
                        AutomaticSize={Enum.AutomaticSize.XY}
                        AnchorPoint={new Vector2(0.5, 0.5)}
                        Position={position}
                        BackgroundTransparency={1}
                    >
                        {label.content}
                    </frame>,
                );
            }
        }
        totalPercent += (percent / 2)

    });

    let shadowPadding: React.ReactElement | undefined;
    if (theme.components.pie.boxShadow !== undefined) {
        const shadowParsed = CssHelper.parseCssShadow(theme.components.pie.boxShadow.shadow);
        if (shadowParsed !== undefined) {
            const shadowValue = shadowParsed.spread.X.Offset + shadowParsed.blurRadius.Offset;
            if (shadowValue > 0) {
                const resolvedPadding = SpacingHelper.ResolveNumberPadding(shadowValue);
                resolvedPadding.left = math.max(0, resolvedPadding.left - shadowParsed.offset.X.Offset);
                resolvedPadding.right += shadowParsed.offset.X.Offset;
                resolvedPadding.top = math.max(0, resolvedPadding.top - shadowParsed.offset.Y.Offset);
                resolvedPadding.bottom += shadowParsed.offset.Y.Offset;

                shadowPadding = <Padding resolvedPadding={resolvedPadding} />
            }
        }
    }

    return (
        <canvasgroup
            BackgroundTransparency={1}
            Size={UDim2.fromScale(1, 1)}
        >
            {shadowPadding}
            <frame
                BackgroundTransparency={1}
                Size={UDim2.fromScale(1, 1)}
                Event={{
                    MouseLeave: () => {
                        changeHover(-1)
                    },
                    InputEnded: (rbx: Frame, input: InputObject): void => {
                        if (input.UserInputType !== Enum.UserInputType.MouseButton1) return
                        if (state.hover < 0) return

                        props.onClick?.(state.hover, props.values[state.hover])
                    },
                    MouseMoved: (rbx: Frame, x: number, y: number): void => {
                        const [offset] = GuiService.GetGuiInset()
                        const localX = x - rbx.AbsolutePosition.X;
                        const localY = y - rbx.AbsolutePosition.Y - offset.Y;

                        const width = rbx.AbsoluteSize.X;
                        const height = rbx.AbsoluteSize.Y;

                        const centerX = width / 2;
                        const centerY = height / 2;

                        const dx = localX - centerX;
                        const dy = localY - centerY;

                        const radius = math.min(width, height) / 2;

                        const distance = math.sqrt(dx * dx + dy * dy);

                        if (distance > radius) {
                            changeHover(-1)
                            return;
                        }

                        let angle = math.atan2(dy, dx); // -π → π

                        if (angle < 0) {
                            angle += math.pi * 2;
                        }

                        let normalized = angle / (math.pi * 2);
                        normalized = (normalized + 0.5) % 1;

                        let running = 0;


                        for (let i = 0; i < props.values.size(); i++) {
                            const percent = props.values[i].value / totalValue;

                            if (normalized >= running && normalized <= running + percent) {
                                changeHover(i)
                                return;
                            }

                            running += percent;
                        }

                        changeHover(-1)
                    }
                }}
            >
                {segments}
                {labels}

                {theme.components.pie.boxShadow !== undefined &&
                    <BoxShadow completeShadow={theme.components.pie.boxShadow} />
                }
                <uicorner CornerRadius={new UDim(1, 0)} />
            </frame>
        </canvasgroup>
    );
}
