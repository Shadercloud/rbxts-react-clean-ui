import React, { useRef, useState } from "@rbxts/react";
import { CleanThemeContext } from "../../Contexts";
import { TypographyHelper } from "../../Helpers";
import { ScalableElementProps, SpacedElementProps } from "../../Interfaces";
import { TypographyStyle } from "../../Theme";
import { Corners, Padding } from "../Decorator";
import { FieldsetContext } from "../Layout";

interface InputProps extends ScalableElementProps, SpacedElementProps, React.InstanceProps<TextBox> {
    value: string;
    placeholder?: string;
    validation?: "Number" | "String" | "None" | "Int" | "Telephone" | "Alphanumeric" | "Email";
    min?: number;
    max?: number;
    onChange?: (value: string) => void;
    Event?: React.InstanceEvent<TextBox>;
    controlled?: boolean;
}

const CHARACTER_ALLOW_LIST_PATTERNS: Partial<Record<NonNullable<InputProps["validation"]>, string>> = {
    Telephone: "^[%d%+%-%s%(%)]*$",
    Alphanumeric: "^[%w]*$",
    Email: "^[%w@%._%-+]*$",
};

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
        <frame
            Size={UDim2.fromScale(1, 0)}
            AutomaticSize={Enum.AutomaticSize.Y}
            BackgroundTransparency={1}
            AnchorPoint={props.AnchorPoint}
            Position={props.Position}
            LayoutOrder={props.LayoutOrder}
            Visible={props.Visible}
            ZIndex={props.ZIndex}
        >
            <uistroke
                Thickness={theme.components.input.borderThickness}
                BorderStrokePosition={Enum.BorderStrokePosition.Inner}
                Color={theme.components.input.borderColor}
            />

            <Corners radius={theme.components.input.cornerRadius} />
            <Padding {...props} />
            <textbox
                ref={ref}
                Size={UDim2.fromScale(1, 0)}
                BackgroundTransparency={1}
                AutomaticSize={Enum.AutomaticSize.Y}
                TextXAlignment={props.TextXAlignment ?? Enum.TextXAlignment.Left}
                FontFace={Font.fromName(typography.font.Name, typography.weight ?? Enum.FontWeight.Regular)}
                FontSize={typography.size}
                PlaceholderText={props.PlaceholderText ?? props.placeholder}
                PlaceholderColor3={props.PlaceholderColor3}
                TextScaled={props.TextScaled}
                LineHeight={typography.lineHeight}
                Text={props.controlled ? props.value : value}
                TextColor3={props.TextColor3 ?? theme.colors.intents.primary.default.textColor}

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

                        if (props.validation === "Number" || props.validation === "Int") {
                            const number = tonumber(rbx.Text);

                            if (number !== undefined) {
                                let clamped = number;

                                if (props.min !== undefined && clamped < props.min) {
                                    clamped = props.min;
                                }

                                if (props.max !== undefined && clamped > props.max) {
                                    clamped = props.max;
                                }

                                if (clamped !== number) {
                                    const clampedText = tostring(clamped);

                                    ref.current!.Text = clampedText;
                                    lastValidText.current = clampedText;
                                    setValue(clampedText);
                                    props.onChange?.(clampedText);
                                }
                            }
                        }

                        props.Event?.FocusLost?.(rbx, enterPressed, inputThatCausedFocusLoss);
                    },
                }}
                Change={{
                    ...props.Change,
                    Text: (rbx) => {

                        const number = tonumber(rbx.Text);

                        if (
                            (props.validation === "Number" || props.validation === "Int") &&
                            number === undefined &&
                            rbx.Text !== "" &&
                            rbx.Text !== "-"
                        ) {
                            ref.current!.Text = lastValidText.current;
                            return;
                        }

                        const allowedPattern = CHARACTER_ALLOW_LIST_PATTERNS[props.validation ?? "None"];

                        if (allowedPattern !== undefined && rbx.Text.match(allowedPattern)[0] === undefined) {
                            ref.current!.Text = lastValidText.current;
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
        </frame>
    );
}