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
    // Lets an overlay Card.Header report its rendered AbsolutePosition/
    // AbsoluteSize back up to Card, so Card can reserve enough top padding
    // on the Box for the portion of the header that overlaps down into it
    // (see the "overlay clearance" comment on Card below). Undefined has no
    // effect on a non-overlay header, which never calls it.
    reportOverlayHeaderRect?: (absolutePosition: Vector2, absoluteSize: Vector2) => void;
    // Same mechanism as reportOverlayHeaderRect above, but for an overlay
    // Card.Footer — lets Card reserve enough bottom padding on the Box for
    // the portion of the footer that overlaps up into it. Undefined has no
    // effect on a non-overlay footer, which never calls it.
    reportOverlayFooterRect?: (absolutePosition: Vector2, absoluteSize: Vector2) => void;
}

const CardContext = React.createContext<CardContextValue>({});

// Resolves a theme-driven CssPosition into raw Position/AnchorPoint offsets.
// This is a one-off resolver rather than a SizeHelper addition because
// CssPosition's `center` is axis-aware (`"x"` / `"y"`) so it can express
// "center horizontally, anchor to the top with an offset" — something
// SizeHelper.GetPosition/GetAnchor can't do since they apply `center`
// identically to both axes, and that symmetric behavior is relied on
// elsewhere in the codebase so isn't something to widen here.
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

    // A theme-driven fixed/relative width (only meaningful in overlay mode,
    // see CssPosition.width) forces a fixed-width/auto-height Size, taking
    // over the caller's default Size={fromScale(0,0)}/AutomaticSize={XY} —
    // otherwise Size/AutomaticSize are left undefined so the caller's own
    // default applies unchanged. Parsed via CssHelper.parseCssSize (not
    // SizeHelper.toUDim, used for top/left/right/bottom above) since it's
    // the one that understands the "<percent>% - <px>px" calc() shape a
    // width value may use (e.g. "100% - 50px").
    //
    // When `width` isn't explicit but both `left` and `right` are set, imply
    // a width from them the same way CSS does for an absolutely-positioned
    // element: width = 100% - left - right. Explicit `width` always wins if
    // somehow both are set.
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

