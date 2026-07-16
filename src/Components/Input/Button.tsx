import React, { Component, ReactComponent } from "@rbxts/react"
import { BackgroundElementProps, IconElementProps, IntentElementProps, ScalableElementProps, ShadowElementProps, SpacedElementProps, TextVariant, ZIndexElementProps } from "../../Interfaces/";
import { CleanThemeContext } from "../../Contexts/";
import { BoxShadow, Corners, Padding } from "../Decorators";
import { Text } from "../Typography";
import { ColorHelper } from "../../Helpers";
import { Icon } from "../Surface";
import { HStack } from "../Layout";
import { TypographyStyle } from "../../Theme";
import { TypographyHelper } from "../../Helpers/typography.helper";

interface ButtonProps extends
    SpacedElementProps,
    ShadowElementProps,
    ZIndexElementProps,
    BackgroundElementProps,
    IntentElementProps,
    ScalableElementProps,
    IconElementProps {
    text?: string;
    fontWeight?: Enum.FontWeight;
}

interface ButtonState {
    hover: boolean;
}

@ReactComponent
export class Button extends Component<ButtonProps, ButtonState> {
    static contextType = CleanThemeContext;

    declare context: React.ContextType<typeof CleanThemeContext>
    render() {

        return <imagebutton
            Event={{
                MouseEnter: () => {
                    this.setState({
                        hover: true
                    })
                },
                MouseLeave: () => {
                    this.setState({
                        hover: false
                    })
                },
            }}
            Size={UDim2.fromScale(0, 0)}
            AutomaticSize={Enum.AutomaticSize.XY}
            BackgroundTransparency={
                this.props.BackgroundTransparency ??
                this.context.components.button.backgroundTransparency
            }
            BackgroundColor3={ColorHelper.getIntentColor(
                this.context,
                this.props.intent,
                this.state.hover ? "hover" : "background",
                this.context.components.button.intents,
                this.props.BackgroundColor3,
            )}
            AutoButtonColor={false}
            ZIndex={this.props.ZIndex}
        >

            <Corners radius={this.context.components.button.cornerRadius} />

            <uistroke
                Thickness={this.context.components.button.borderThickness}
                BorderStrokePosition={Enum.BorderStrokePosition.Inner}
                Color={ColorHelper.getIntentColor(
                    this.context,
                    this.props.intent,
                    "border",
                    this.context.components.button.intents,
                )}
            />

            <BoxShadow {...this.props} value={this.context.components.button.boxShadow} />
            <Padding {...this.props} />
            {(this.props.icon !== undefined || this.props.text !== undefined) &&
                <HStack valign="Center" spacing={this.props.spacing}>
                    {this.props.icon !== undefined &&
                        <Icon
                            scale={this.props.scale}
                            icon={this.props.icon}
                            color={
                                ColorHelper.getIntentColor(
                                    this.context,
                                    this.props.intent,
                                    "text",
                                    this.context.components.button.intents,
                                    undefined,
                                    this.context.components.button.textColor
                                )

                            } />
                    }
                    {this.props.text !== undefined &&
                        <Text
                            text={this.props.text}
                            typography={TypographyHelper.getTypography(this.context, this.props.scale, this.context.components.button.typography)}
                            TextColor3={
                                ColorHelper.getIntentColor(
                                    this.context,
                                    this.props.intent,
                                    "text",
                                    this.context.components.button.intents,
                                    undefined,
                                    this.context.components.button.textColor
                                )
                            } />
                    }
                </HStack>
            }
            {this.props.children}
        </imagebutton>
    }
}