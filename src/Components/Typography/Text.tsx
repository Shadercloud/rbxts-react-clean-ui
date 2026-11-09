import React from "@rbxts/react";
import { CleanThemeContext } from "../../Contexts";
import { SizeHelper, TypographyHelper } from "../../Helpers";
import { TypographyOutline, TypographyStyle } from "../../Theme";
import { SizeElementProps, TextVariant } from "../../Interfaces/";

interface TextProps extends React.InstanceProps<TextLabel>, Pick<SizeElementProps, "minWidth" | "maxWidth" | "minHeight" | "maxHeight"> {
    text: string;
    variant?: TextVariant;
    typography?: TypographyStyle;
    weight?: Enum.FontWeight | "bold";
    align?: "Left" | "Right" | "Center";
    TextWrap?: boolean
    letterSpacing?: number;
    name?: string;
    outline?: TypographyOutline | boolean;
    shrinkToFit?: boolean;
    shrinkMinScale?: number;
    minTextSize?: number;
    maxTextSize?: number;
}

const SHRINK_SEARCH_STEPS = 24;
const SHRINK_FILL_TOLERANCE = 0.5;
const SHRINK_SCALE_PRECISION = 0.001;

function getContentWidth(parent: GuiBase2d): number {
    const width = parent.AbsoluteSize.X;
    const padding = parent.FindFirstChildWhichIsA("UIPadding");

    if (padding === undefined)
        return width;

    return width
        - padding.PaddingLeft.Scale * width - padding.PaddingLeft.Offset
        - padding.PaddingRight.Scale * width - padding.PaddingRight.Offset;
}

