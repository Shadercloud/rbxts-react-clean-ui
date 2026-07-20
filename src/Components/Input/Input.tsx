import React, { useRef, useState } from "@rbxts/react";
import { CleanThemeContext } from "../../Contexts";
import { TypographyHelper } from "../../Helpers";
import { ScalableElementProps, SpacedElementProps } from "../../Interfaces";
import { TypographyStyle } from "../../Theme";
import { Corners, Padding } from "../Decorator";

interface InputProps extends ScalableElementProps, SpacedElementProps, React.InstanceProps<TextBox> {
    value: string;
    placeholder?: string;
    validation?: "Number" | "String" | "None" | "Int";
    onChange?: (value: string) => void;
    Event?: React.InstanceEvent<TextBox>;
}

export function Input(props: InputProps) {
    const theme = React.useContext(CleanThemeContext);

    const ref = useRef<TextBox>();

    const [value, setValue] = useState(props.value);

    const typography: TypographyStyle = TypographyHelper.getTypography(
        theme,
        props.scale,
        theme.components.input.typography
    )

    return (
        <frame
            Size={UDim2.fromScale(1, 0)}
            AutomaticSize={Enum.AutomaticSize.Y}
            BackgroundTransparency={1}
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
                Text={value}
                TextColor3={props.TextColor3 ?? theme.colors.intents.primary.text}
                ClearTextOnFocus={false}
                Event={props.Event}
                Change={{
                    Text: (rbx) => {
                        if (props.validation === "Number" || props.validation === "Int") {
                            if (!ref.current) return
                            if (!tonumber(rbx.Text) && rbx.Text !== "" && rbx.Text !== "-") {
                                ref.current.Text = props.value
                                return
                            }
                            if (props.validation === "Int" && rbx.Text !== "" && rbx.Text !== "-") {
                                if (math.round(tonumber(rbx.Text) ?? 0) !== tonumber(rbx.Text))
                                    return
                            }
                        }
                        setValue(rbx.Text)
                        props.onChange?.(rbx.Text)
                    },
                }}
            >

            </textbox>
        </frame>
    );
}