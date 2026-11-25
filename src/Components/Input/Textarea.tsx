import React, { useRef, useState } from "@rbxts/react";
import { RunService, TextService } from "@rbxts/services";
import { CleanThemeContext, useUiScale } from "../../Contexts";
import { CssHelper, CustomInputService, ElementHelper, SizeHelper, SpacingHelper, TypographyHelper } from "../../Helpers";
import { CssPixelSize, ScalableElementProps, SizeElementProps, SpacedElementProps } from "../../Interfaces";
import { TypographyStyle } from "../../Theme";
import { Corners, Gradient } from "../Decorator";
import { FieldsetContext, Scroller } from "../Layout";
import { Text } from "../Typography";
import { PreferredTextSizePin } from "../Typography/PinTextSize.preferred";
import { FieldBoxShadow, FieldInnerShadow, resolveFieldState, resolveFieldStateStyle } from "./Input.field";
import {
    TEXTAREA_DEFAULT_ROWS,
    formatTextareaCount,
    resolveTextareaCanvasHeight,
    resolveTextareaCaretScroll,
    resolveTextareaCaretLineText,
    resolveTextareaHeight,
    resolveTextareaLength,
    resolveTextareaScreenScale,
    resolveTextareaWholePixels,
    resolveTextareaWrapWidth,
    trimTextareaText,
} from "./Textarea.layout";

const GAMEPAD_SCROLL_SPEED = 480;
const GAMEPAD_DEADZONE = 0.2;
const DEFAULT_SCROLLBAR_THICKNESS = 12;
const MEASURE_HEIGHT = 100000;
const FALLBACK_LINE_SLACK = 1.17;
const FALLBACK_FRAMES = 3;

export interface TextareaProps
    extends ScalableElementProps,
        SpacedElementProps,
        Omit<SizeElementProps, "Size" | "AutomaticSize" | "height">,
        Omit<React.InstanceProps<TextBox>, "Size" | "AutomaticSize"> {
    value: string;
    placeholder?: string;
    onChange?: (value: string) => void;
    Event?: React.InstanceEvent<TextBox>;
    controlled?: boolean;
    name?: string;
    disabled?: boolean;
    height?: CssPixelSize;
    rows?: number;
    maxLength?: number;
    showCount?: boolean;
}

