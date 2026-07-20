import React, { Component, ReactComponent } from "@rbxts/react";
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
@ReactComponent
export class Text extends Component<TextProps> {
    static contextType = CleanThemeContext;

    declare context: React.ContextType<typeof CleanThemeContext>;

    render(): React.ReactNode {
        const style = this.props.typography ?? this.context.typography[this.props.variant ?? "body"]

        const weight =
            this.props.weight === "bold"
                ? Enum.FontWeight.Bold
                : this.props.weight ?? style.weight ?? Enum.FontWeight.Regular;

        return <textlabel
            Size={UDim2.fromScale(0, 0)}
            AutomaticSize={Enum.AutomaticSize.XY}
            LineHeight={style.lineHeight}
            BackgroundTransparency={1}
            TextXAlignment={this.props.align ?? (this.props.TextXAlignment ?? Enum.TextXAlignment.Left)}
            TextColor3={this.props.TextColor3 ?? this.context.colors.intents.primary.text}
            Text={this.props.text}
            TextWrap={this.props.TextWrap === undefined || this.props.TextWrap === true}
            FontFace={Font.fromName(style.font.Name, weight)}
            FontSize={style.size}
            RichText
            TextScaled={false} >
            {this.props.children}
        </textlabel>
    }
}