import React from "@rbxts/react";
import { Box, BoxProps } from "./Box";
import { Container, FlexItem, VStack } from "../Layout";
import { ColorHelper, CssHelper, SizeHelper, SpacingHelper } from "../../Helpers";
import { CleanThemeContext } from "../../Contexts";
import { Padding } from "../Decorator";
import { CssPadding, Intent, IntentElementProps, PaddingProps, PositionElementProps, ResolvedPadding, SizeElementProps, SpacedElementProps, ZIndexElementProps } from "../../Interfaces";
import { CssPosition } from "../../Theme";


interface CardContextValue {
    intent?: Intent;
    reportOverlayHeaderRect?: (absolutePosition: Vector2, absoluteSize: Vector2) => void;
    reportOverlayFooterRect?: (absolutePosition: Vector2, absoluteSize: Vector2) => void;
}

const CardContext = React.createContext<CardContextValue>({});

function resolveCssPositionOffset(position: CssPosition): { Position: UDim2; AnchorPoint: Vector2; ZIndex?: number; Size?: UDim2; AutomaticSize?: Enum.AutomaticSize } {
    const centerX = position.center === true || position.center === "x";
    const centerY = position.center === true || position.center === "y";

    const anchorX = centerX ? 0.5 : (position.left === undefined && position.right !== undefined ? 1 : 0);
    const anchorY = centerY ? 0.5 : (position.top === undefined && position.bottom !== undefined ? 1 : 0);

    const posX = centerX
        ? new UDim(0.5, 0)
        : position.left !== undefined
            ? SizeHelper.toUDim(position.left)
            : position.right !== undefined
                ? new UDim(1 - SizeHelper.toUDim(position.right).Scale, -SizeHelper.toUDim(position.right).Offset)
                : new UDim(0, 0);

    const posY = centerY
        ? new UDim(0.5, 0)
        : position.top !== undefined
            ? SizeHelper.toUDim(position.top)
            : position.bottom !== undefined
                ? new UDim(1 - SizeHelper.toUDim(position.bottom).Scale, -SizeHelper.toUDim(position.bottom).Offset)
                : new UDim(0, 0);

    const impliedWidth = position.width === undefined && position.left !== undefined && position.right !== undefined
        ? (() => {
            const leftUDim = SizeHelper.toUDim(position.left);
            const rightUDim = SizeHelper.toUDim(position.right);
            return new UDim(1 - leftUDim.Scale - rightUDim.Scale, -leftUDim.Offset - rightUDim.Offset);
        })()
        : undefined;

    const sizeOverride = position.width !== undefined
        ? { Size: new UDim2(CssHelper.parseCssSize(position.width), new UDim(0, 0)), AutomaticSize: Enum.AutomaticSize.Y }
        : impliedWidth !== undefined
            ? { Size: new UDim2(impliedWidth, new UDim(0, 0)), AutomaticSize: Enum.AutomaticSize.Y }
            : {};

    return {
        Position: new UDim2(posX, posY),
        AnchorPoint: new Vector2(anchorX, anchorY),
        ZIndex: position.zIndex,
        ...sizeOverride,
    };
}

function resolveOverlayPosition(
    props: PositionElementProps & ZIndexElementProps & { overlay?: boolean },
    themePosition: CssPosition | undefined,
): { overlay: boolean; positionProps: PositionElementProps & ZIndexElementProps & Pick<SizeElementProps, "Size" | "AutomaticSize"> } {
    const overlay = props.overlay ?? (themePosition?.position === "absolute");

    if (!overlay) {
        return { overlay, positionProps: {} };
    }

    const hasInstancePosition =
        props.Position !== undefined ||
        props.AnchorPoint !== undefined ||
        props.top !== undefined ||
        props.left !== undefined ||
        props.right !== undefined ||
        props.bottom !== undefined ||
        props.center !== undefined;

    if (hasInstancePosition) {
        return {
            overlay,
            positionProps: {
                Position: SizeHelper.GetPosition(props),
                AnchorPoint: SizeHelper.GetAnchor(props),
                ZIndex: props.ZIndex ?? themePosition?.zIndex ?? 2,
            },
        };
    }

    if (themePosition !== undefined) {
        const resolved = resolveCssPositionOffset(themePosition);
        return {
            overlay,
            positionProps: {
                Position: resolved.Position,
                AnchorPoint: resolved.AnchorPoint,
                ZIndex: props.ZIndex ?? resolved.ZIndex ?? 2,
                Size: resolved.Size,
                AutomaticSize: resolved.AutomaticSize,
            },
        };
    }

    return {
        overlay,
        positionProps: {
            ZIndex: props.ZIndex ?? 2,
        },
    };
}