export const Text = React.forwardRef<TextLabel, TextProps>(
    (props, ref) => {
        const theme = React.useContext(CleanThemeContext);


        const style = props.typography ?? theme.typography[props.variant ?? "body"]

        const weight =
            props.weight === "bold"
                ? Enum.FontWeight.Bold
                : props.weight ?? style.weight ?? Enum.FontWeight.Regular;

        const textwrapped = props.TextWrap !== false && props.TextWrapped !== false;

        const letterSpacing = props.letterSpacing ?? style.letterSpacing;
        const letterSpaced = letterSpacing !== undefined && letterSpacing !== 0 && props.text !== "";

        const rootRef = React.useRef<GuiObject>();
        const [shrinkScale, setShrinkScale] = React.useBinding(1);

        const setLabel = React.useCallback(
            (instance: TextLabel | undefined) => {
                rootRef.current = instance;

                if (typeIs(ref, "function")) {
                    ref(instance);
                } else if (ref !== undefined) {
                    (ref as React.MutableRefObject<TextLabel | undefined>).current = instance;
                }
            },
            [ref],
        );

        const setFrame = React.useCallback((instance: Frame | undefined) => {
            rootRef.current = instance;
        }, []);

        const shrinkToFit = props.shrinkToFit === true;
        const shrinkMinScale = math.clamp(props.shrinkMinScale ?? 0, 0, 1);
        const shrinkWidth = shrinkToFit && props.maxWidth !== undefined ? SizeHelper.toUDim(props.maxWidth).Offset : undefined;

        React.useEffect(() => {
            const root = rootRef.current;

            if (!shrinkToFit || root === undefined) {
                setShrinkScale(1);
                return;
            }

            let parentConnection: RBXScriptConnection | undefined;
            let searching = false;
            let settledAvailable: number | undefined;
            let settledScale: number | undefined;
            let settledWidth: number | undefined;

            const update = () => {
                if (searching)
                    return;

                const parent = root.Parent;
                const available = shrinkWidth ?? (parent !== undefined && parent.IsA("GuiBase2d") ? getContentWidth(parent) : undefined);
                let scale = shrinkScale.getValue();
                let width = root.AbsoluteSize.X;

                if (width <= 0 || available === undefined || available <= 0)
                    return;

                if (available === settledAvailable && scale === settledScale && width === settledWidth)
                    return;

                searching = true;

                let fitScale: number | undefined;
                let overflowScale: number | undefined;

                for (let step = 0; step < SHRINK_SEARCH_STEPS; step++) {
                    const fits = width <= available;

                    if (fits) {
                        fitScale = fitScale === undefined ? scale : math.max(fitScale, scale);

                        if (scale >= 1 || available - width <= SHRINK_FILL_TOLERANCE)
                            break;
                    } else {
                        overflowScale = overflowScale === undefined ? scale : math.min(overflowScale, scale);

                        if (scale <= shrinkMinScale)
                            break;
                    }

                    let nextScale = width > 0 ? math.clamp(scale * available / width, shrinkMinScale, 1) : 1;
                    const low = fitScale ?? shrinkMinScale;
                    const high = overflowScale ?? 1;

                    if ((fitScale !== undefined && nextScale <= fitScale) || (overflowScale !== undefined && nextScale >= overflowScale))
                        nextScale = (low + high) / 2;

                    if (fitScale !== undefined && overflowScale !== undefined && overflowScale - fitScale <= SHRINK_SCALE_PRECISION)
                        break;

                    if (math.abs(nextScale - scale) <= SHRINK_SCALE_PRECISION / 10)
                        break;

                    scale = nextScale;
                    setShrinkScale(scale);
                    width = root.AbsoluteSize.X;
                }

                if (width > available && fitScale !== undefined && fitScale !== scale) {
                    scale = fitScale;
                    setShrinkScale(scale);
                    width = root.AbsoluteSize.X;
                }

                settledAvailable = available;
                settledScale = scale;
                settledWidth = width;
                searching = false;
            };

            const bindParent = () => {
                parentConnection?.Disconnect();
                parentConnection = undefined;

                const parent = root.Parent;
                if (shrinkWidth === undefined && parent !== undefined && parent.IsA("GuiBase2d"))
                    parentConnection = parent.GetPropertyChangedSignal("AbsoluteSize").Connect(update);

                update();
            };

            bindParent();

            const sizeConnection = root.GetPropertyChangedSignal("AbsoluteSize").Connect(update);
            const ancestryConnection = root.AncestryChanged.Connect(bindParent);

            return () => {
                sizeConnection.Disconnect();
                ancestryConnection.Disconnect();
                parentConnection?.Disconnect();
            };
        }, [shrinkToFit, letterSpaced, shrinkWidth, shrinkMinScale]);

        const sizeConstraint = SizeHelper.GetSizeConstraint({
            minWidth: props.minWidth,
            maxWidth: shrinkToFit ? undefined : props.maxWidth,
            minHeight: props.minHeight,
            maxHeight: props.maxHeight,
        });

        const outlineProp = typeIs(props.outline, "table") ? props.outline as TypographyOutline : undefined;
        const hasOutline = props.outline !== false && (props.outline !== undefined || style.outline !== undefined);

        const hasTextSizeConstraint = props.minTextSize !== undefined || props.maxTextSize !== undefined;
        const minTextSize = math.clamp(props.minTextSize ?? 1, 1, 100);
        const maxTextSize = math.clamp(props.maxTextSize ?? 100, minTextSize, 100);

        const renderTextDecorations = () => (
            <>
                {hasOutline && (
                    <uistroke
                        key="Outline"
                        ApplyStrokeMode={Enum.ApplyStrokeMode.Contextual}
                        Color={outlineProp?.color ?? style.outline?.color ?? new Color3(0, 0, 0)}
                        Thickness={outlineProp?.thickness ?? style.outline?.thickness ?? 1}
                        Transparency={outlineProp?.transparency ?? style.outline?.transparency ?? 0}
                    />
                )}
                {hasTextSizeConstraint && (
                    <uitextsizeconstraint
                        key="TextSizeConstraint"
                        MinTextSize={minTextSize}
                        MaxTextSize={maxTextSize}
                    />
                )}
            </>
        );

        const renderBoxDecorations = () => (
            <>
                {sizeConstraint !== undefined && (
                    <uisizeconstraint
                        key="SizeConstraint"
                        MinSize={sizeConstraint.MinSize}
                        MaxSize={sizeConstraint.MaxSize}
                    />
                )}
                {shrinkToFit && (
                    <uiscale
                        key="ShrinkScale"
                        Scale={shrinkScale}
                    />
                )}
            </>
        );

        if (letterSpacing !== undefined && letterSpaced) {
            const characters: string[] = [];
            for (let index = 0; index < props.text.size(); index++) {
                characters.push(props.text.sub(index + 1, index + 1));
            }

            return <frame
                key={props.name ?? "Text"}
                ref={setFrame}
                Size={UDim2.fromScale(0, 0)}
                AutomaticSize={Enum.AutomaticSize.XY}
                AnchorPoint={props.AnchorPoint}
                BackgroundTransparency={1}
                BorderSizePixel={0}
                Position={props.Position}
                ZIndex={props.ZIndex}
                LayoutOrder={props.LayoutOrder}
                Visible={props.Visible}
                Rotation={props.Rotation}
            >
                <uilistlayout
                    key="LetterSpacing"
                    FillDirection={Enum.FillDirection.Horizontal}
                    SortOrder={Enum.SortOrder.LayoutOrder}
                    Padding={new UDim(0, letterSpacing)}
                    VerticalAlignment={Enum.VerticalAlignment.Center}
                    HorizontalAlignment={props.align ?? Enum.HorizontalAlignment.Left}
                />
                {characters.map((character, index) => (
                    <textlabel
                        key={index}
                        LayoutOrder={index}
                        Size={UDim2.fromScale(0, 0)}
                        AutomaticSize={Enum.AutomaticSize.XY}
                        BackgroundTransparency={1}
                        BorderSizePixel={0}
                        TextColor3={props.TextColor3 ?? theme.colors.intents.primary.default.textColor}
                        Text={character}
                        LineHeight={props.LineHeight ?? style.lineHeight}
                        FontFace={TypographyHelper.toFontFace(style.font, weight)}
                        FontSize={style.size}
                        RichText={false}
                        TextScaled={props.TextScaled ?? false}
                        TextStrokeColor3={props.TextStrokeColor3}
                        TextStrokeTransparency={props.TextStrokeTransparency}
                        TextTransparency={props.TextTransparency}
                    >
                        {renderTextDecorations()}
                    </textlabel>
                ))}
                {renderBoxDecorations()}
            </frame>
        }

        return <textlabel
            key={props.name ?? "Text"}
            ref={setLabel}
            Size={props.Size ?? UDim2.fromScale(0, 0)}
            AutomaticSize={props.AutomaticSize ?? Enum.AutomaticSize.XY}
            AnchorPoint={props.AnchorPoint}
            LineHeight={props.LineHeight ?? style.lineHeight}
            BackgroundTransparency={props.BackgroundTransparency ?? 1}
            TextXAlignment={props.align ?? (props.TextXAlignment ?? Enum.TextXAlignment.Left)}
            TextColor3={props.TextColor3 ?? theme.colors.intents.primary.default.textColor}
            Text={props.text}
            Position={props.Position}
            TextWrap={textwrapped}
            TextWrapped={textwrapped}
            FontFace={TypographyHelper.toFontFace(style.font, weight)}
            FontSize={style.size}
            RichText={props.RichText ?? true}
            TextScaled={props.TextScaled ?? false}

            ZIndex={props.ZIndex}
            LayoutOrder={props.LayoutOrder}
            Visible={props.Visible}
            Rotation={props.Rotation}
            Active={props.Active}
            Archivable={props.Archivable}
            BackgroundColor3={props.BackgroundColor3}
            BorderColor3={props.BorderColor3}
            BorderMode={props.BorderMode}
            BorderSizePixel={props.BorderSizePixel === undefined ? 0 : props.BorderSizePixel}
            ClipsDescendants={props.ClipsDescendants}
            Selectable={props.Selectable}
            SelectionImageObject={props.SelectionImageObject}
            SizeConstraint={props.SizeConstraint}
            Tag={props.Tag}
            AutoLocalize={props.AutoLocalize}
            RootLocalizationTable={props.RootLocalizationTable}
            NextSelectionDown={props.NextSelectionDown}
            NextSelectionLeft={props.NextSelectionLeft}
            NextSelectionRight={props.NextSelectionRight}
            NextSelectionUp={props.NextSelectionUp}
            SelectionGroup={props.SelectionGroup}
            SelectionOrder={props.SelectionOrder}

            TextStrokeColor3={props.TextStrokeColor3}
            TextStrokeTransparency={props.TextStrokeTransparency}
            TextTransparency={props.TextTransparency}
            TextTruncate={props.TextTruncate}

            Change={props.Change}
            Event={props.Event} >
            {renderTextDecorations()}
            {renderBoxDecorations()}
            {props.children}
        </textlabel>
    }
);
