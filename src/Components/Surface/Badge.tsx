import React, { Binding } from "@rbxts/react";
import { BackgroundElementProps, BorderElementProps, CssPadding, IconElementProps, IntentElementProps, ScalableElementProps } from "../../Interfaces/";
import { CleanThemeContext } from "../../Contexts/";
import { Corners, Gradient, Padding } from "../Decorator";
import { Text } from "../Typography";
import { ColorHelper, CssHelper, SpacingHelper, TypographyHelper } from "../../Helpers";
import { HStack } from "../Layout";
import { Icon } from "./Icon";

export interface BadgeStateStyle {
    backgroundColor?: Color3;
    backgroundTransparency?: number;
    textColor?: Color3;
    iconColor?: Color3;
    borderColor?: Color3;
}

export interface BadgeProps extends IntentElementProps, ScalableElementProps, IconElementProps, BackgroundElementProps, BorderElementProps {
    text: string;
    name?: string;
    LayoutOrder?: number;
    Position?: UDim2;
    AnchorPoint?: Vector2;
    textColor?: Color3;
    iconColor?: Color3;
    padding?: CssPadding;
    onClick?: () => void;
    hoverStyle?: BadgeStateStyle;
    pressStyle?: BadgeStateStyle;
}

function darkenColor(color: Color3 | Binding<Color3>, amount: number): Color3 | Binding<Color3> {
    const target = amount < 0 ? new Color3(1, 1, 1) : new Color3(0, 0, 0);
    const alpha = math.abs(amount);

    if (typeIs(color, "Color3")) {
        return color.Lerp(target, alpha);
    }

    return color.map((value) => value.Lerp(target, alpha));
}

export const Badge = React.forwardRef<ImageLabel, BadgeProps>(
    (props, ref) => {
        const theme = React.useContext(CleanThemeContext);
        const badgeTheme = theme.components.badge;
        const scale = props.scale ?? theme.default.scale;

        const clickable = props.onClick !== undefined;
        const [hover, setHover] = React.useState(false);
        const [pressed, setPressed] = React.useState(false);

        React.useEffect(() => {
            if (!clickable) {
                setHover(false);
                setPressed(false);
            }
        }, [clickable]);

        const intentColors = ColorHelper.getIntentColors(
            theme,
            props.intent,
            "default",
            badgeTheme.intents,
        );

        const stateStyle: BadgeStateStyle | undefined = !clickable
            ? undefined
            : pressed
                ? { ...props.hoverStyle, ...props.pressStyle }
                : hover
                    ? props.hoverStyle
                    : undefined;

        const darken = !clickable
            ? 0
            : pressed
                ? badgeTheme.pressDarken ?? badgeTheme.hoverDarken ?? 0
                : hover
                    ? badgeTheme.hoverDarken ?? 0
                    : 0;

        const baseBackgroundColor = props.BackgroundColor3 ?? intentColors.backgroundColor;
        const backgroundColor = stateStyle?.backgroundColor
            ?? (darken !== 0 ? darkenColor(baseBackgroundColor, darken) : baseBackgroundColor);

        const textColor = stateStyle?.textColor ?? props.textColor ?? intentColors.textColor;
        const iconColor = stateStyle?.iconColor ?? props.iconColor ?? textColor;
        const borderColor = stateStyle?.borderColor ?? props.borderColor ?? intentColors.borderColor;
        const borderThickness = props.borderThickness ?? badgeTheme.borderThickness;

        const backgroundImage = CssHelper.resolveBackgroundImage(intentColors.backgroundImage);

        const padding = SpacingHelper.GetResolvedPadding(
            theme,
            { padding: props.padding },
            badgeTheme.spacing,
            badgeTheme.padding,
            scale,
        );

        const gap = math.ceil(SpacingHelper.GetPadding(theme, scale, badgeTheme.spacing) / 2);

        const content = (
            <>
                <Padding resolvedPadding={padding} />

                <HStack valign="Center" Wraps={false} Padding={new UDim(0, gap)}>
                    {props.icon !== undefined &&
                        <Icon
                            name="BadgeIcon"
                            LayoutOrder={1}
                            scale={scale}
                            icon={props.icon}
                            color={iconColor}
                        />
                    }
                    <Text
                        name="BadgeText"
                        LayoutOrder={2}
                        text={props.text}
                        TextWrap={false}
                        typography={TypographyHelper.getTypography(theme, scale, badgeTheme.typography)}
                        TextColor3={textColor}
                    />
                </HStack>
            </>
        );

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
                BackgroundColor3={backgroundColor}
                BackgroundTransparency={stateStyle?.backgroundTransparency ?? props.BackgroundTransparency ?? intentColors.backgroundTransparency ?? 0}
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

                {borderThickness > 0 && (
                    <uistroke
                        key="Stroke"
                        Thickness={borderThickness}
                        BorderStrokePosition={props.borderPosition === "outer" ? Enum.BorderStrokePosition.Outer : Enum.BorderStrokePosition.Inner}
                        Color={borderColor}
                        Transparency={props.borderTransparency}
                    />
                )}

                <Gradient value={intentColors.backgroundGradient} />

                {clickable
                    ? (
                        <imagebutton
                            key="BadgeButton"
                            Size={UDim2.fromOffset(0, 0)}
                            AutomaticSize={Enum.AutomaticSize.XY}
                            BackgroundTransparency={1}
                            BorderSizePixel={0}
                            AutoButtonColor={false}
                            Image=""
                            Event={{
                                MouseEnter: () => setHover(true),
                                MouseLeave: () => {
                                    setHover(false);
                                    setPressed(false);
                                },
                                SelectionGained: () => setHover(true),
                                SelectionLost: () => {
                                    setHover(false);
                                    setPressed(false);
                                },
                                MouseButton1Down: () => setPressed(true),
                                MouseButton1Up: () => setPressed(false),
                                Activated: () => {
                                    setPressed(false);
                                    props.onClick?.();
                                },
                            }}
                        >
                            {content}
                        </imagebutton>
                    )
                    : content}
            </imagelabel>
        );
    },
);
