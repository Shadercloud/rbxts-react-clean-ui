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
            BorderSizePixel={props.BorderSizePixel}
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
            {props.children}
        </textlabel>
    }
);