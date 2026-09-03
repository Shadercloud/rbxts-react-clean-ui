import React from "@rbxts/react";
import { PaddingProps, ScalableElementProps, SizeElementProps } from "../../Interfaces";
export interface TableProps extends ScalableElementProps, SizeElementProps {
    children?: React.ReactNode;
    name?: string;
}
export interface TableSectionProps {
    children?: React.ReactNode;
}
export interface TableRowProps {
    children?: React.ReactNode;
}
export interface TableCellProps extends PaddingProps {
    children?: React.ReactNode | string;
    text?: string;
    align?: Enum.HorizontalAlignment | "Left" | "Center" | "Right";
}
declare function TableHeader(props: TableSectionProps): React.JSX.Element;
declare function TableBody(props: TableSectionProps): React.JSX.Element;
declare function TableRow(props: TableRowProps): React.JSX.Element;
declare function TableHead(props: TableCellProps): React.JSX.Element;
declare function TableCell(props: TableCellProps): React.JSX.Element;
type TableComponent = React.ForwardRefExoticComponent<TableProps & React.RefAttributes<ImageLabel>> & {
    Header: typeof TableHeader;
    Body: typeof TableBody;
    Row: typeof TableRow;
    Head: typeof TableHead;
    Cell: typeof TableCell;
};
declare const Table: TableComponent;
export { Table };
