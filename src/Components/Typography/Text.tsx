import React from "@rbxts/react";
import { CleanThemeContext } from "../../Contexts";
import { TypographyStyle } from "../../Theme";
import { TextVariant } from "../../Interfaces/";

interface TextProps extends React.InstanceProps<TextLabel> {
    text: string;
    variant?: TextVariant;
    typography?: TypographyStyle;
    weight?: Enum.FontWeight | "bold";
    align?: "Left" | "Right" | "Center";
    TextWrap?: boolean
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

        return <textlabel
            ref={ref}
            Size={UDim2.fromScale(0, 0)}
            AutomaticSize={Enum.AutomaticSize.XY}
            AnchorPoint={props.AnchorPoint}
            LineHeight={props.LineHeight ?? style.lineHeight}
            BackgroundTransparency={props.BackgroundTransparency ?? 1}
            TextXAlignment={props.align ?? (props.TextXAlignment ?? Enum.TextXAlignment.Left)}
            TextColor3={props.TextColor3 ?? theme.colors.intents.primary.default.textColor}
            Text={props.text}
            Position={props.Position}
            TextWrap={textwrapped}
            TextWrapped={textwrapped}
            FontFace={Font.fromName(style.font.Name, weight)}
            FontSize={style.size}
            RichText
            Event={props.Event}
            TextScaled={false} >
            {props.children}
        </textlabel>
    }
);