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
    letterSpacing?: number;
    name?: string;
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

        // Roblox text instances have no native letter-spacing property, so a nonzero
        // value is faked by splitting the text into one TextLabel per character laid
        // out in a UIListLayout row with the spacing as its Padding. This only makes
        // sense for short, single-line, plain text: RichText is forced off per-character
        // (markup tags can't survive being split apart), and wrapping/truncation are
        // moot since each character label auto-sizes to itself and never overflows.
        if (letterSpacing !== undefined && letterSpacing !== 0 && props.text !== "") {
            const characters: string[] = [];
            for (let index = 0; index < props.text.size(); index++) {
                characters.push(props.text.sub(index + 1, index + 1));
            }

            return <frame
                key={props.name ?? "Text"}
                Size={UDim2.fromScale(0, 0)}
                AutomaticSize={Enum.AutomaticSize.XY}
                AnchorPoint={props.AnchorPoint}
                BackgroundTransparency={1}
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
                        TextColor3={props.TextColor3 ?? theme.colors.intents.primary.default.textColor}
                        Text={character}
                        LineHeight={props.LineHeight ?? style.lineHeight}
                        FontFace={Font.fromName(style.font.Name, weight)}
                        FontSize={style.size}
                        RichText={false}
                        TextScaled={props.TextScaled ?? false}
                        TextStrokeColor3={props.TextStrokeColor3}
                        TextStrokeTransparency={props.TextStrokeTransparency}
                        TextTransparency={props.TextTransparency}
                    />
                ))}
            </frame>
        }

        return <textlabel
            key={props.name ?? "Text"}
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