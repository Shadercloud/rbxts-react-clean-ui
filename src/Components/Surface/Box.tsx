import React, { Component, ReactComponent } from "@rbxts/react";
import { BackgroundElementProps, ShadowElementProps, SpacedElementProps, ZIndexElementProps } from "../../Interfaces/";
import { CleanThemeContext } from "../../Contexts/";
import { Padding, Corners, BoxShadow } from "../Decorators";

interface BoxProps extends SpacedElementProps, ShadowElementProps, BackgroundElementProps, ZIndexElementProps { }

@ReactComponent
export class Box extends Component<BoxProps> {
    static contextType = CleanThemeContext;

    declare context: React.ContextType<typeof CleanThemeContext>;
    render() {
        return (
            <frame
                Size={UDim2.fromScale(1, 1)}
                AutomaticSize={Enum.AutomaticSize.Y}
                BackgroundTransparency={
                    this.props.BackgroundTransparency ??
                    this.context.components.box.backgroundTransparency
                }
                BackgroundColor3={
                    this.props.BackgroundColor3 ??
                    this.context.components.box.backgroundColor
                }
                ZIndex={this.props.ZIndex}
            >
                <Corners radius={this.context.components.box.cornerRadius} />

                <uistroke
                    Thickness={this.context.components.box.borderThickness}
                    BorderStrokePosition={Enum.BorderStrokePosition.Inner}
                    Color={this.context.components.box.borderColor}
                />
                <BoxShadow {...this.props} value={this.context.components.box.boxShadow} />
                <Padding {...this.props} />

                {this.props.children}
            </frame>
        );
    }
}