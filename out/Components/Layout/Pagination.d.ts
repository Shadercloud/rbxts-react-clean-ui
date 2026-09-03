import React from "@rbxts/react";
import { PaddingProps } from "../../Interfaces";
export interface PaginationItemProps extends PaddingProps {
    value: number;
    layoutOrder?: number;
}
declare function PaginationItem(props: PaginationItemProps): React.JSX.Element;
declare function PaginationPrev(): React.JSX.Element;
declare function PaginationNext(): React.JSX.Element;
declare function PaginationEllipsis(props: {
    layoutOrder?: number;
}): React.JSX.Element;
export interface PaginationListProps {
    children?: React.ReactNode;
}
declare function PaginationList(props: PaginationListProps): React.JSX.Element;
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
declare const Pagination: PaginationComponent;
export { Pagination };