// Header/footer overlay mode escapes the card's VStack (a UIListLayout
// forcibly repositions every sibling it lays out, so there's no way to keep
// a custom Position/AnchorPoint on a child that stays inside it) — Card
// pulls an overlay-requesting Header/Footer out of the flow and renders it
// as an absolutely-positioned sibling of the Box instead. Overlay mode is
// requested via the instance `overlay` prop or `theme.components.card.header
// /footer.position.position === "absolute"`; when the instance sets any of
// its own Position/AnchorPoint/top/left/right/bottom/center fields, those
// win wholesale over the theme's CssPosition (mixing partial fields across
// the two differently-shaped position vocabularies isn't attempted), exactly
// mirroring the precedence the previous PositionElementProps-based
// implementation gave instance props.
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

        // Unified 4-tier padding resolution (see SpacingHelper.GetResolvedPadding):
        // `card.body.spacing` (tier 2) overrides the global spacing map per
        // scale key, falling back to it for any key it doesn't define, and
        // `card.body.padding` (tier 3) overrides the scale-based tiers
        // entirely at the active key. CardBody wraps its children in a
        // Container, not a Box, so it doesn't get Box's automatic
        // `box.padding` application for free — this resolves independently
        // against `theme.components.card.body`'s own tiers.
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

        // Overlay clearance: an overlay header (see resolveOverlayPosition)
        // is pulled out of the VStack entirely, so nothing reserves space
        // for it — its rendered box typically extends downward past its own
        // anchor point and overlaps into the top of the Box. These two
        // pieces of state capture the header's reported rect (via
        // CardContext.reportOverlayHeaderRect, set on CardHeader below) and
        // the overlay wrapper frame's own AbsolutePosition, so the amount of
        // that overlap can be measured and reserved as extra top padding on
        // the Box (see headerClearance/boxProps below). Both are undefined
        // until their first Change event fires after mount, which is the
        // same measure-then-settle characteristic Accordion.tsx accepts for
        // its own AbsoluteSize-driven measurements.
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

        // Pull out a Header/Footer that wants overlay placement so it can be
        // rendered outside the VStack below (see resolveOverlayPosition above
        // for why it can't stay inside the VStack and still be positioned).
        // Everything else renders in place, in its original order.
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

        // How far the overlay header's bottom edge extends past the
        // wrapper's (i.e. the Box's) top edge — 0 when there's no overlap
        // (e.g. a small/no theme offset) or nothing has been measured yet.
        const headerClearance = overlayHeader !== undefined && headerRect !== undefined && wrapperAbsoluteY !== undefined
            ? math.max(0, (headerRect.position.Y + headerRect.size.Y) - wrapperAbsoluteY)
            : 0;

        // Same idea, mirrored for the footer: the wrapper's bottom edge
        // (its top plus its own height) minus the footer's reported top
        // edge (AbsolutePosition is always the top-left corner regardless
        // of AnchorPoint) is how far the footer's top edge sits above the
        // Box's bottom edge, i.e. how much it overlaps upward into it.
        const wrapperBottomY = wrapperAbsoluteY !== undefined && wrapperAbsoluteSize !== undefined
            ? wrapperAbsoluteY + wrapperAbsoluteSize.Y
            : undefined;

        const footerClearance = overlayFooter !== undefined && footerRect !== undefined && wrapperBottomY !== undefined
            ? math.max(0, wrapperBottomY - footerRect.position.Y)
            : 0;

        // The Box below now sits inside an extra positioning frame (see
        // boxWithOverlay), so its own Position/AnchorPoint/ZIndex/LayoutOrder
        // are cleared here to avoid double-applying them — the wrapper frame
        // owns those instead.
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

        // When there's no footer at all, footerClearance is always 0 (there's
        // nothing to measure an overlap against), so fall back to the Box's
        // own explicit theme.components.box.padding bottom inset — if the
        // theme sets one — as a floor instead. This keeps content clear of a
        // themed Box's decorative border image (e.g. wooden's wood-frame art,
        // which needs a real bottom inset) even when there's no footer to
        // reserve that space via measured overlap. Themes that don't set an
        // explicit box padding (GetExplicitPadding returns undefined) resolve
        // this floor to 0, so behavior there is unchanged. When a footer IS
        // present, footerClearance (its real measured overlap) is used as-is
        // exactly as before — this floor never applies then, since the
        // footer's own overlap already reserves whatever space it needs.
        const explicitBoxBottomFloor = overlayFooter === undefined
            ? SpacingHelper.GetExplicitPadding(theme.components.box.padding, theme.default.spacing)?.bottom ?? 0
            : 0;

        // When an overlay header and/or footer measurably overlaps into the
        // Box (headerClearance/footerClearance > 0), or the footer-absent
        // floor above is nonzero, reserve that much extra top/bottom padding
        // via resolvedPadding — this takes over Box's own outer padding,
        // which is otherwise 0/0/0/0 since Card always forces spacing="None"
        // on Box below.
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

        // ClipsDescendants is off so an overlay header/footer can protrude
        // past the Box's own edges (e.g. a plaque mounted above the top
        // border). This frame takes over the Position/AnchorPoint the Box
        // would otherwise have used, and auto-sizes to hug the Box (plus
        // whatever the overlay siblings protrude by).
        //
        // `center` is stripped before deriving Position/AnchorPoint here,
        // the same way `cardBox`'s Box always gets `center={undefined}`:
        // when `center` is set, centering is handled by the outer
        // `isCentered` wrapper below (a UIListLayout that centers this
        // whole frame), not by this frame's own Position/AnchorPoint. If
        // both applied `center` at once, the UIListLayout would place the
        // frame using an (0,0)-anchor assumption while the frame itself
        // reported a (0.5,0.5) AnchorPoint, offsetting it by half its own
        // size and letting its (ClipsDescendants=false) contents spill out.
        // Explicit top/left/right/bottom/Position/AnchorPoint overrides are
        // unaffected and still apply directly to this frame.
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
