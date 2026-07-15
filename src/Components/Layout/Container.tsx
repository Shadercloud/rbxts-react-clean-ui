import React, { Component, ReactComponent } from "@rbxts/react";
import { PositionElementProps, SizeElementProps, ZIndexElementProps } from "../../Interfaces/";
import { SizeHelper } from "../../Helpers/";

interface ContainerProps extends SizeElementProps, PositionElementProps, ZIndexElementProps { }

@ReactComponent
export class Container extends Component<ContainerProps> {
    render(): React.ReactNode {
        return <frame
            Size={SizeHelper.GetSize(this.props)}
            AutomaticSize={SizeHelper.GetAutoSize(this.props)}
            Position={SizeHelper.GetPosition(this.props)}
            AnchorPoint={SizeHelper.GetAnchor(this.props)}
            BackgroundTransparency={1}
            ZIndex={this.props.ZIndex}
        >
            {this.props.children}
        </frame>
    }
}