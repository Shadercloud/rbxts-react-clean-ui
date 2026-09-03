import React from "@rbxts/react";
import { CleanThemeContext } from "../../Contexts";
import { ColorHelper, CssHelper, SpacingHelper, TypographyHelper } from "../../Helpers";
import { PaddingProps } from "../../Interfaces";
import { BoxShadow, Corners, Padding } from "../Decorator";
import { HoverButton, HoverButtonContext } from "../Input/HoverButton";
import { Icon } from "../Surface/Icon";
import { Text } from "../Typography";
import { Container } from "./Container";
import { HStack } from "./HStack";

type PaginationItemValue = number | "ellipsis";

function computePaginationItems(page: number, totalPages: number, siblingCount: number): PaginationItemValue[] {
    const pageCount = math.max(0, math.floor(totalPages));
    if (pageCount === 0) return [];

    const currentPage = math.clamp(math.floor(page), 1, pageCount);
    const siblings = math.max(0, math.floor(siblingCount));
    const visiblePageCount = siblings * 2 + 5;

    if (pageCount <= visiblePageCount) {
        const allPages: PaginationItemValue[] = [];
        for (let value = 1; value <= pageCount; value++) allPages.push(value);
        return allPages;
    }

    const leftSiblingIndex = math.max(currentPage - siblings, 1);
    const rightSiblingIndex = math.min(currentPage + siblings, pageCount);
    const showLeftEllipsis = leftSiblingIndex > 2;
    const showRightEllipsis = rightSiblingIndex < pageCount - 1;

    if (!showLeftEllipsis && showRightEllipsis) {
        // Near the start: no left ellipsis needed, so extend the leading run of
        // numbers to keep the total item count constant.
        const leftItemCount = siblings * 2 + 3;
        const items: PaginationItemValue[] = [];
        for (let value = 1; value <= leftItemCount; value++) items.push(value);
        items.push("ellipsis");
        items.push(pageCount);
        return items;
    }

    if (showLeftEllipsis && !showRightEllipsis) {
        // Near the end: no right ellipsis needed, so extend the trailing run of
        // numbers to keep the total item count constant.
        const rightItemCount = siblings * 2 + 3;
        const items: PaginationItemValue[] = [1, "ellipsis"];
        for (let value = pageCount - rightItemCount + 1; value <= pageCount; value++) items.push(value);
        return items;
    }

    // Both ellipses shown (the normal middle case) — unchanged from before.
    const items: PaginationItemValue[] = [1, "ellipsis"];
    for (let value = leftSiblingIndex; value <= rightSiblingIndex; value++) items.push(value);
    items.push("ellipsis");
    items.push(pageCount);
    return items;
}

interface PaginationContextValue {
    page: number;
    totalPages: number;
    items: PaginationItemValue[];
    setPage: (page: number) => void;
    canGoPrev: boolean;
    canGoNext: boolean;
}

const PaginationContext = React.createContext<PaginationContextValue | undefined>(undefined);

function usePagination() {
    const context = React.useContext(PaginationContext);
    if (context === undefined) error("Pagination subparts must be rendered inside Pagination");
    return context;
}

interface PaginationItemVisualProps extends PaddingProps {
    text?: string;
    icon?: "chevron-left" | "chevron-right";
    disabled?: boolean;
}

function PaginationItemVisual(props: PaginationItemVisualProps) {
    const theme = React.useContext(CleanThemeContext);
    const hover = React.useContext(HoverButtonContext);
    const colors = ColorHelper.getIntentColors(
        theme,
        "primary",
        props.disabled ? "disabled" : hover?.isSelected ? "focus" : hover?.hover ? "hover" : "default",
        theme.components.pagination.item.intents,
    );

    return (
        <>
            <Corners radius={theme.components.pagination.item.cornerRadius} />
            <Padding
                resolvedPadding={SpacingHelper.GetResolvedPadding(
                    theme,
                    props,
                    theme.components.pagination.item.spacing,
                    theme.components.pagination.item.padding,
                )}
            />
            <BoxShadow value={colors.boxShadow ?? theme.components.pagination.item.boxShadow} />
            {props.text !== undefined ? (
                <Text
                    name="PaginationItemText"
                    text={props.text}
                    TextColor3={colors.textColor}
                    typography={TypographyHelper.getTypography(
                        theme,
                        undefined,
                        colors.typography ?? theme.components.pagination.item.typography,
                    )}
                />
            ) : (
                <Container name="PaginationIconContainer">
                    <Icon name="PaginationIcon" icon={props.icon} color={colors.textColor} />
                </Container>
            )}
        </>
    );
}