interface CardHeaderProps extends IntentElementProps, PositionElementProps, ZIndexElementProps, SpacedElementProps {
    children?: React.ReactNode;
    overlay?: boolean;
    padding?: CssPadding;
    resolvedPadding?: ResolvedPadding;
}

export const CardHeader = React.forwardRef<ImageLabel, CardHeaderProps>(
    (props, ref) => {
        const theme = React.useContext(CleanThemeContext);
        const card = React.useContext(CardContext);
        const intent = ColorHelper.getIntentColors(theme, props.intent ?? card.intent ?? "primary", "default", theme.components.card.header.intents);
        const padding = SpacingHelper.GetResolvedPadding(theme, props as PaddingProps, theme.components.card.header.spacing, theme.components.card.header.padding, "md");
        const corners = CssHelper.parseCssSize(theme.components.card.cornerRadius);
        const { overlay, positionProps } = resolveOverlayPosition(props, theme.components.card.header.position);
        return <Container
            name="CardHeader"
            ref={ref}
            {...props}
            {...positionProps}
            Size={positionProps.Size ?? UDim2.fromScale(0, 0)}
            AutomaticSize={positionProps.AutomaticSize ?? Enum.AutomaticSize.XY}
            BackgroundTransparency={intent.backgroundTransparency}
            BackgroundColor3={intent.backgroundColor}
            BorderSizePixel={0}
            backgroundImage={intent.backgroundImage}
            backgroundGradient={intent.backgroundGradient}
            Change={overlay && card.reportOverlayHeaderRect !== undefined ? {
                AbsolutePosition: (instance) => card.reportOverlayHeaderRect!(instance.AbsolutePosition, instance.AbsoluteSize),
                AbsoluteSize: (instance) => card.reportOverlayHeaderRect!(instance.AbsolutePosition, instance.AbsoluteSize),
            } : undefined}
        >
            <Padding resolvedPadding={padding} />
            <uistroke key="Stroke" Thickness={theme.components.card.header.borderThickness ?? theme.components.card.borderThickness} Color={intent.borderColor} BorderStrokePosition={Enum.BorderStrokePosition.Inner} />
            <uicorner key="Corners" TopLeftRadius={corners} TopRightRadius={corners} BottomLeftRadius={new UDim(0, 0)} BottomRightRadius={new UDim(0, 0)} />
            {props.children}
        </Container>
    });
interface CardBodyProps extends BoxProps {

}

export const CardBody = React.forwardRef<ImageLabel, CardBodyProps>(
    (props, ref) => {
        const theme = React.useContext(CleanThemeContext);

        const paddingSourceProps = props as PaddingProps;

        return <FlexItem>
            <Container
                name="CardBody"
                ref={ref}
                Size={SizeHelper.GetSize(props, UDim2.fromScale(0, 0))}
                {...props}
                AutomaticSize={Enum.AutomaticSize.XY}>
                <Padding resolvedPadding={SpacingHelper.GetResolvedPadding(theme, paddingSourceProps, theme.components.card.body?.spacing, theme.components.card.body?.padding)} />
                {props.children}
            </Container>
        </FlexItem>
    });

interface CardFooterProps extends BoxProps, IntentElementProps {
    overlay?: boolean;
    padding?: CssPadding;
    resolvedPadding?: ResolvedPadding;
}

