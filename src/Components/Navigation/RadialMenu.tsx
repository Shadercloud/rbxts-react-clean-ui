import React from "@rbxts/react";
import { useTween } from "@rbxts/react-ripple";
import { CleanThemeContext } from "../../Contexts";
import { ColorHelper, SizeHelper, TypographyHelper } from "../../Helpers";
import {
    CssSize,
    IconElementProps,
    PositionElementProps,
    ScalableElementProps,
    ScaleSize,
    ZIndexElementProps,
} from "../../Interfaces";
import { Icon } from "../Surface/Icon";
import { Text } from "../Typography";

export interface RadialMenuItem extends IconElementProps {
    value: string;
    text?: string;
    description?: string;
}

export interface RadialMenuPlaceholder extends IconElementProps {
    text?: string;
    description?: string;
}

export interface RadialMenuProps
    extends ScalableElementProps,
    ZIndexElementProps,
    Pick<PositionElementProps, "Position" | "AnchorPoint"> {
    items: RadialMenuItem[];
    value?: string;
    defaultValue?: string;
    onValueChange?: (value: string, item: RadialMenuItem) => void;
    size?: CssSize;
    thickness?: CssSize;
    showLabels?: boolean;
    placeholder?: RadialMenuPlaceholder;
    LayoutOrder?: number;
    name?: string;
}

interface RadialMenuWedgeProps {
    name: string;
    start: number;
    sweep: number;
    color: Color3;
    transparency?: number;
    ZIndex?: number;
}

const HALF_MASK = new NumberSequence([
    new NumberSequenceKeypoint(0, 1),
    new NumberSequenceKeypoint(0.4999, 1),
    new NumberSequenceKeypoint(0.5, 0),
    new NumberSequenceKeypoint(1, 0),
]);

const SMALLER_SCALE: Record<ScaleSize, ScaleSize> = {
    xs: "xs",
    sm: "xs",
    md: "sm",
    lg: "md",
    xl: "lg",
};

function wrapDegrees(angle: number): number {
    return angle - math.floor(angle / 360) * 360;
}

function RadialMenuWedge(props: RadialMenuWedgeProps) {
    if (props.sweep >= 360) {
        return (
            <frame
                key={props.name}
                Size={UDim2.fromScale(1, 1)}
                BackgroundColor3={props.color}
                BackgroundTransparency={props.transparency ?? 0}
                BorderSizePixel={0}
                ZIndex={props.ZIndex}
            >
                <uicorner key="Corners" CornerRadius={new UDim(0.5, 0)} />
            </frame>
        );
    }

    return (
        <frame
            key={props.name}
            Size={UDim2.fromScale(1, 1)}
            Rotation={props.start}
            BackgroundTransparency={1}
            BorderSizePixel={0}
            ZIndex={props.ZIndex}
        >
            <canvasgroup
                key="Clip"
                Position={UDim2.fromScale(0.5, 0)}
                Size={UDim2.fromScale(0.5, 1)}
                ClipsDescendants
                BackgroundTransparency={1}
                BorderSizePixel={0}
            >
                <frame
                    key="Fill"
                    AnchorPoint={new Vector2(0.5, 0.5)}
                    Position={UDim2.fromScale(0, 0.5)}
                    Size={UDim2.fromScale(2, 1)}
                    BackgroundColor3={props.color}
                    BackgroundTransparency={props.transparency ?? 0}
                    BorderSizePixel={0}
                >
                    <uicorner key="Corners" CornerRadius={new UDim(0.5, 0)} />
                    <uigradient key="Mask" Transparency={HALF_MASK} Rotation={props.sweep - 180} />
                </frame>
            </canvasgroup>
        </frame>
    );
}