function getButtonState(theme: React.ContextType<typeof CleanThemeContext>) {
    const itemTheme = theme.components.pagination.item;
    const defaultColors = ColorHelper.getIntentColors(theme, "primary", "default", itemTheme.intents);
    const hoverColors = ColorHelper.getIntentColors(theme, "primary", "hover", itemTheme.intents);
    const focusColors = ColorHelper.getIntentColors(theme, "primary", "focus", itemTheme.intents);
    const disabledColors = ColorHelper.getIntentColors(theme, "primary", "disabled", itemTheme.intents);

    return {
        defaultColors,
        hoverColors,
        focusColors,
        disabledColors,
        defaultImage: CssHelper.resolveBackgroundImage(defaultColors.backgroundImage),
        hoverImage: CssHelper.resolveBackgroundImage(hoverColors.backgroundImage),
        focusImage: CssHelper.resolveBackgroundImage(focusColors.backgroundImage),
    };
}

function PaginationButton(props: {
    selected?: boolean;
    disabled?: boolean;
    name: string;
    layoutOrder?: number;
    onActivate: () => void;
    children: React.ReactNode;
}) {
    const theme = React.useContext(CleanThemeContext);
    const state = getButtonState(theme);

    return (
        <HoverButton
            name={props.name}
            isSelected={props.selected}
            default={{
                Active: !props.disabled,
                Selectable: !props.disabled,
                LayoutOrder: props.layoutOrder,
                Size: UDim2.fromScale(0, 0),
                AutomaticSize: Enum.AutomaticSize.XY,
                BackgroundColor3: props.disabled
                    ? state.disabledColors.backgroundColor
                    : state.defaultColors.backgroundColor,
                BackgroundTransparency: props.disabled
                    ? state.disabledColors.backgroundTransparency
                    : state.defaultColors.backgroundTransparency,
                BorderSizePixel: theme.components.pagination.item.borderThickness,
                BorderColor3: props.disabled ? state.disabledColors.borderColor : state.defaultColors.borderColor,
                AutoButtonColor: false,
                Image: state.defaultImage.Image,
                ImageColor3: state.defaultImage.ImageColor3,
                ImageTransparency: props.disabled ? 0.7 : state.defaultImage.ImageTransparency,
                ScaleType: state.defaultImage.ScaleType,
                SliceCenter: state.defaultImage.SliceCenter,
                SliceScale: state.defaultImage.SliceScale,
                TileSize: state.defaultImage.TileSize,
                Event: {
                    Activated: () => {
                        if (!props.disabled) props.onActivate();
                    },
                },
            }}
            hover={
                props.disabled
                    ? undefined
                    : {
                          BackgroundColor3: state.hoverColors.backgroundColor,
                          BackgroundTransparency: state.hoverColors.backgroundTransparency,
                          BorderColor3: state.hoverColors.borderColor,
                          Image: state.hoverImage.Image,
                          ImageColor3: state.hoverImage.ImageColor3,
                          ImageTransparency: state.hoverImage.ImageTransparency,
                          ScaleType: state.hoverImage.ScaleType,
                          SliceCenter: state.hoverImage.SliceCenter,
                          SliceScale: state.hoverImage.SliceScale,
                          TileSize: state.hoverImage.TileSize,
                      }
            }
            focus={{
                BackgroundColor3: state.focusColors.backgroundColor,
                BackgroundTransparency: state.focusColors.backgroundTransparency,
                BorderColor3: state.focusColors.borderColor,
                Image: state.focusImage.Image,
                ImageColor3: state.focusImage.ImageColor3,
                ImageTransparency: state.focusImage.ImageTransparency,
                ScaleType: state.focusImage.ScaleType,
                SliceCenter: state.focusImage.SliceCenter,
                SliceScale: state.focusImage.SliceScale,
                TileSize: state.focusImage.TileSize,
            }}
        >
            {props.children}
        </HoverButton>
    );
}

export interface PaginationItemProps extends PaddingProps {
    value: number;
    layoutOrder?: number;
}

function PaginationItem(props: PaginationItemProps) {
    const { page, setPage } = usePagination();
    return (
        <PaginationButton
            name={`PaginationItem-${props.value}`}
            selected={page === props.value}
            layoutOrder={props.layoutOrder}
            onActivate={() => setPage(props.value)}
        >
            <PaginationItemVisual {...props} text={`${props.value}`} />
        </PaginationButton>
    );
}

function PaginationPrev() {
    const { page, setPage, canGoPrev } = usePagination();
    return (
        <PaginationButton name="PaginationPrev" disabled={!canGoPrev} onActivate={() => setPage(page - 1)}>
            <PaginationItemVisual icon="chevron-left" disabled={!canGoPrev} />
        </PaginationButton>
    );
}

