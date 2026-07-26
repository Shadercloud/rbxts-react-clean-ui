import React from "@rbxts/react";
import { BackgroundElementProps, ShadowElementProps, SizeElementProps, SpacedElementProps, ZIndexElementProps } from "../../Interfaces/";
import { CleanThemeContext } from "../../Contexts/";
import { Padding, Corners, BoxShadow } from "../Decorator";
import { Container } from "../Layout";
import { SizeHelper } from "../../Helpers";

interface BoxProps extends SpacedElementProps, ShadowElementProps, BackgroundElementProps, ZIndexElementProps, SizeElementProps, React.InstanceProps<Frame> {

}

export const Box = React.forwardRef<Frame, BoxProps>(
    (props, ref) => {
        const theme = React.useContext(CleanThemeContext);

        return (
            <Container
                ref={ref}
                {...props}
                Size={SizeHelper.GetSize(props, UDim2.fromScale(1, 1))}
                AutomaticSize={Enum.AutomaticSize.XY}
                BackgroundTransparency={
                    props.BackgroundTransparency ??
                    theme.components.box.backgroundTransparency
                }
                BackgroundColor3={
                    props.BackgroundColor3 ??
                    theme.components.box.backgroundColor
                }
                ZIndex={props.ZIndex}
                Event={props.Event}
            >
                <Corners radius={theme.components.box.cornerRadius} />

                <uistroke
                    Thickness={theme.components.box.borderThickness}
                    BorderStrokePosition={Enum.BorderStrokePosition.Inner}
                    Color={theme.components.box.borderColor}
                />
                <BoxShadow {...props} value={theme.components.box.boxShadow} />
                <Padding {...props} />

                {props.children}
            </Container>
        );
    }
)