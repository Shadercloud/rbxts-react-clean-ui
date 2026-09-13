import React from "@rbxts/react";
import { IconElementProps, IntentElementProps, ScalableElementProps } from "../../Interfaces/";
import { CleanThemeContext } from "../../Contexts/";
import { Corners, Gradient, Padding } from "../Decorator";
import { Text } from "../Typography";
import { ColorHelper, CssHelper, SpacingHelper, TypographyHelper } from "../../Helpers";
import { HStack } from "../Layout";
import { Icon } from "./Icon";

export interface BadgeProps extends IntentElementProps, ScalableElementProps, IconElementProps {
    text: string;
    name?: string;
    LayoutOrder?: number;
    Position?: UDim2;
    AnchorPoint?: Vector2;
}

export const Badge = React.forwardRef<ImageLabel, BadgeProps>(
    (props, ref) => {
        const theme = React.useContext(CleanThemeContext);
        const badgeTheme = theme.components.badge;
        const scale = props.scale ?? theme.default.scale;

        const intentColors = ColorHelper.getIntentColors(
            theme,
            props.intent,
            "default",
            badgeTheme.intents,
        );

        const backgroundImage = CssHelper.resolveBackgroundImage(intentColors.backgroundImage);

        const padding = SpacingHelper.GetResolvedPadding(
            theme,
            {},
            badgeTheme.spacing,
            badgeTheme.padding,
            scale,
        );

        const gap = math.ceil(SpacingHelper.GetPadding(theme, scale, badgeTheme.spacing) / 2);

        return (
            <imagelabel
                key={props.name ?? "Badge"}
                ref={ref}
                Active={false}
                Selectable={false}
                Size={UDim2.fromOffset(0, 0)}
                AutomaticSize={Enum.AutomaticSize.XY}
                Position={props.Position}
                AnchorPoint={props.AnchorPoint}
                LayoutOrder={props.LayoutOrder}
                BackgroundColor3={intentColors.backgroundColor}
                BackgroundTransparency={intentColors.backgroundTransparency ?? 0}
                BorderSizePixel={0}

                Image={backgroundImage.Image ?? ""}
                ImageColor3={backgroundImage.ImageColor3}
                ImageTransparency={backgroundImage.ImageTransparency}
                ScaleType={backgroundImage.ScaleType}
                SliceCenter={backgroundImage.SliceCenter}
                SliceScale={backgroundImage.SliceScale}
                TileSize={backgroundImage.TileSize}
            >
                <Corners radius={badgeTheme.cornerRadius} />

                {badgeTheme.borderThickness > 0 && (
                    <uistroke
                        key="Stroke"
                        Thickness={badgeTheme.borderThickness}
                        BorderStrokePosition={Enum.BorderStrokePosition.Inner}
                        Color={intentColors.borderColor}
                    />
                )}

                <Gradient value={intentColors.backgroundGradient} />

                <Padding resolvedPadding={padding} />

                <HStack valign="Center" Wraps={false} Padding={new UDim(0, gap)}>
                    {props.icon !== undefined &&
                        <Icon
                            name="BadgeIcon"
                            LayoutOrder={1}
                            scale={scale}
                            icon={props.icon}
                            color={intentColors.textColor}
                        />
                    }
                    <Text
                        name="BadgeText"
                        LayoutOrder={2}
                        text={props.text}
                        TextWrap={false}
                        typography={TypographyHelper.getTypography(theme, scale, badgeTheme.typography)}
                        TextColor3={intentColors.textColor}
                    />
                </HStack>
            </imagelabel>
        );
    },
);
