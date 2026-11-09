import React from "@rbxts/react";
import { useTween } from "@rbxts/react-ripple";
import { CleanThemeContext } from "../../Contexts";
import { ColorHelper, CssHelper, SizeHelper, SpacingHelper, TypographyHelper } from "../../Helpers";
import { IconName, PaddingProps, ScalableElementProps } from "../../Interfaces";
import { Corners, Padding } from "../Decorator";
import { HoverButton, HoverButtonContext } from "../Input/HoverButton";
import { Icon } from "../Surface/Icon";
import { Text } from "../Typography";
import { Container } from "./Container";
import { HStack } from "./HStack";
import { VStack } from "./VStack";

interface AccordionItemProps {
    children?: React.ReactNode;
    value: string;
    disabled?: boolean;
}

function AccordionItem(_props: AccordionItemProps) {
    return undefined;
}

interface AccordionHeaderProps extends PaddingProps {
    children?: React.ReactNode | string;
    icon?: IconName;
    text?: string;
}

function AccordionHeader(_props: AccordionHeaderProps) {
    return undefined;
}

interface AccordionContentProps extends PaddingProps {
    children?: React.ReactNode;
    text?: string;
}

function AccordionContent(_props: AccordionContentProps) {
    return undefined;
}

interface AccordionBaseProps extends ScalableElementProps {
    children?: React.ReactNode;
    collapsible?: boolean;
    animationDuration?: number;
    autoSize?: boolean;
    keepMounted?: boolean;
    name?: string;
}

export interface AccordionProps extends AccordionBaseProps {
    multiple?: false;
    defaultValue?: string;
    value?: string;
    onValueChange?: (value: string | undefined) => void;
}

export interface AccordionMultipleProps extends AccordionBaseProps {
    multiple: true;
    defaultValue?: string[];
    value?: string[];
    onValueChange?: (value: string[]) => void;
}

interface ParsedItem {
    value: string;
    disabled: boolean;
    header: AccordionHeaderProps;
    contentProps: AccordionContentProps;
    contentText?: string;
    content?: React.ReactNode;
}

function AccordionHeaderVisual(props: {
    header: AccordionHeaderProps;
    disabled: boolean;
    duration: number;
    open: boolean;
}) {
    const theme = React.useContext(CleanThemeContext);
    const hover = React.useContext(HoverButtonContext);
    const state = props.disabled ? "disabled" : hover?.isSelected ? "focus" : hover?.hover ? "hover" : "default";
    const colors = ColorHelper.getIntentColors(theme, "primary", state, theme.components.accordion.header.intents);
    const [rotation, rotationTween] = useTween(props.open ? 180 : 0, { duration: props.duration });

    React.useEffect(() => {
        const goal = props.open ? 180 : 0;
        rotationTween.setGoal(goal, { duration: props.duration });
        if (props.duration === 0) rotationTween.setPosition(goal);
        rotationTween.start();
    }, [props.duration, props.open, rotationTween]);

    if (props.header.text === undefined && props.header.children !== undefined && !typeIs(props.header.children, "string"))
        return props.header.children;

    return (
        <>
            <Padding resolvedPadding={SpacingHelper.GetResolvedPadding(theme, props.header, theme.components.accordion.header.spacing, theme.components.accordion.header.padding)} />
            <HStack valign="Center" Wraps={false} HorizontalFlex={Enum.UIFlexAlignment.Fill}>
                {props.header.icon !== undefined && <Icon name="AccordionHeaderIcon" icon={props.header.icon} color={colors.textColor} />}
                <Container name="AccordionHeaderTextContainer" Size={new UDim2(1, theme.components.accordion.header.indicatorSize, 0, 0)} AutomaticSize={Enum.AutomaticSize.Y} >
                    {props.header.text !== undefined
                        ? <Text name="AccordionHeaderText" text={props.header.text} TextColor3={colors.textColor} typography={TypographyHelper.getTypography(theme, undefined, colors.typography ?? theme.components.accordion.header.typography)} />
                        : typeIs(props.header.children, "string")
                            ? <Text name="AccordionHeaderText" text={props.header.children} TextColor3={colors.textColor} typography={TypographyHelper.getTypography(theme, undefined, colors.typography ?? theme.components.accordion.header.typography)} />
                            : props.header.children}
                </Container>
                <Container name="AccordionChevronContainer">
                    <Icon
                        name="AccordionChevronIcon"
                        icon="chevron-down"
                        color={props.disabled ? colors.textColor : theme.components.accordion.header.indicatorColor}
                        Size={UDim2.fromOffset(theme.components.accordion.header.indicatorSize, theme.components.accordion.header.indicatorSize)}
                        AnchorPoint={new Vector2(0.5, 0.5)}
                        Rotation={rotation}
                    />
                </Container>
            </HStack>
        </>
    );
}

