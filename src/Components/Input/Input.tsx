import React, { useRef, useState } from "@rbxts/react";
import { CleanThemeContext } from "../../Contexts";
import { CssHelper, TypographyHelper } from "../../Helpers";
import { IconName, ScalableElementProps, SpacedElementProps } from "../../Interfaces";
import { TypographyStyle } from "../../Theme";
import { Corners, Padding } from "../Decorator";
import { FieldsetContext, FlexItem, HStack } from "../Layout";
import { Icon } from "../Surface";
import { resolveClampedText, resolveValidatedText } from "./Input.validation";

export interface InputProps extends ScalableElementProps, SpacedElementProps, React.InstanceProps<TextBox> {
    value: string;
    placeholder?: string;
    validation?: "Number" | "String" | "None" | "Int" | "Telephone" | "Alphanumeric" | "Email";
    min?: number;
    max?: number;
    onChange?: (value: string) => void;
    Event?: React.InstanceEvent<TextBox>;
    controlled?: boolean;
    icon?: IconName;
    name?: string;
}

export function Input(props: InputProps) {
    const theme = React.useContext(CleanThemeContext);
    const fieldset = React.useContext(FieldsetContext);

    const labelActivated = fieldset?.labelActivated;

    const ref = useRef<TextBox>();

    const [value, setValue] = useState(props.value);
    const lastValidText = useRef(props.value);

    const typography: TypographyStyle = TypographyHelper.getTypography(
        theme,
        props.scale,
        theme.components.input.typography
    )

    // Roblox's TextBox has no PlaceholderTransparency and shares font/size/weight/lineHeight
    // between Text and PlaceholderText, so only `.color` from this resolution is actually used below.
    const placeholderTypography: TypographyStyle = TypographyHelper.getTypography(
        theme,
        props.scale,
        theme.components.input.placeholder
    )

    const backgroundImage = CssHelper.resolveBackgroundImage(theme.components.input.backgroundImage);

    React.useEffect(() => {
        if (!labelActivated) {
            return;
        }

        const connection = labelActivated.Event.Connect(() => {
            ref.current?.CaptureFocus();
        });

        return () => connection.Disconnect();
    }, [
        labelActivated,
        ref
    ]);

    return (
        <imagelabel
            key={props.name ?? "Input"}
            Size={props.Size ?? UDim2.fromScale(1, 0)}
            AutomaticSize={Enum.AutomaticSize.Y}
            BackgroundTransparency={1}
            AnchorPoint={props.AnchorPoint}
            Position={props.Position}
            LayoutOrder={props.LayoutOrder}
            Visible={props.Visible}
            ZIndex={props.ZIndex}

            Image={backgroundImage.Image}
            ImageColor3={backgroundImage.ImageColor3}
            ImageTransparency={backgroundImage.ImageTransparency}
            ScaleType={backgroundImage.ScaleType}
            SliceCenter={backgroundImage.SliceCenter}
            SliceScale={backgroundImage.SliceScale}
            TileSize={backgroundImage.TileSize}
        >
            <uistroke
                key="Stroke"
                Thickness={theme.components.input.borderThickness}
                BorderStrokePosition={Enum.BorderStrokePosition.Inner}
                Color={theme.components.input.borderColor}
            />

            <Corners radius={theme.components.input.cornerRadius} />
            <Padding {...props} />
            <HStack valign="Center" Wraps={false}>
                {props.icon !== undefined && (
                    <Icon name="InputIcon" icon={props.icon} color={theme.components.input.iconColor} />
                )}
                <FlexItem>
                    <textbox
                        key="TextBox"
                        ref={ref}
                        Size={UDim2.fromScale(1, 0)}
                        BackgroundTransparency={1}
                        AutomaticSize={Enum.AutomaticSize.Y}
                        TextXAlignment={props.TextXAlignment ?? Enum.TextXAlignment.Left}
                        FontFace={Font.fromName(typography.font.Name, typography.weight ?? Enum.FontWeight.Regular)}
                        FontSize={typography.size}
                        PlaceholderText={props.PlaceholderText ?? props.placeholder}
                        PlaceholderColor3={props.PlaceholderColor3 ?? placeholderTypography.color}
                        TextScaled={props.TextScaled}
                        LineHeight={typography.lineHeight}
                        Text={props.controlled ? props.value : value}
                        TextColor3={props.TextColor3 ?? typography.color ?? theme.colors.intents.primary.default.textColor}
                        TextTransparency={props.TextTransparency ?? typography.transparency}

                        Active={props.Active}
                        Archivable={props.Archivable}
                        BorderColor3={props.BorderColor3}
                        BorderMode={props.BorderMode}
                        BorderSizePixel={props.BorderSizePixel}
                        ClipsDescendants={props.ClipsDescendants}
                        Rotation={props.Rotation}
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

                        ClearTextOnFocus={props.ClearTextOnFocus ?? false}
                        CursorPosition={props.CursorPosition}
                        MultiLine={props.MultiLine}
                        SelectionStart={props.SelectionStart}
                        ShowNativeInput={props.ShowNativeInput}
                        TextEditable={props.TextEditable}
                        TextTruncate={props.TextTruncate}
                        RichText={props.RichText}

                        Event={{
                            ...props.Event,
                            FocusLost: (rbx, enterPressed, inputThatCausedFocusLoss) => {

                                const clampedText = resolveClampedText(props.validation, rbx.Text, props.min, props.max);

                                if (clampedText !== undefined) {
                                    ref.current!.Text = clampedText;
                                    lastValidText.current = clampedText;
                                    setValue(clampedText);
                                    props.onChange?.(clampedText);
                                }

                                props.Event?.FocusLost?.(rbx, enterPressed, inputThatCausedFocusLoss);
                            },
                        }}
                        Change={{
                            ...props.Change,
                            Text: (rbx) => {

                                const resolved = resolveValidatedText(props.validation, rbx.Text, lastValidText.current);

                                if (resolved !== rbx.Text) {
                                    ref.current!.Text = resolved;
                                    return;
                                }

                                lastValidText.current = rbx.Text;
                                setValue(rbx.Text)
                                props.onChange?.(rbx.Text)

                                props.Change?.Text?.(rbx);
                            },
                        }}
                    >

                    </textbox>
                </FlexItem>
            </HStack>
        </imagelabel>
    );
}