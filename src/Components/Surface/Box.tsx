import React from "@rbxts/react";
import { BackgroundElementProps, PaddingProps, PositionElementProps, ShadowElementProps, SizeElementProps, SpacedElementProps, ZIndexElementProps } from "../../Interfaces/";
import { CleanThemeContext } from "../../Contexts/";
import { Padding, Corners, BoxShadow } from "../Decorator";
import { Container } from "../Layout";
import { SizeHelper, CssHelper } from "../../Helpers";
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
}

export const Box = React.forwardRef<ImageLabel, BoxProps>(
    (props, ref) => {
        const theme = React.useContext(CleanThemeContext);

        const paddingSourceProps = props as PaddingProps;

        const hasCustomPadding =
            paddingSourceProps.top !== undefined ||
            paddingSourceProps.bottom !== undefined ||
            paddingSourceProps.left !== undefined ||
            paddingSourceProps.right !== undefined ||
            paddingSourceProps.spacing !== undefined ||
            paddingSourceProps.padding !== undefined ||
            paddingSourceProps.resolvedPadding !== undefined;

        const themePadding = theme.components.box.padding;

        const paddingProps: PaddingProps = !hasCustomPadding && themePadding !== undefined
            ? { resolvedPadding: CssHelper.parseCssQuad(themePadding) }
            : paddingSourceProps;

        return (
            <Container
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
                <uistroke
                    Thickness={props['border-thickness'] ?? theme.components.box.borderThickness}
                    BorderStrokePosition={Enum.BorderStrokePosition.Inner}
                    Color={props['border-color'] ?? theme.components.box.borderColor}
                />
                <BoxShadow {...props} value={theme.components.box.boxShadow} />
                <Padding {...paddingProps} />

                <Corners radius={theme.components.box.cornerRadius} />

                {props.children}
            </Container>
        );
    }
)