function toValues(value: string | string[] | undefined): string[] {
    if (value === undefined) return [];
    return typeIs(value, "string") ? [value] : value;
}

function RenderedAccordionItem(props: ParsedItem & { first: boolean; open: boolean; duration: number; keepMounted: boolean; onActivate: () => void }) {
    const theme = React.useContext(CleanThemeContext);
    const [mounted, setMounted] = React.useState(props.open);
    const [height, heightTween] = useTween(0, { duration: props.duration });
    const contentRef = React.useRef<Frame>();

    React.useEffect(() => {
        if (props.open) {
            setMounted(true);
            const content = contentRef.current;
            if (content !== undefined) {
                heightTween.setGoal(content.AbsoluteSize.Y, { duration: props.duration });
                if (props.duration === 0) heightTween.setPosition(content.AbsoluteSize.Y);
                heightTween.start();
            }
        } else {
            heightTween.setGoal(0, { duration: props.duration });
            if (props.duration === 0) heightTween.setPosition(0);
            heightTween.start();
            if (props.duration === 0) setMounted(false);
        }
    }, [props.duration, props.open, heightTween]);

    React.useEffect(() => {
        if (props.duration === 0) {
            heightTween.setPosition(heightTween.getGoal());
        }
    }, [props.duration, heightTween]);

    React.useEffect(() => heightTween.onComplete((value) => {
        if (value === 0 && !props.open) setMounted(false);
    }), [heightTween, props.open]);

    const defaultColors = ColorHelper.getIntentColors(theme, "primary", props.disabled ? "disabled" : "default", theme.components.accordion.header.intents);
    const hoverColors = ColorHelper.getIntentColors(theme, "primary", "hover", theme.components.accordion.header.intents);
    const focusColors = ColorHelper.getIntentColors(theme, "primary", "focus", theme.components.accordion.header.intents);
    const defaultBackgroundImage = CssHelper.resolveBackgroundImage(defaultColors.backgroundImage);
    const hoverBackgroundImage = CssHelper.resolveBackgroundImage(hoverColors.backgroundImage);
    const focusBackgroundImage = CssHelper.resolveBackgroundImage(focusColors.backgroundImage);

    return (
        <Container name={`AccordionItem-${props.value}`} width="100%">
            <VStack spacing="None">
                {!props.first && (
                    <frame
                        key="Divider"
                        BackgroundColor3={theme.components.accordion.borderColor}
                        BackgroundTransparency={0}
                        BorderSizePixel={0}
                        Size={UDim2.fromOffset(0, theme.components.accordion.borderThickness).add(UDim2.fromScale(1, 0))}
                    />
                )}
                <HoverButton
                    name={`AccordionHeaderButton-${props.value}`}
                    isSelected={props.open}
                    default={{
                        Active: !props.disabled && (props.content !== undefined || props.contentText !== undefined),
                        Selectable: !props.disabled && (props.content !== undefined || props.contentText !== undefined),
                        AutoButtonColor: false,
                        AutomaticSize: Enum.AutomaticSize.Y,
                        Size: UDim2.fromScale(1, 0),
                        BackgroundColor3: defaultColors.backgroundColor,
                        BackgroundTransparency: defaultColors.backgroundTransparency ?? 0,
                        BorderSizePixel: 0,
                        Image: defaultBackgroundImage.Image,
                        ImageColor3: defaultBackgroundImage.ImageColor3,
                        ImageTransparency: defaultBackgroundImage.ImageTransparency,
                        ScaleType: defaultBackgroundImage.ScaleType,
                        SliceCenter: defaultBackgroundImage.SliceCenter,
                        SliceScale: defaultBackgroundImage.SliceScale,
                        TileSize: defaultBackgroundImage.TileSize,
                        Event: { Activated: props.onActivate },
                    }}
                    hover={{
                        BackgroundColor3: hoverColors.backgroundColor,
                        BackgroundTransparency: hoverColors.backgroundTransparency ?? 0,
                        Image: hoverBackgroundImage.Image,
                        ImageColor3: hoverBackgroundImage.ImageColor3,
                        ImageTransparency: hoverBackgroundImage.ImageTransparency,
                        ScaleType: hoverBackgroundImage.ScaleType,
                        SliceCenter: hoverBackgroundImage.SliceCenter,
                        SliceScale: hoverBackgroundImage.SliceScale,
                        TileSize: hoverBackgroundImage.TileSize,
                    }}
                    focus={{
                        BackgroundColor3: focusColors.backgroundColor,
                        BackgroundTransparency: focusColors.backgroundTransparency ?? 0,
                        Image: focusBackgroundImage.Image,
                        ImageColor3: focusBackgroundImage.ImageColor3,
                        ImageTransparency: focusBackgroundImage.ImageTransparency,
                        ScaleType: focusBackgroundImage.ScaleType,
                        SliceCenter: focusBackgroundImage.SliceCenter,
                        SliceScale: focusBackgroundImage.SliceScale,
                        TileSize: focusBackgroundImage.TileSize,
                    }}
                >
                    {props.first && (
                        <uicorner
                            key="Corners"
                            TopLeftRadius={SizeHelper.toRadius(theme, theme.components.accordion.cornerRadius)}
                            TopRightRadius={SizeHelper.toRadius(theme, theme.components.accordion.cornerRadius)}
                            BottomLeftRadius={new UDim(0, 0)}
                            BottomRightRadius={new UDim(0, 0)}
                        />
                    )}
                    <AccordionHeaderVisual header={props.header} disabled={props.disabled} duration={props.duration} open={props.open} />
                </HoverButton>
                {(mounted || props.keepMounted) && (
                    <frame
                        key="ContentClip"
                        BackgroundTransparency={1}
                        BorderSizePixel={0}
                        ClipsDescendants
                        Visible={mounted}
                        Size={height.map((value) => UDim2.fromScale(1, 0).add(UDim2.fromOffset(0, value)))}
                    >
                        <frame
                            key="Content"
                            ref={contentRef}
                            BackgroundColor3={theme.components.accordion.content.backgroundColor}
                            BackgroundTransparency={theme.components.accordion.content.backgroundTransparency}
                            BorderSizePixel={0}
                            Size={UDim2.fromScale(1, 0)}
                            AutomaticSize={Enum.AutomaticSize.Y}
                            Change={{
                                AbsoluteSize: (instance) => {
                                    if (props.open) {
                                        heightTween.setGoal(instance.AbsoluteSize.Y, { duration: props.duration });
                                        if (props.duration === 0) heightTween.setPosition(instance.AbsoluteSize.Y);
                                        heightTween.start();
                                    }
                                }
                            }}
                        >
                            <Padding resolvedPadding={SpacingHelper.GetResolvedPadding(theme, props.contentProps, theme.components.accordion.content.spacing, theme.components.accordion.content.padding)} />
                            {props.contentText !== undefined
                                ? <Text name="AccordionContentText" text={props.contentText} />
                                : props.content}
                        </frame>
                    </frame>
                )}
            </VStack>
        </Container>
    );
}