export const CardFooter = React.forwardRef<ImageLabel, CardFooterProps>(
    (props, ref) => {
        const theme = React.useContext(CleanThemeContext);
        const card = React.useContext(CardContext);
        const intent = ColorHelper.getIntentColors(theme, props.intent ?? card.intent ?? "primary", "default", theme.components.card.footer.intents);
        const padding = SpacingHelper.GetResolvedPadding(theme, props as PaddingProps, theme.components.card.footer.spacing, theme.components.card.footer.padding, "md");
        const corners = CssHelper.parseCssSize(theme.components.card.cornerRadius);
        const { overlay, positionProps } = resolveOverlayPosition(props, theme.components.card.footer.position);
        return <Container
            name="CardFooter"
            ref={ref}
            {...props}
            {...positionProps}
            Size={positionProps.Size ?? UDim2.fromScale(0, 0)}
            AutomaticSize={positionProps.AutomaticSize ?? Enum.AutomaticSize.XY}
            BackgroundTransparency={intent.backgroundTransparency}
            BackgroundColor3={intent.backgroundColor}
            BorderSizePixel={0}
            backgroundImage={intent.backgroundImage}
            backgroundGradient={intent.backgroundGradient}
            Change={overlay && card.reportOverlayFooterRect !== undefined ? {
                AbsolutePosition: (instance) => card.reportOverlayFooterRect!(instance.AbsolutePosition, instance.AbsoluteSize),
                AbsoluteSize: (instance) => card.reportOverlayFooterRect!(instance.AbsolutePosition, instance.AbsoluteSize),
            } : undefined}
        >
            <Padding resolvedPadding={padding} />
            <uistroke key="Stroke" Thickness={theme.components.card.footer.borderThickness ?? theme.components.card.borderThickness} Color={intent.borderColor} BorderStrokePosition={Enum.BorderStrokePosition.Inner} />
            <uicorner key="Corners" TopLeftRadius={new UDim(0, 0)} TopRightRadius={new UDim(0, 0)} BottomLeftRadius={corners} BottomRightRadius={corners} />
            {props.children}
        </Container>
    });

interface CardProps extends BoxProps, IntentElementProps {

}


type CardComponent = React.ForwardRefExoticComponent<
    CardProps & React.RefAttributes<ImageLabel>
> & {
    Header: typeof CardHeader;
    Footer: typeof CardFooter;
    Body: typeof CardBody;
    name?: string;
};

