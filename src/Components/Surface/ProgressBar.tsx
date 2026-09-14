import React from "@rbxts/react";
import { useTween } from "@rbxts/react-ripple";
import { CleanThemeContext } from "../../Contexts";
import { ColorHelper, CssHelper, SizeHelper, SpacingHelper, TypographyHelper } from "../../Helpers";
import { Corners, Gradient } from "../Decorator";
import { Container, HStack, VStack } from "../Layout";
import { Text } from "../Typography";
import {
    IntentElementProps,
    PositionElementProps,
    ScalableElementProps,
    SizeElementProps,
    ZIndexElementProps,
} from "../../Interfaces";

export interface ProgressBarProps extends
    IntentElementProps,
    ScalableElementProps,
    SizeElementProps,
    PositionElementProps,
    ZIndexElementProps,
    React.InstanceProps<ImageLabel> {
    value: number;
    max?: number;
    label?: string;
    showValue?: boolean;
    valueFormatter?: (value: number, max: number) => string;
    name?: string;
    striped?: boolean;
    stripeDuration?: number;
    stripeDirection?: number;
}

function defaultValueFormatter(value: number, max: number): string {
    const percent = max > 0 ? (value / max) * 100 : 0;
    return `${math.round(percent)}%`;
}

export const ProgressBar = React.forwardRef<ImageLabel, ProgressBarProps>(
    (props, ref) => {
        const theme = React.useContext(CleanThemeContext);
        const progressBarTheme = theme.components.progressBar;

        const maxValue = math.max(props.max ?? 100, 0);
        const clampedValue = math.clamp(props.value, 0, maxValue);
        const targetProgress = maxValue > 0 ? clampedValue / maxValue : 0;

        const duration = progressBarTheme.animation.duration;

        const [progress, progressTween] = useTween(targetProgress, { duration });

        React.useEffect(() => {
            progressTween.setGoal(targetProgress, { duration });

            if (duration === 0) {
                progressTween.setPosition(targetProgress);
            }
        }, [targetProgress, duration, progressTween]);

        const colors = ColorHelper.getIntentColors(
            theme,
            props.intent,
            "default",
            progressBarTheme.fill.intents,
        );

        const height = SizeHelper.toUDim(
            progressBarTheme.height[props.scale ?? theme.default.scale],
        );

        const fillSize = progress.map((value) => UDim2.fromScale(value, 1));
        const fillPosition = UDim2.fromScale(0, 0);

        const stripeTheme = progressBarTheme.fill.stripe;
        const striped = props.striped ?? stripeTheme?.enabled ?? false;
        const stripeDuration = props.stripeDuration ?? stripeTheme?.duration ?? 0.75;
        const rawStripeDirection = props.stripeDirection ?? stripeTheme?.direction;
        const stripeDirection = rawStripeDirection === -1 ? -1 : 1;

        const resolvedStripeImage = CssHelper.resolveBackgroundImage(stripeTheme?.image);
        const stripeTileSize = resolvedStripeImage.TileSize ?? UDim2.fromOffset(16, 16);
        const stripeTileWidth = stripeTileSize.X.Offset !== 0 ? stripeTileSize.X.Offset : 16;

        const [stripeProgress, stripeTween] = useTween(0, {
            duration: stripeDuration,
            easing: "linear",
            repeats: math.huge,
            reverses: false,
        });

        React.useEffect(() => {
            if (!striped) {
                return;
            }

            stripeTween.setPosition(0);
            stripeTween.setGoal(1, { duration: stripeDuration });
        }, [striped, stripeDuration, stripeTween]);

        const stripePosition = stripeProgress.map((value) =>
            stripeDirection === 1
                ? UDim2.fromOffset(-stripeTileWidth + value * stripeTileWidth, 0)
                : UDim2.fromOffset(-value * stripeTileWidth, 0));

        const showHeader = props.label !== undefined || props.showValue === true;
        const formattedValue = props.showValue
            ? (props.valueFormatter ?? defaultValueFormatter)(clampedValue, maxValue)
            : undefined;

        const labelTypography = TypographyHelper.getTypography(theme, props.scale, progressBarTheme.header.label.typography);
        const valueTypography = TypographyHelper.getTypography(
            theme,
            props.scale,
            progressBarTheme.header.value.typography ?? progressBarTheme.header.label.typography,
        );

        const track = (
            <Container
                name={props.name ?? "ProgressBar"}
                ref={ref}
                {...props}
                Size={SizeHelper.GetSize(props, new UDim2(new UDim(1, 0), height))}
                ClipsDescendants={props.ClipsDescendants ?? true}
                BackgroundColor3={progressBarTheme.track.backgroundColor}
                BackgroundTransparency={progressBarTheme.track.backgroundTransparency}
                backgroundImage={progressBarTheme.track.backgroundImage}
                backgroundGradient={progressBarTheme.track.backgroundGradient}
            >
                <uistroke
                    key="Stroke"
                    Thickness={progressBarTheme.track.borderThickness}
                    BorderStrokePosition={Enum.BorderStrokePosition.Inner}
                    Color={progressBarTheme.track.borderColor}
                />

                <Corners radius={progressBarTheme.track.cornerRadius} />

                <frame
                    key="Fill"
                    Size={fillSize}
                    Position={fillPosition}
                    BackgroundColor3={colors.backgroundColor}
                    BackgroundTransparency={colors.backgroundTransparency ?? 0}
                    BorderSizePixel={0}
                    ClipsDescendants={true}
                >
                    <Corners radius={progressBarTheme.fill.cornerRadius} />
                    <Gradient value={colors.backgroundGradient} />
                    {striped && (
                        <imagelabel
                            key="Stripe"
                            BackgroundTransparency={1}
                            BorderSizePixel={0}
                            ImageTransparency={resolvedStripeImage.ImageTransparency ?? 0.9}
                            ImageColor3={resolvedStripeImage.ImageColor3}
                            Size={new UDim2(1, stripeTileWidth, 1, 0)}
                            Position={stripePosition}
                            Image={resolvedStripeImage.Image ?? `rbxassetid://86644568183933`}
                            ScaleType={Enum.ScaleType.Tile}
                            TileSize={stripeTileSize}
                        />
                    )}
                </frame>
            </Container>
        );

        if (!showHeader) {
            return track;
        }

        return (
            <frame
                key={props.name ?? "ProgressBar"}
                BackgroundTransparency={1}
                BorderSizePixel={0}
                Size={SizeHelper.GetSize(props, UDim2.fromScale(1, 0))}
                AutomaticSize={Enum.AutomaticSize.Y}
                Position={SizeHelper.GetPosition(props)}
                AnchorPoint={SizeHelper.GetAnchor(props)}
                ZIndex={props.ZIndex}
            >
                <VStack spacing="None" HorizontalFlex={Enum.UIFlexAlignment.None} Padding={new UDim(0, SpacingHelper.GetPadding(theme, props.scale, progressBarTheme.header.spacing))}>
                    <frame
                        key="ProgressBarHeader"
                        BackgroundTransparency={1}
                        BorderSizePixel={0}
                        Size={UDim2.fromScale(1, 0)}
                        AutomaticSize={Enum.AutomaticSize.Y}
                    >
                        <HStack valign="Center" Wraps={false} HorizontalFlex={Enum.UIFlexAlignment.SpaceBetween}>
                            {props.label !== undefined && (
                                <Text
                                    name="ProgressBarLabel"
                                    text={props.label}
                                    TextColor3={labelTypography.color}
                                    typography={labelTypography}
                                />
                            )}
                            {formattedValue !== undefined && (
                                <Text
                                    name="ProgressBarValue"
                                    text={formattedValue}
                                    TextColor3={valueTypography.color}
                                    typography={valueTypography}
                                />
                            )}
                        </HStack>
                    </frame>
                    {track}
                </VStack>
            </frame>
        );
    },
);