function PaginationNext() {
    const { page, setPage, canGoNext } = usePagination();
    return (
        <PaginationButton name="PaginationNext" disabled={!canGoNext} onActivate={() => setPage(page + 1)}>
            <PaginationItemVisual icon="chevron-right" disabled={!canGoNext} />
        </PaginationButton>
    );
}

function PaginationEllipsis(props: { layoutOrder?: number }) {
    const theme = React.useContext(CleanThemeContext);
    return (
        <Text
            name="PaginationEllipsis"
            text="…"
            LayoutOrder={props.layoutOrder}
            typography={TypographyHelper.getTypography(theme, undefined, theme.components.pagination.item.typography)}
        />
    );
}

export interface PaginationListProps {
    children?: React.ReactNode;
}

function PaginationList(props: PaginationListProps) {
    const { items } = usePagination();
    return (
        <Container name="PaginationList">
            <HStack Wraps={false} valign="Center">
                {props.children ??
                    items.map((item, index) =>
                        item === "ellipsis" ? (
                            <PaginationEllipsis key={`ellipsis-${index}`} layoutOrder={index} />
                        ) : (
                            <PaginationItem key={item} value={item} layoutOrder={index} />
                        ),
                    )}
            </HStack>
        </Container>
    );
}

function PaginationDefaultLayout() {
    const theme = React.useContext(CleanThemeContext);
    const paginationTheme = theme.components.pagination;
    return (
        <HStack
            Wraps={false}
            valign="Center"
            spacing="None"
            Padding={new UDim(0, SpacingHelper.GetPadding(theme, undefined, paginationTheme.spacing))}
        >
            <PaginationPrev />
            <PaginationList />
            <PaginationNext />
        </HStack>
    );
}

export interface PaginationProps {
    page: number;
    totalPages: number;
    siblingCount?: number;
    onPageChange: (page: number) => void;
    children?: React.ReactNode;
}

type PaginationComponent = React.ForwardRefExoticComponent<PaginationProps & React.RefAttributes<Frame>> & {
    Prev: typeof PaginationPrev;
    Next: typeof PaginationNext;
    Item: typeof PaginationItem;
    Ellipsis: typeof PaginationEllipsis;
    List: typeof PaginationList;
};

const Pagination = React.forwardRef<Frame, PaginationProps>((props, _ref) => {
    const theme = React.useContext(CleanThemeContext);
    const pageCount = math.max(0, math.floor(props.totalPages));
    const currentPage = pageCount === 0 ? 0 : math.clamp(math.floor(props.page), 1, pageCount);
    const siblingCount = math.max(0, math.floor(props.siblingCount ?? 1));
    const items = React.useMemo(
        () => computePaginationItems(currentPage, pageCount, siblingCount),
        [currentPage, pageCount, siblingCount],
    );
    const setPage = (page: number) => {
        if (pageCount === 0) return;
        props.onPageChange(math.clamp(math.floor(page), 1, pageCount));
    };
    const contextValue = React.useMemo<PaginationContextValue>(
        () => ({
            page: currentPage,
            totalPages: pageCount,
            items,
            setPage,
            canGoPrev: currentPage > 1,
            canGoNext: currentPage < pageCount,
        }),
        [currentPage, pageCount, items, props.onPageChange],
    );
    const paginationTheme = theme.components.pagination;

    return (
        <PaginationContext.Provider value={contextValue}>
            <Container
                name="Pagination"
                BackgroundColor3={paginationTheme.backgroundColor}
                BackgroundTransparency={paginationTheme.backgroundTransparency}
                BorderSizePixel={0}
            >
                <uistroke
                    key="PaginationBorder"
                    Thickness={paginationTheme.borderThickness}
                    BorderStrokePosition={Enum.BorderStrokePosition.Inner}
                    Color={paginationTheme.borderColor}
                />
                <Corners radius={paginationTheme.cornerRadius} />
                <Padding
                    resolvedPadding={SpacingHelper.GetResolvedPadding(
                        theme,
                        {},
                        paginationTheme.spacing,
                        paginationTheme.padding,
                    )}
                />
                {props.children !== undefined ? props.children : <PaginationDefaultLayout />}
            </Container>
        </PaginationContext.Provider>
    );
}) as PaginationComponent;

Pagination.Prev = PaginationPrev;
Pagination.Next = PaginationNext;
Pagination.Item = PaginationItem;
Pagination.Ellipsis = PaginationEllipsis;
Pagination.List = PaginationList;

export { Pagination };
