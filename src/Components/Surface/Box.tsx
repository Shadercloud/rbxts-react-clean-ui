import React, { Component, ReactComponent } from "@rbxts/react";
import { BackgroundElementProps, ShadowElementProps, SizeElementProps, SpacedElementProps, ZIndexElementProps } from "../../Interfaces/";
import { CleanThemeContext } from "../../Contexts/";
import { Padding, Corners, BoxShadow } from "../Decorator";
import { Container } from "../Layout";
import { SizeHelper } from "../../Helpers";

interface BoxProps extends SpacedElementProps, ShadowElementProps, BackgroundElementProps, ZIndexElementProps, SizeElementProps { }

@ReactComponent
export class Box extends Component<BoxProps> {
    static contextType = CleanThemeContext;

    declare context: React.ContextType<typeof CleanThemeContext>;
    render() {
        return (
            <Container
                Size={SizeHelper.GetSize(this.props, UDim2.fromScale(1, 1))}
                AutomaticSize={Enum.AutomaticSize.XY}
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
            </Container>
        );
    }
}