const Card = React.forwardRef<ImageLabel, CardProps>(
    (props, ref) => {

        const theme = React.useContext(CleanThemeContext);

        const [headerRect, setHeaderRect] = React.useState<{ position: Vector2; size: Vector2 } | undefined>();
        const [footerRect, setFooterRect] = React.useState<{ position: Vector2; size: Vector2 } | undefined>();
        const [wrapperAbsoluteY, setWrapperAbsoluteY] = React.useState<number | undefined>();
        const [wrapperAbsoluteSize, setWrapperAbsoluteSize] = React.useState<Vector2 | undefined>();
        const overlayWrapperRef = React.useRef<Frame>();

        const reportOverlayHeaderRect = React.useCallback((position: Vector2, size: Vector2) => {
            setHeaderRect({ position, size });
        }, []);

        const reportOverlayFooterRect = React.useCallback((position: Vector2, size: Vector2) => {
            setFooterRect({ position, size });
        }, []);

        const contextValue = React.useMemo<CardContextValue>(
            () => ({
                intent: props.intent,
                reportOverlayHeaderRect,
                reportOverlayFooterRect,
            }),
            [props.intent, reportOverlayHeaderRect, reportOverlayFooterRect],
        );

        const intent = ColorHelper.getIntentColors(theme, props.intent ?? "primary", "default", theme.components.card.header.intents);

        const { flowChildren, overlayHeader, overlayFooter } = React.useMemo(() => {
            const flow: Exclude<React.ReactNode, undefined>[] = [];
            let header: React.ReactNode;
            let footer: React.ReactElement<CardFooterProps> | undefined;
            React.Children.forEach(props.children, (child) => {
                if (child === undefined) return;
                const directHeader = React.isValidElement(child) && child.type === CardHeader
                    ? child as React.ReactElement<CardHeaderProps>
                    : undefined;
                const wrappedChild = React.isValidElement(child)
                    ? (child.props as { children?: React.ReactNode }).children
                    : undefined;
                const wrappedHeader = React.isValidElement(wrappedChild) && wrappedChild.type === CardHeader
                    ? wrappedChild as React.ReactElement<CardHeaderProps>
                    : undefined;
                const headerElement = directHeader ?? wrappedHeader;

                if (headerElement !== undefined && header === undefined) {
                    if (headerElement.props.overlay ?? (theme.components.card.header.position?.position === "absolute")) {
                        header = child;
                        return;
                    }
                }
                if (React.isValidElement(child) && child.type === CardFooter && footer === undefined) {
                    const footerElement = child as React.ReactElement<CardFooterProps>;
                    if (footerElement.props.overlay ?? (theme.components.card.footer.position?.position === "absolute")) {
                        footer = footerElement;
                        return;
                    }
                }
                flow.push(child);
            });
            return { flowChildren: flow, overlayHeader: header, overlayFooter: footer };
        }, [props.children, theme]);

        const hasOverlay = overlayHeader !== undefined || overlayFooter !== undefined;

        const headerClearance = overlayHeader !== undefined && headerRect !== undefined && wrapperAbsoluteY !== undefined
            ? math.max(0, (headerRect.position.Y + headerRect.size.Y) - wrapperAbsoluteY)
            : 0;

        const wrapperBottomY = wrapperAbsoluteY !== undefined && wrapperAbsoluteSize !== undefined
            ? wrapperAbsoluteY + wrapperAbsoluteSize.Y
            : undefined;

        const footerClearance = overlayFooter !== undefined && footerRect !== undefined && wrapperBottomY !== undefined
            ? math.max(0, wrapperBottomY - footerRect.position.Y)
            : 0;

        const boxProps: CardProps = hasOverlay
            ? {
                ...props,
                Position: undefined,
                AnchorPoint: undefined,
                top: undefined,
                left: undefined,
                right: undefined,
                bottom: undefined,
                ZIndex: undefined,
                LayoutOrder: undefined,
            }
            : props;

        const explicitBoxBottomFloor = overlayFooter === undefined
            ? SpacingHelper.GetExplicitPadding(theme.components.box.padding, theme.default.spacing)?.bottom ?? 0
            : 0;

        const boxPropsWithOverlayClearance = headerClearance > 0 || footerClearance > 0 || explicitBoxBottomFloor > 0
            ? { ...boxProps, resolvedPadding: { top: headerClearance, bottom: math.max(footerClearance, explicitBoxBottomFloor), left: 0, right: 0 } as ResolvedPadding }
            : boxProps;

        const cardBox = (
            <Box {...boxPropsWithOverlayClearance}
                name={props.name ?? "Card"}
                ref={ref}
                center={undefined}
                spacing="None"
                border-color={intent.borderColor}>
                <VStack spacing="None">
                    {flowChildren}
                </VStack>
            </Box>
        );

        const wrapperPositionProps: PositionElementProps = { ...props, center: undefined };

        const boxWithOverlay = hasOverlay ? (
            <frame
                key={props.name ?? "CardOverlayWrapper"}
                ref={overlayWrapperRef}
                BackgroundTransparency={1}
                ClipsDescendants={false}
                Size={SizeHelper.GetSize(props, UDim2.fromScale(1, 1))}
                AutomaticSize={SizeHelper.GetAutoSize(props)}
                Position={SizeHelper.GetPosition(wrapperPositionProps)}
                AnchorPoint={SizeHelper.GetAnchor(wrapperPositionProps)}
                ZIndex={props.ZIndex}
                LayoutOrder={props.LayoutOrder}
                Change={{
                    AbsolutePosition: (instance) => setWrapperAbsoluteY(instance.AbsolutePosition.Y),
                    AbsoluteSize: (instance) => setWrapperAbsoluteSize(instance.AbsoluteSize),
                }}
            >
                {cardBox}
                {overlayHeader}
                {overlayFooter}
            </frame>
        ) : cardBox;

        const isCentered = props.center === true
            && props.Position === undefined
            && props.AnchorPoint === undefined;

        return (
            <CardContext.Provider value={contextValue}>
                {isCentered ? (
                    <Container name="CardCenterWrapper" Size={UDim2.fromScale(1, 1)} ZIndex={props.ZIndex} LayoutOrder={props.LayoutOrder}>
                        <uilistlayout
                            key="CenterLayout"
                            FillDirection={Enum.FillDirection.Horizontal}
                            HorizontalAlignment={Enum.HorizontalAlignment.Center}
                            VerticalAlignment={Enum.VerticalAlignment.Center}
                        />
                        {boxWithOverlay}
                    </Container>
                ) : boxWithOverlay}
            </CardContext.Provider>
        );
    }) as CardComponent;

Card.Header = CardHeader;
Card.Footer = CardFooter;
Card.Body = CardBody;

export { Card };