type AccordionComponent = React.ForwardRefExoticComponent<(AccordionProps | AccordionMultipleProps) & React.RefAttributes<ImageLabel>> & {
    Item: typeof AccordionItem;
    Header: typeof AccordionHeader;
    Content: typeof AccordionContent;
};

const Accordion = React.forwardRef<ImageLabel, AccordionProps | AccordionMultipleProps>((props, ref) => {
    const theme = React.useContext(CleanThemeContext);
    const items = React.useMemo(() => {
        const parsed = new Array<ParsedItem>();
        const seen = new Set<string>();
        React.Children.forEach(props.children, (child) => {
            if (!React.isValidElement(child) || child.type !== AccordionItem) return;
            const item = child as React.ReactElement<AccordionItemProps>;
            if (seen.has(item.props.value)) return;
            let header: AccordionHeaderProps | undefined;
            let contentProps: AccordionContentProps | undefined;
            let contentText: string | undefined;
            let content: React.ReactNode;
            React.Children.forEach(item.props.children, (itemChild) => {
                if (!React.isValidElement(itemChild)) return;
                if (itemChild.type === AccordionHeader && header === undefined) header = itemChild.props as AccordionHeaderProps;
                if (itemChild.type === AccordionContent && content === undefined) {
                    contentProps = itemChild.props as AccordionContentProps;
                    contentText = contentProps.text;
                    content = contentProps.children;
                }
            });
            if (header !== undefined) {
                seen.add(item.props.value);
                parsed.push({ value: item.props.value, disabled: item.props.disabled ?? false, header, contentProps: contentProps ?? {}, contentText, content });
            }
        });
        return parsed;
    }, [props.children]);

    const [uncontrolled, setUncontrolled] = React.useState(() => toValues(props.defaultValue));
    const supplied = props.value !== undefined
        ? toValues(props.value)
        : uncontrolled;
    const available = new Set(items.map((item) => item.value));
    const filtered = supplied.filter((value) => available.has(value));
    const openValues = props.multiple || filtered.size() <= 1 ? filtered : [filtered[0]];

    React.useEffect(() => {
        if (props.value === undefined && (uncontrolled.size() !== openValues.size() || uncontrolled.some((value) => !available.has(value)))) {
            setUncontrolled(openValues);
        }
    }, [items, props.value]);

    const activate = (item: ParsedItem) => {
        if (item.disabled || (item.content === undefined && item.contentText === undefined)) return;
        const isOpen = openValues.includes(item.value);
        let nextValues: string[];
        if (props.multiple) {
            nextValues = items
                .map((other) => other.value)
                .filter((value) => value === item.value ? !isOpen : openValues.includes(value));
        } else if (isOpen) {
            if (!props.collapsible) return;
            nextValues = [];
        } else {
            nextValues = [item.value];
        }
        if (props.value === undefined) setUncontrolled(nextValues);
        if (props.multiple) props.onValueChange?.(nextValues);
        else props.onValueChange?.(nextValues[0]);
    };

    return (
        <Container ref={ref}
            name={props.name ?? "Accordion"}
            width="100%"
            height={props.autoSize ? undefined : "100%"}
            AutomaticSize={props.autoSize ? Enum.AutomaticSize.Y : undefined}
            ClipsDescendants
        >
            <Corners radius={theme.components.accordion.cornerRadius} />
            <uistroke key="Stroke" Color={theme.components.accordion.borderColor}
                Thickness={theme.components.accordion.borderThickness}
                BorderStrokePosition={Enum.BorderStrokePosition.Outer} />
            <VStack Padding={new UDim(0, SpacingHelper.GetPadding(theme, props.scale, theme.components.accordion.spacing))}>
                {items.map((item, index) => (
                    <RenderedAccordionItem
                        key={item.value}
                        {...item}
                        first={index === 0}
                        open={openValues.includes(item.value)}
                        duration={props.animationDuration ?? theme.components.accordion.animation.duration}
                        keepMounted={props.keepMounted ?? false}
                        onActivate={() => activate(item)}
                    />
                ))}
            </VStack>
        </Container>
    );
}) as AccordionComponent;

Accordion.Item = AccordionItem;
Accordion.Header = AccordionHeader;
Accordion.Content = AccordionContent;

export { Accordion };