const RadialMenu = React.forwardRef<Frame, RadialMenuProps>((props, ref) => {
    const theme = React.useContext(CleanThemeContext);
    const radialTheme = theme.components.radialMenu;

    const controlled = props.value !== undefined;
    const [internalValue, setInternalValue] = React.useState(props.defaultValue);
    const [hoverIndex, setHoverIndex] = React.useState(-1);

    const selectedValue = controlled ? props.value : internalValue;
    const count = props.items.size();
    const step = count > 0 ? 360 / count : 360;
    const selectedIndex = props.items.findIndex((item) => item.value === selectedValue);
    const hovered = hoverIndex >= 0 && hoverIndex < count ? hoverIndex : -1;

    const thickness = SizeHelper.toUDim(props.thickness ?? radialTheme.thickness);
    const diameter = SizeHelper.toUDim(props.size ?? radialTheme.size);
    const innerScale = 1 - thickness.Scale;
    const innerOffset = -2 * thickness.Offset;
    const itemRadiusScale = 0.5 - thickness.Scale / 4;
    const itemRadiusOffset = -thickness.Offset / 2;

    const duration = radialTheme.animation.duration;
    const initialAngle = selectedIndex >= 0 ? selectedIndex * step : 0;
    const [rotation, rotationTween] = useTween(initialAngle, { duration });
    const goalRef = React.useRef<number | undefined>(selectedIndex >= 0 ? initialAngle : undefined);

    React.useEffect(() => {
        if (selectedIndex < 0) {
            goalRef.current = undefined;
            return;
        }

        const target = selectedIndex * step;
        const previous = goalRef.current;
        const goal = previous === undefined ? target : previous + wrapDegrees(target - previous + 180) - 180;
        goalRef.current = goal;

        rotationTween.setGoal(goal, { duration });
        if (previous === undefined || duration <= 0) rotationTween.setPosition(goal);
        rotationTween.start();
    }, [selectedIndex, step, duration, rotationTween]);

    const selectIndex = (index: number) => {
        const item = props.items[index];
        if (item === undefined) return;

        if (!controlled) setInternalValue(item.value);
        props.onValueChange?.(item.value, item);
    };

    const resolveIndex = (rbx: Frame, position: Vector3): number => {
        if (count === 0) return -1;

        const size = rbx.AbsoluteSize;
        const outer = math.min(size.X, size.Y) / 2;
        if (outer <= 0) return -1;

        const inner = math.max(0, outer - (thickness.Scale * outer + thickness.Offset));
        const dx = position.X - (rbx.AbsolutePosition.X + size.X / 2);
        const dy = position.Y - (rbx.AbsolutePosition.Y + size.Y / 2);
        const distance = math.sqrt(dx * dx + dy * dy);

        if (distance > outer || distance < inner) return -1;

        const angle = wrapDegrees(math.deg(math.atan2(dx, -dy)) + step / 2);
        return math.min(math.floor(angle / step), count - 1);
    };

    const schemeFor = (index: number) =>
        ColorHelper.getIntentColors(
            theme,
            "primary",
            index === selectedIndex ? "focus" : index === hovered ? "hover" : "default",
            radialTheme.intents,
        );

    const ringScheme = ColorHelper.getIntentColors(theme, "primary", "default", radialTheme.intents);
    const hoverScheme = ColorHelper.getIntentColors(theme, "primary", "hover", radialTheme.intents);
    const focusScheme = ColorHelper.getIntentColors(theme, "primary", "focus", radialTheme.intents);

    const scale = props.scale ?? theme.default.scale;
    const labelTypography = TypographyHelper.getTypography(theme, SMALLER_SCALE[scale], radialTheme.labels.typography);
    const titleTypography = TypographyHelper.getTypography(theme, scale, radialTheme.center.title.typography);
    const descriptionTypography = TypographyHelper.getTypography(theme, SMALLER_SCALE[scale], radialTheme.center.description.typography);
    const centerTextColor = theme.colors.intents.primary.default.textColor;

    const selectedItem = selectedIndex >= 0 ? props.items[selectedIndex] : undefined;
    const centerIcon = selectedItem !== undefined ? selectedItem.icon : props.placeholder?.icon;
    const centerText = selectedItem !== undefined ? selectedItem.text : props.placeholder?.text;
    const centerDescription = selectedItem !== undefined ? selectedItem.description : props.placeholder?.description;

    const items = props.items.map((item, index) => {
        const radians = math.rad(index * step);
        const sin = math.sin(radians);
        const cos = math.cos(radians);
        const scheme = schemeFor(index);
        const hasLabel = props.showLabels === true && item.text !== undefined && item.text !== "";

        return (
            <frame
                key={`RadialMenuItem-${item.value}`}
                AnchorPoint={new Vector2(0.5, 0.5)}
                Position={new UDim2(
                    0.5 + sin * itemRadiusScale,
                    sin * itemRadiusOffset,
                    0.5 - cos * itemRadiusScale,
                    -cos * itemRadiusOffset,
                )}
                Size={UDim2.fromScale(0, 0)}
                AutomaticSize={Enum.AutomaticSize.XY}
                BackgroundTransparency={1}
                BorderSizePixel={0}
            >
                <uilistlayout
                    key="ItemLayout"
                    FillDirection={Enum.FillDirection.Vertical}
                    HorizontalAlignment={Enum.HorizontalAlignment.Center}
                    VerticalAlignment={Enum.VerticalAlignment.Center}
                    SortOrder={Enum.SortOrder.LayoutOrder}
                />
                {item.icon !== undefined && (
                    <Icon
                        name="ItemIcon"
                        LayoutOrder={1}
                        icon={item.icon}
                        scale={props.scale ?? radialTheme.iconScale}
                        color={scheme.textColor}
                    />
                )}
                {hasLabel && (
                    <Text
                        name="ItemLabel"
                        LayoutOrder={2}
                        text={item.text!}
                        align="Center"
                        typography={labelTypography}
                        TextColor3={labelTypography.color ?? scheme.textColor}
                    />
                )}
            </frame>
        );
    });

    return (
        <frame
            key={props.name ?? "RadialMenu"}
            ref={ref}
            Size={new UDim2(diameter, diameter)}
            Position={props.Position}
            AnchorPoint={props.AnchorPoint}
            LayoutOrder={props.LayoutOrder}
            ZIndex={props.ZIndex}
            BackgroundTransparency={1}
            BorderSizePixel={0}
        >
            <uiaspectratioconstraint key="AspectRatio" AspectRatio={1} />
            <frame
                key="Ring"
                Size={UDim2.fromScale(1, 1)}
                BackgroundColor3={ringScheme.backgroundColor}
                BackgroundTransparency={ringScheme.backgroundTransparency ?? 0}
                BorderSizePixel={0}
                ZIndex={1}
            >
                <uicorner key="Corners" CornerRadius={new UDim(0.5, 0)} />
            </frame>
            {hovered >= 0 && hovered !== selectedIndex && (
                <RadialMenuWedge
                    name="HoverWedge"
                    start={hovered * step - step / 2}
                    sweep={step}
                    color={hoverScheme.backgroundColor}
                    transparency={hoverScheme.backgroundTransparency}
                    ZIndex={2}
                />
            )}
            <frame
                key="SelectedWedge"
                Size={UDim2.fromScale(1, 1)}
                Rotation={rotation}
                Visible={selectedIndex >= 0}
                BackgroundTransparency={1}
                BorderSizePixel={0}
                ZIndex={3}
            >
                <RadialMenuWedge
                    name="Wedge"
                    start={-step / 2}
                    sweep={step}
                    color={focusScheme.backgroundColor}
                    transparency={focusScheme.backgroundTransparency}
                />
            </frame>
            <frame
                key="Center"
                AnchorPoint={new Vector2(0.5, 0.5)}
                Position={UDim2.fromScale(0.5, 0.5)}
                Size={new UDim2(innerScale, innerOffset, innerScale, innerOffset)}
                BackgroundColor3={radialTheme.center.backgroundColor}
                BackgroundTransparency={radialTheme.center.backgroundTransparency}
                BorderSizePixel={0}
                ZIndex={4}
            >
                <uicorner key="Corners" CornerRadius={new UDim(0.5, 0)} />
                <frame
                    key="CenterContent"
                    AnchorPoint={new Vector2(0.5, 0.5)}
                    Position={UDim2.fromScale(0.5, 0.5)}
                    Size={UDim2.fromScale(0.75, 0.75)}
                    BackgroundTransparency={1}
                    BorderSizePixel={0}
                >
                    <uilistlayout
                        key="CenterLayout"
                        FillDirection={Enum.FillDirection.Vertical}
                        HorizontalAlignment={Enum.HorizontalAlignment.Center}
                        VerticalAlignment={Enum.VerticalAlignment.Center}
                        SortOrder={Enum.SortOrder.LayoutOrder}
                        Padding={new UDim(0, radialTheme.center.gap ?? 0)}
                    />
                    {centerIcon !== undefined && (
                        <Icon
                            name="CenterIcon"
                            LayoutOrder={1}
                            icon={centerIcon}
                            Size={UDim2.fromOffset(radialTheme.center.iconSize, radialTheme.center.iconSize)}
                            color={radialTheme.center.iconColor ?? centerTextColor}
                        />
                    )}
                    {centerText !== undefined && centerText !== "" && (
                        <Text
                            name="CenterTitle"
                            LayoutOrder={2}
                            text={centerText}
                            align="Center"
                            TextWrap
                            Size={UDim2.fromScale(1, 0)}
                            AutomaticSize={Enum.AutomaticSize.Y}
                            typography={titleTypography}
                            TextColor3={titleTypography.color ?? centerTextColor}
                        />
                    )}
                    {centerDescription !== undefined && centerDescription !== "" && (
                        <Text
                            name="CenterDescription"
                            LayoutOrder={3}
                            text={centerDescription}
                            align="Center"
                            TextWrap
                            Size={UDim2.fromScale(1, 0)}
                            AutomaticSize={Enum.AutomaticSize.Y}
                            typography={descriptionTypography}
                            TextColor3={descriptionTypography.color ?? centerTextColor}
                        />
                    )}
                </frame>
            </frame>
            <frame
                key="Items"
                Size={UDim2.fromScale(1, 1)}
                BackgroundTransparency={1}
                BorderSizePixel={0}
                ZIndex={5}
            >
                {items}
            </frame>
            <frame
                key="HitArea"
                Size={UDim2.fromScale(1, 1)}
                BackgroundTransparency={1}
                BorderSizePixel={0}
                Active
                ZIndex={6}
                Event={{
                    InputBegan: (rbx, input) => {
                        if (input.UserInputType !== Enum.UserInputType.Touch) return;
                        setHoverIndex(resolveIndex(rbx, input.Position));
                    },
                    InputChanged: (rbx, input) => {
                        if (input.UserInputType !== Enum.UserInputType.MouseMovement && input.UserInputType !== Enum.UserInputType.Touch) return;
                        setHoverIndex(resolveIndex(rbx, input.Position));
                    },
                    InputEnded: (rbx, input) => {
                        const touch = input.UserInputType === Enum.UserInputType.Touch;
                        if (input.UserInputType !== Enum.UserInputType.MouseButton1 && !touch) return;

                        const index = resolveIndex(rbx, input.Position);
                        if (touch) setHoverIndex(-1);
                        if (index >= 0) selectIndex(index);
                    },
                    MouseLeave: () => {
                        setHoverIndex(-1);
                    },
                }}
            />
        </frame>
    );
});

export { RadialMenu };
