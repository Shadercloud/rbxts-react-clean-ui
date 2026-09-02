import React from "@rbxts/react";
import { BackgroundElementProps, PaddingProps, PositionElementProps, ShadowElementProps, SizeElementProps, SpacedElementProps, ZIndexElementProps } from "../../Interfaces/";
import { CleanThemeContext } from "../../Contexts/";
import { Padding, Corners, BoxShadow } from "../Decorator";
import { Container } from "../Layout";
import { SizeHelper, SpacingHelper } from "../../Helpers";
import { CssBackgroundImage } from "../../Theme";

export interface BoxProps extends SpacedElementProps,
    ShadowElementProps,
    BackgroundElementProps,
    ZIndexElementProps,
    SizeElementProps,
    PositionElementProps,
    React.InstanceProps<ImageLabel> {
    'border-thickness'?: number;
    'border-color'?: Color3;
    'background-image'?: CssBackgroundImage;
    name?: string;
}

export const Box = React.forwardRef<ImageLabel, BoxProps>(
    (props, ref) => {
        const theme = React.useContext(CleanThemeContext);

        const borderThickness = props['border-thickness'] ?? theme.components.box.borderThickness;

        return (
            <Container
                name={props.name ?? "Box"}
                ref={ref}
                {...props}
                Size={SizeHelper.GetSize(props, UDim2.fromScale(1, 1))}
                AutomaticSize={SizeHelper.GetAutoSize(props)}
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
                backgroundImage={props['background-image'] ?? theme.components.box.backgroundImage}
            >
                {borderThickness > 0 && (
                    <uistroke
                        key="Stroke"
                        Thickness={borderThickness}
                        BorderStrokePosition={Enum.BorderStrokePosition.Inner}
                        Color={props['border-color'] ?? theme.components.box.borderColor}
                    />
                )}
                <BoxShadow {...props} value={theme.components.box.boxShadow} />
                <Padding resolvedPadding={SpacingHelper.GetResolvedPadding(theme, props as PaddingProps, theme.components.box.spacing, theme.components.box.padding)} />

                <Corners radius={theme.components.box.cornerRadius} />

                {props.children}
            </Container>
        );
    }
)