export const Textarea = React.forwardRef<TextBox, TextareaProps>((props, forwardedRef) => {
    const theme = React.useContext(CleanThemeContext);
    const fieldset = React.useContext(FieldsetContext);
    const uiScale = useUiScale();

    const labelActivated = fieldset?.labelActivated;

    const ref = useRef<TextBox>();
    const fieldRef = useRef<ImageLabel>();
    const scrollerRef = useRef<ScrollingFrame>();
    const probeRef = useRef<TextLabel>();
    const lineProbeRef = useRef<TextLabel>();
    const measureRef = useRef<TextLabel>();
    const followRequested = useRef(false);
    const lastWrittenY = useRef<number>();
    const neverMeasures = useRef(false);
    const pendingFallback = useRef<RBXScriptConnection>();
    const pendingNudge = useRef<RBXScriptConnection>();
    const nudgedSource = useRef<string>();

    const [value, setValue] = useState(props.value);
    const [focused, setFocused] = useState(false);
    const [hovered, setHovered] = useState(false);
    const [textHeight, setTextHeight] = useState(0);
    const [estimated, setEstimated] = useState(false);
    const [screenFieldSize, setScreenFieldSize] = useState(Vector2.zero);
    const [screenTextBoxWidth, setScreenTextBoxWidth] = useState(0);
    const focusedRef = useRef(false);
    const heldText = useRef<string>();
    const reportedTexts = useRef(new Set<string>());

    const sourceText = props.controlled ? props.value : value;
    const displayText = heldText.current ?? sourceText;

    const inputTheme = theme.components.input;
    const textareaTheme = theme.components.textarea;
    const stateStyle = resolveFieldStateStyle(inputTheme.states, resolveFieldState(props.disabled, focused, hovered));
    const borderThickness = stateStyle.borderThickness ?? inputTheme.borderThickness;

    const typography: TypographyStyle = TypographyHelper.getTypography(theme, props.scale, inputTheme.typography);
    const placeholderTypography: TypographyStyle = TypographyHelper.getTypography(theme, props.scale, inputTheme.placeholder);
    const counterTypography: TypographyStyle = TypographyHelper.getTypography(theme, props.scale, textareaTheme?.counter);
    const fontFace = TypographyHelper.toFontFace(typography.font, typography.weight ?? Enum.FontWeight.Regular);
    const lineHeight = (TypographyHelper.toTextSize(typography.size) ?? 14) * (typography.lineHeight ?? 1);

    const backgroundImage = CssHelper.resolveBackgroundImage(inputTheme.backgroundImage);
    const padding = SpacingHelper.GetResolvedPadding(theme, props);

    const scrollerTheme = theme.components.scroller;
    const thickness = math.max(0, scrollerTheme.thickness ?? DEFAULT_SCROLLBAR_THICKNESS);
    const gutter = math.max(0, scrollerTheme.gutter ?? thickness);

    const widthConstraint = SizeHelper.GetSizeConstraint({ minWidth: props.minWidth, maxWidth: props.maxWidth });
    const heightConstraint = SizeHelper.GetSizeConstraint({ minHeight: props.minHeight, maxHeight: props.maxHeight });
    const fieldHeight = resolveTextareaWholePixels(math.clamp(
        resolveTextareaHeight(
            props.height !== undefined ? SizeHelper.toUDim(props.height).Offset : undefined,
            props.rows ?? textareaTheme?.rows ?? TEXTAREA_DEFAULT_ROWS,
            lineHeight,
            padding.top,
            padding.bottom,
        ),
        heightConstraint?.MinSize.Y ?? 0,
        heightConstraint?.MaxSize.Y ?? math.huge,
    ));
    const screenScale = resolveTextareaScreenScale(screenFieldSize.Y, fieldHeight, uiScale);
    const wrapWidth = screenTextBoxWidth > 0
        ? math.round(screenTextBoxWidth / screenScale)
        : resolveTextareaWrapWidth(math.floor(screenFieldSize.X / screenScale), padding.left, padding.right, gutter);
    const canvasHeight = resolveTextareaWholePixels(resolveTextareaCanvasHeight(textHeight, padding.top, padding.bottom, fieldHeight, screenScale));
    const textBoxSize = new UDim2(1, -(padding.left + padding.right), 0, canvasHeight - padding.top + (estimated ? canvasHeight : 0));
    const textBoxSizeRef = useRef(textBoxSize);
    textBoxSizeRef.current = textBoxSize;
    const counterGap = resolveTextareaWholePixels(SpacingHelper.GetPadding(theme, "xs"));
    const counterHeight = resolveTextareaWholePixels((TypographyHelper.toTextSize(counterTypography.size) ?? 14) * (counterTypography.lineHeight ?? 1));
    const rootHeight = fieldHeight + (props.showCount === true ? counterGap + counterHeight : 0);
    const rootWidth = props.width === undefined ? new UDim(1, 0) : (SizeHelper.GetSize({ width: props.width }) as UDim2).X;

    const layout = {
        fieldHeight,
        wrapWidth,
        padding,
        uiScale,
        font: typography.font,
        textSize: TypographyHelper.toTextSize(typography.size) ?? 14,
    };
    const layoutRef = useRef(layout);
    layoutRef.current = layout;

    const currentScale = () => {
        const field = fieldRef.current;

        return resolveTextareaScreenScale(field?.AbsoluteSize.Y ?? 0, layoutRef.current.fieldHeight, layoutRef.current.uiScale);
    };

    const estimateTextHeight = () => {
        const measure = measureRef.current;
        const current = layoutRef.current;

        if (measure === undefined || measure.Text === "" || current.wrapWidth <= 0) {
            return;
        }

        const size = TextService.GetTextSize(measure.Text, current.textSize, current.font, new Vector2(current.wrapWidth, MEASURE_HEIGHT));

        task.defer(() => {
            setTextHeight(size.Y * FALLBACK_LINE_SLACK);
            setEstimated(true);
        });
    };

    const cancelFallback = () => {
        pendingFallback.current?.Disconnect();
        pendingFallback.current = undefined;
    };

    const updateTextHeight = () => {
        const measure = measureRef.current;
        const current = layoutRef.current;

        if (measure === undefined || current.wrapWidth <= 0) {
            return;
        }

        const bounds = measure.TextBounds.Y;

        if (bounds > 0) {
            neverMeasures.current = false;
            cancelFallback();
            setTextHeight(bounds / currentScale());
            setEstimated(false);
            return;
        }

        if (measure.Text === "") {
            cancelFallback();
            setTextHeight(0);
            setEstimated(false);
            return;
        }

        if (neverMeasures.current) {
            estimateTextHeight();
            return;
        }

        if (pendingFallback.current !== undefined) {
            return;
        }

        let frames = 0;

        pendingFallback.current = RunService.Heartbeat.Connect(() => {
            frames += 1;

            if (frames < FALLBACK_FRAMES) {
                return;
            }

            cancelFallback();

            const latest = measureRef.current;

            if (latest === undefined || latest.Text === "") {
                return;
            }

            if (latest.TextBounds.Y > 0) {
                updateTextHeightRef.current();
                return;
            }

            neverMeasures.current = true;
            estimateTextHeightRef.current();
        });
    };

    const updateTextHeightRef = useRef(updateTextHeight);
    updateTextHeightRef.current = updateTextHeight;

    const estimateTextHeightRef = useRef(estimateTextHeight);
    estimateTextHeightRef.current = estimateTextHeight;

    const nudgeTextBox = () => {
        pendingNudge.current?.Disconnect();

        let step = 0;

        pendingNudge.current = RunService.Heartbeat.Connect(() => {
            const textBox = ref.current;

            if (textBox === undefined) {
                pendingNudge.current?.Disconnect();
                pendingNudge.current = undefined;
                return;
            }

            step += 1;

            if (step === 1) {
                const size = textBoxSizeRef.current;

                textBox.Size = new UDim2(size.X, new UDim(size.Y.Scale, size.Y.Offset - 1));
                return;
            }

            textBox.Size = textBoxSizeRef.current;
            pendingNudge.current?.Disconnect();
            pendingNudge.current = undefined;
        });
    };

    const setTextBox = React.useCallback(
        (instance: TextBox | undefined) => {
            ref.current = instance;

            ElementHelper.assignRef(forwardedRef, instance);
        },
        [forwardedRef],
    );

    const scrollToCaret = () => {
        const textBox = ref.current;
        const frame = scrollerRef.current;
        const probe = probeRef.current;
        const lineProbe = lineProbeRef.current;

        if (!followRequested.current || textBox === undefined || frame === undefined || probe === undefined || lineProbe === undefined) {
            return;
        }

        if (!textBox.IsFocused()) {
            followRequested.current = false;
            return;
        }

        const scale = currentScale();
        const current = layoutRef.current;
        const caretLineHeight = lineProbe.TextBounds.Y / scale;
        const caretBounds = probe.TextBounds.Y / scale;

        if (!(caretLineHeight > 0) || !(caretBounds > 0)) {
            return;
        }

        const caretBottom = current.padding.top + caretBounds;
        const caretTop = caretBottom - caretLineHeight;
        const canvasY = frame.CanvasPosition.Y / scale;
        const viewportHeight = frame.AbsoluteWindowSize.Y / scale;
        const target = resolveTextareaCaretScroll(
            caretTop - current.padding.top,
            caretBottom + current.padding.bottom,
            canvasY,
            viewportHeight,
        );

        if (target === canvasY) {
            return;
        }

        const maxScroll = math.max(0, frame.AbsoluteCanvasSize.Y / scale - viewportHeight);
        const screenY = math.min(target, maxScroll) * scale;

        lastWrittenY.current = screenY;
        frame.CanvasPosition = new Vector2(frame.CanvasPosition.X, screenY);
    };

    const followCaret = () => {
        const textBox = ref.current;
        const probe = probeRef.current;

        if (textBox === undefined || probe === undefined || !textBox.IsFocused()) {
            return;
        }

        const caretText = resolveTextareaCaretLineText(textBox.Text, textBox.CursorPosition);

        if (caretText === undefined) {
            return;
        }

        followRequested.current = true;

        if (probe.Text !== caretText) {
            probe.Text = caretText;
        }

        scrollToCaret();
    };

    const scrollToCaretRef = useRef(scrollToCaret);
    scrollToCaretRef.current = scrollToCaret;

    const followCaretRef = useRef(followCaret);
    followCaretRef.current = followCaret;

    const currentScaleRef = useRef(currentScale);
    currentScaleRef.current = currentScale;

    const placeholderText = props.PlaceholderText ?? props.placeholder;

    const measureText = (text: string) => {
        const measure = measureRef.current;

        if (measure === undefined) {
            return;
        }

        measure.Text = text !== "" ? text : ref.current?.PlaceholderText ?? "";
        updateTextHeight();
    };

    React.useEffect(() => {
        measureText(ref.current?.Text ?? displayText);
    }, [placeholderText, wrapWidth, screenScale, typography.size, typography.font, typography.lineHeight]);

    React.useEffect(() => {
        const field = fieldRef.current;

        if (field !== undefined) {
            setScreenFieldSize(field.AbsoluteSize);
        }

        return () => {
            pendingFallback.current?.Disconnect();
            pendingFallback.current = undefined;
            pendingNudge.current?.Disconnect();
            pendingNudge.current = undefined;
        };
    }, []);

    React.useEffect(() => {
        if (!labelActivated) {
            return;
        }

        const connection = labelActivated.Event.Connect(() => {
            if (props.disabled) return;

            ref.current?.CaptureFocus();
        });

        return () => connection.Disconnect();
    }, [
        labelActivated,
        ref,
        props.disabled
    ]);

    React.useEffect(() => {
        if (props.disabled) {
            ref.current?.ReleaseFocus();
        }
    }, [props.disabled]);

    React.useEffect(() => {
        const textBox = ref.current;

        if (focusedRef.current || heldText.current === undefined || textBox === undefined) {
            return;
        }

        if (textBox.Text !== sourceText && reportedTexts.current.has(sourceText)) {
            return;
        }

        heldText.current = undefined;

        if (textBox.Text !== sourceText) {
            textBox.Text = sourceText;
        }
    }, [focused, sourceText]);

    React.useEffect(() => {
        if (focusedRef.current || nudgedSource.current === sourceText) {
            return;
        }

        nudgedSource.current = sourceText;
        nudgeTextBox();
    }, [focused, sourceText]);

    React.useEffect(() => {
        const frame = scrollerRef.current;

        if (frame === undefined) {
            return;
        }

        const connection = frame
            .GetPropertyChangedSignal("AbsoluteCanvasSize")
            .Connect(() => {
                scrollToCaretRef.current();
            });

        return () => connection.Disconnect();
    }, [
        inputTheme.innerShadow === undefined,
        scrollerTheme.trackColor !== undefined,
        (scrollerTheme.thumbBorderThickness ?? 0) > 0,
    ]);

    React.useEffect(() => {
        if (!focused) {
            return;
        }

        let stickY = 0;

        const inputConnection = CustomInputService.InputChanged.Connect((input) => {
            if (input.KeyCode === Enum.KeyCode.Thumbstick2) {
                stickY = input.Position.Y;
            }
        });

        const stepConnection = RunService.Heartbeat.Connect((deltaTime) => {
            const frame = scrollerRef.current;

            if (frame === undefined || math.abs(stickY) < GAMEPAD_DEADZONE) {
                return;
            }

            const maxScroll = math.max(0, frame.AbsoluteCanvasSize.Y - frame.AbsoluteWindowSize.Y);
            const step = stickY * GAMEPAD_SCROLL_SPEED * deltaTime * currentScaleRef.current();
            const scrollY = math.clamp(frame.CanvasPosition.Y - step, 0, maxScroll);

            frame.CanvasPosition = new Vector2(frame.CanvasPosition.X, scrollY);
        });

        return () => {
            inputConnection.Disconnect();
            stepConnection.Disconnect();
        };
    }, [focused]);

    const measureLabel = (key: string, labelRef: React.Ref<TextLabel>, change?: React.InstanceChangeEvent<TextLabel>, text?: string) => (
        <textlabel
            key={key}
            ref={labelRef}
            Size={UDim2.fromOffset(wrapWidth, MEASURE_HEIGHT)}
            BackgroundTransparency={1}
            BorderSizePixel={0}
            TextTransparency={1}
            Active={false}
            Interactable={false}
            Selectable={false}
            AutoLocalize={false}
            TextWrapped={true}
            TextXAlignment={Enum.TextXAlignment.Left}
            TextYAlignment={Enum.TextYAlignment.Top}
            FontFace={fontFace}
            FontSize={typography.size}
            LineHeight={typography.lineHeight}
            RichText={props.RichText}
            Text={text}
            Change={change}
        >
            <PreferredTextSizePin size={typography.size} />
        </textlabel>
    );

    const scroller = (
        <Scroller
            name="Scroller"
            ref={scrollerRef}
            stableGutter={true}
            spacing="None"
            onScroll={(canvasPosition) => {
                const written = lastWrittenY.current;

                lastWrittenY.current = undefined;

                if (written === undefined || math.abs(canvasPosition.Y - written) > 0.5) {
                    followRequested.current = false;
                }
            }}
        >
            <textbutton
                key="Canvas"
                Size={new UDim2(1, 0, 0, canvasHeight)}
                BackgroundTransparency={1}
                BorderSizePixel={0}
                Text=""
                AutoButtonColor={false}
                Selectable={false}
                Event={{
                    Activated: () => {
                        if (!props.disabled) {
                            ref.current?.CaptureFocus();
                        }
                    },
                }}
            >
                <textbox
                    key="TextBox"
                    ref={setTextBox}
                    Position={UDim2.fromOffset(padding.left, padding.top)}
                    Size={textBoxSize}
                    BackgroundTransparency={1}
                    MultiLine={true}
                    TextWrapped={true}
                    ClearTextOnFocus={false}
                    TextXAlignment={Enum.TextXAlignment.Left}
                    TextYAlignment={Enum.TextYAlignment.Top}
                    FontFace={fontFace}
                    FontSize={typography.size}
                    PlaceholderText={placeholderText}
                    PlaceholderColor3={props.PlaceholderColor3 ?? placeholderTypography.color}
                    LineHeight={typography.lineHeight}
                    Text={displayText}
                    TextColor3={props.TextColor3 ?? typography.color ?? theme.colors.intents.primary.default.textColor}
                    TextTransparency={props.TextTransparency ?? typography.transparency}

                    Active={props.Active}
                    Archivable={props.Archivable}
                    BorderColor3={props.BorderColor3}
                    BorderMode={props.BorderMode}
                    BorderSizePixel={props.BorderSizePixel === undefined ? 0 : props.BorderSizePixel}
                    Rotation={props.Rotation}
                    Selectable={props.Selectable}
                    SelectionImageObject={props.SelectionImageObject}
                    Tag={props.Tag}
                    AutoLocalize={props.AutoLocalize}
                    RootLocalizationTable={props.RootLocalizationTable}
                    NextSelectionDown={props.NextSelectionDown}
                    NextSelectionLeft={props.NextSelectionLeft}
                    NextSelectionRight={props.NextSelectionRight}
                    NextSelectionUp={props.NextSelectionUp}
                    SelectionGroup={props.SelectionGroup}
                    SelectionOrder={props.SelectionOrder}

                    CursorPosition={props.CursorPosition}
                    SelectionStart={props.SelectionStart}
                    ShowNativeInput={props.ShowNativeInput}
                    TextEditable={props.disabled ? false : props.TextEditable}
                    Interactable={props.disabled ? false : undefined}
                    RichText={props.RichText}

                    Event={{
                        ...props.Event,
                        Focused: (rbx) => {
                            focusedRef.current = true;
                            heldText.current = displayText;
                            reportedTexts.current.clear();
                            setFocused(true);

                            props.Event?.Focused?.(rbx);
                        },
                        FocusLost: (rbx, enterPressed, inputThatCausedFocusLoss) => {
                            focusedRef.current = false;
                            followRequested.current = false;
                            setFocused(false);

                            props.Event?.FocusLost?.(rbx, enterPressed, inputThatCausedFocusLoss);
                        },
                    }}
                    Change={{
                        ...props.Change,
                        AbsoluteSize: (rbx) => {
                            setScreenTextBoxWidth(rbx.AbsoluteSize.X);

                            props.Change?.AbsoluteSize?.(rbx);
                        },
                        Text: (rbx) => {
                            if (focusedRef.current) {
                                const trimmed = trimTextareaText(rbx.Text, props.maxLength);

                                if (trimmed !== rbx.Text) {
                                    ref.current!.Text = trimmed;
                                    return;
                                }
                            }

                            measureText(rbx.Text);
                            reportedTexts.current.add(rbx.Text);
                            setValue(rbx.Text);
                            props.onChange?.(rbx.Text);
                            followCaretRef.current();

                            props.Change?.Text?.(rbx);
                        },
                        CursorPosition: (rbx) => {
                            followCaretRef.current();

                            props.Change?.CursorPosition?.(rbx);
                        },
                    }}
                >
                    <PreferredTextSizePin size={typography.size} />
                </textbox>
            </textbutton>
        </Scroller>
    );

    const field = (
        <imagelabel
            key="Field"
            ref={fieldRef}
            Size={new UDim2(1, 0, 0, fieldHeight)}
            LayoutOrder={1}
            BackgroundColor3={stateStyle.backgroundColor ?? inputTheme.backgroundColor}
            BackgroundTransparency={stateStyle.backgroundTransparency ?? inputTheme.backgroundTransparency ?? 1}
            BorderSizePixel={0}
            Image={backgroundImage.Image}
            ImageColor3={backgroundImage.ImageColor3}
            ImageTransparency={backgroundImage.ImageTransparency}
            ScaleType={backgroundImage.ScaleType}
            SliceCenter={backgroundImage.SliceCenter}
            SliceScale={backgroundImage.SliceScale}
            TileSize={backgroundImage.TileSize}
            Event={{
                MouseEnter: () => setHovered(true),
                MouseLeave: () => setHovered(false),
            }}
            Change={{
                AbsoluteSize: (rbx) => setScreenFieldSize(rbx.AbsoluteSize),
            }}
        >
            <uistroke
                key="Stroke"
                Thickness={borderThickness}
                BorderStrokePosition={Enum.BorderStrokePosition.Inner}
                Color={stateStyle.borderColor ?? inputTheme.borderColor}
            />

            <Corners radius={inputTheme.cornerRadius} />
            <Gradient value={stateStyle.backgroundGradient ?? inputTheme.backgroundGradient} />
            <FieldBoxShadow value={inputTheme.boxShadow} />
            {inputTheme.innerShadow === undefined ? scroller : (
                <>
                    <FieldInnerShadow value={inputTheme.innerShadow} cornerRadius={inputTheme.cornerRadius} inset={borderThickness} />
                    <frame
                        key="Content"
                        Size={UDim2.fromScale(1, 1)}
                        BackgroundTransparency={1}
                        BorderSizePixel={0}
                        ZIndex={2}
                    >
                        {scroller}
                    </frame>
                </>
            )}
            <frame
                key="Measure"
                Size={UDim2.fromOffset(0, 0)}
                Visible={false}
                BackgroundTransparency={1}
                BorderSizePixel={0}
                Active={false}
                Interactable={false}
            >
                {measureLabel("TextMeasure", measureRef, {
                    TextBounds: () => updateTextHeight(),
                })}
                {measureLabel("CaretProbe", probeRef, {
                    TextBounds: () => scrollToCaretRef.current(),
                })}
                {measureLabel("LineProbe", lineProbeRef, undefined, " ")}
            </frame>
        </imagelabel>
    );

    return (
        <frame
            key={props.name ?? "Textarea"}
            Size={new UDim2(rootWidth, new UDim(0, rootHeight))}
            AnchorPoint={props.AnchorPoint}
            Position={props.Position}
            LayoutOrder={props.LayoutOrder}
            Visible={props.Visible}
            ZIndex={props.ZIndex}
            BackgroundTransparency={1}
            BorderSizePixel={0}
        >
            {widthConstraint !== undefined && (
                <uisizeconstraint
                    key="SizeConstraint"
                    MinSize={widthConstraint.MinSize}
                    MaxSize={widthConstraint.MaxSize}
                />
            )}
            {props.showCount === true && (
                <uilistlayout
                    key="Layout"
                    FillDirection={Enum.FillDirection.Vertical}
                    SortOrder={Enum.SortOrder.LayoutOrder}
                    Padding={new UDim(0, counterGap)}
                />
            )}
            {field}
            {props.showCount === true && (
                <Text
                    name="Counter"
                    text={formatTextareaCount(resolveTextareaLength(value), props.maxLength)}
                    typography={counterTypography}
                    TextColor3={counterTypography.color}
                    TextTransparency={counterTypography.transparency}
                    align="Right"
                    TextWrap={false}
                    RichText={false}
                    Size={new UDim2(1, 0, 0, counterHeight)}
                    AutomaticSize={Enum.AutomaticSize.None}
                    LayoutOrder={2}
                />
            )}
        </frame>
    );
});
