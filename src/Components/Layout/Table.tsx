import React from "@rbxts/react";
import { CleanThemeContext } from "../../Contexts";
import { SizeHelper, SpacingHelper, TypographyHelper } from "../../Helpers";
import { PaddingProps, ScalableElementProps, ScaleSize, SizeElementProps } from "../../Interfaces";
import { Corners, Padding } from "../Decorator";
import { Text } from "../Typography";
import { Container } from "./Container";
import { HStack } from "./HStack";
import { VStack } from "./VStack";

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

interface TableLayoutContextValue {
	autoWidth: boolean;
	columnWidths: ReadonlyMap<number, number>;
	totalWidth: number;
	reportWidth: (id: number, columnIndex: number, width: number) => void;
	removeWidth: (id: number) => void;
}

const TableSectionContext = React.createContext<"header" | "body" | undefined>(undefined);
const TableScaleContext = React.createContext<ScaleSize | undefined>(undefined);
const TableLayoutContext = React.createContext<TableLayoutContextValue | undefined>(undefined);
const TableColumnContext = React.createContext(0);

let nextTableCellId = 0;

function TableHeader(props: TableSectionProps) {
	const theme = React.useContext(CleanThemeContext);
	const layout = React.useContext(TableLayoutContext);
	const autoSectionWidth = layout?.autoWidth === true ? layout.totalWidth : undefined;

	return (
		<TableSectionContext.Provider value="header">
			<Container
				name="TableHeader"
				Size={autoSectionWidth !== undefined ? UDim2.fromOffset(autoSectionWidth, 0) : undefined}
				width={autoSectionWidth === undefined ? "100%" : undefined}
				AutomaticSize={Enum.AutomaticSize.Y}
				BackgroundColor3={theme.components.table.header.backgroundColor}
				BackgroundTransparency={theme.components.table.header.backgroundTransparency}
			>
				<uicorner
					key="Corners"
					TopLeftRadius={SizeHelper.toUDim(theme.components.table.cornerRadius)}
					TopRightRadius={SizeHelper.toUDim(theme.components.table.cornerRadius)}
					BottomLeftRadius={new UDim(0, 0)}
					BottomRightRadius={new UDim(0, 0)}
				/>
				<VStack spacing="None">{props.children}</VStack>
			</Container>
		</TableSectionContext.Provider>
	);
}

function TableBody(props: TableSectionProps) {
	const layout = React.useContext(TableLayoutContext);
	const autoSectionWidth = layout?.autoWidth === true ? layout.totalWidth : undefined;

	return (
		<TableSectionContext.Provider value="body">
			<Container
				name="TableBody"
				Size={autoSectionWidth !== undefined ? UDim2.fromOffset(autoSectionWidth, 0) : undefined}
				width={autoSectionWidth === undefined ? "100%" : undefined}
				AutomaticSize={Enum.AutomaticSize.Y}
			>
				<VStack spacing="None">{props.children}</VStack>
			</Container>
		</TableSectionContext.Provider>
	);
}

function TableRow(props: TableRowProps) {
	const theme = React.useContext(CleanThemeContext);
	const section = React.useContext(TableSectionContext);
	const layout = React.useContext(TableLayoutContext);
	let columnIndex = 0;
	const children = React.Children.map(props.children, (child) => {
		if (!React.isValidElement<TableCellProps>(child) || (child.type !== TableHead && child.type !== TableCell)) {
			return child;
		}

		const currentColumnIndex = columnIndex++;
		return <TableColumnContext.Provider value={currentColumnIndex}>{child}</TableColumnContext.Provider>;
	});
	const autoRowWidth = layout?.autoWidth === true ? layout.totalWidth : undefined;

	return (
		<Container
			name="TableRow"
			Size={autoRowWidth !== undefined ? UDim2.fromOffset(autoRowWidth, 0) : undefined}
			width={autoRowWidth === undefined ? "100%" : undefined}
			AutomaticSize={Enum.AutomaticSize.Y}
		>
			{section === "body" && (
				<frame
					key="Divider"
					BackgroundColor3={theme.components.table.rowDividerColor}
					BorderSizePixel={0}
					Size={UDim2.fromOffset(0, theme.components.table.rowDividerThickness).add(UDim2.fromScale(1, 0))}
				/>
			)}
			<Container name="TableRowContent" width="100%" AutomaticSize={Enum.AutomaticSize.Y}>
				<HStack Padding={new UDim(0, 0)} Wraps={false}>
					{children}
				</HStack>
			</Container>
		</Container>
	);
}

function TableCellContent(props: TableCellProps & { header: boolean }) {
	const theme = React.useContext(CleanThemeContext);
	const tableScale = React.useContext(TableScaleContext);
	const layout = React.useContext(TableLayoutContext);
	const id = React.useRef(nextTableCellId++).current;
	const measurementRef = React.useRef<Frame>();
	const typography = props.header
		? TypographyHelper.getTypography(theme, tableScale, theme.components.table.header.typography)
		: TypographyHelper.getTypography(theme, tableScale, theme.components.table.cell.typography);
	const content = props.text ?? props.children;
	const columnIndex = React.useContext(TableColumnContext);
	const columnWidth = layout?.columnWidths.get(columnIndex) ?? 0;
	const cellWidth = layout?.autoWidth === false && layout.totalWidth > 0
		? new UDim(columnWidth / layout.totalWidth, 0)
		: new UDim(0, columnWidth);
	const reportMeasurement = React.useCallback(
		(instance: Frame) => layout?.reportWidth(id, columnIndex, instance.AbsoluteSize.X),
		[layout?.reportWidth, id, columnIndex],
	);

	React.useEffect(() => () => layout?.removeWidth(id), [layout?.removeWidth]);
	React.useEffect(() => {
		let mounted = true;
		const reportMountedMeasurement = () => {
			const instance = measurementRef.current;
			if (mounted && instance !== undefined) reportMeasurement(instance);
		};

		reportMountedMeasurement();
		task.defer(reportMountedMeasurement);

		return () => {
			mounted = false;
		};
	}, [reportMeasurement]);

	return (
		<Container name={props.header ? "TableHead" : "TableCell"} Size={new UDim2(cellWidth, new UDim(0, 0))} AutomaticSize={Enum.AutomaticSize.Y}>
			<uilistlayout
				key="TableCellLayout"
				FillDirection={Enum.FillDirection.Horizontal}
				HorizontalAlignment={props.align ?? "Left"}
			/>
			<frame
				key="TableCellMeasurement"
				ref={measurementRef}
				Size={UDim2.fromOffset(0, 0)}
				AutomaticSize={Enum.AutomaticSize.XY}
				BackgroundTransparency={1}
				Change={{
					AbsoluteSize: reportMeasurement,
				}}
			>
				<Padding
					resolvedPadding={SpacingHelper.GetResolvedPadding(
						theme,
						{ ...props, spacing: props.spacing ?? tableScale },
						theme.components.table.cell.spacing,
						theme.components.table.cell.padding,
					)}
				/>
				{typeIs(content, "string") ? <Text text={content} typography={typography} TextWrap={false} /> : content}
			</frame>
		</Container>
	);
}

function TableHead(props: TableCellProps) {
	return TableCellContent({ ...props, header: true });
}

function TableCell(props: TableCellProps) {
	return TableCellContent({ ...props, header: false });
}

type TableComponent = React.ForwardRefExoticComponent<TableProps & React.RefAttributes<ImageLabel>> & {
	Header: typeof TableHeader;
	Body: typeof TableBody;
	Row: typeof TableRow;
	Head: typeof TableHead;
	Cell: typeof TableCell;
};

const Table = React.forwardRef<ImageLabel, TableProps>((props, ref) => {
	const theme = React.useContext(CleanThemeContext);
	const [measurements, setMeasurements] = React.useState<Map<number, { columnIndex: number; width: number }>>(new Map());
	const autoWidth = props.Size === undefined && props.width === undefined;
	const reportWidth = React.useCallback((id: number, columnIndex: number, width: number) => {
		setMeasurements((current) => {
			const previous = current.get(id);
			if (previous?.columnIndex === columnIndex && previous.width === width) return current;
			const updated = new Map<number, { columnIndex: number; width: number }>();
			for (const [currentId, measurement] of current) updated.set(currentId, measurement);
			updated.set(id, { columnIndex, width });
			return updated;
		});
	}, []);
	const removeWidth = React.useCallback((id: number) => {
		setMeasurements((current) => {
			if (!current.has(id)) return current;
			const updated = new Map<number, { columnIndex: number; width: number }>();
			for (const [currentId, measurement] of current) updated.set(currentId, measurement);
			updated.delete(id);
			return updated;
		});
	}, []);
	const columnWidths = React.useMemo(() => {
		const widths = new Map<number, number>();
		for (const [, measurement] of measurements) {
			widths.set(measurement.columnIndex, math.max(widths.get(measurement.columnIndex) ?? 0, measurement.width));
		}
		return widths;
	}, [measurements]);
	let totalWidth = 0;
	for (const [, width] of columnWidths) totalWidth += width;
	const layout = React.useMemo<TableLayoutContextValue>(
		() => ({ autoWidth, columnWidths, totalWidth, reportWidth, removeWidth }),
		[autoWidth, columnWidths, totalWidth, reportWidth, removeWidth],
	);

	return (
		<TableScaleContext.Provider value={props.scale}>
			<TableLayoutContext.Provider value={layout}>
				<Container
					ref={ref}
					name={props.name ?? "Table"}
					Size={props.Size}
					width={props.width}
					height={props.height}
					AutomaticSize={props.AutomaticSize}
					BackgroundColor3={theme.components.table.backgroundColor}
					BackgroundTransparency={theme.components.table.backgroundTransparency}
					ClipsDescendants
				>
					<Corners radius={theme.components.table.cornerRadius} />
					<uistroke
						key="Stroke"
						Color={theme.components.table.borderColor}
						Thickness={theme.components.table.borderThickness}
						BorderStrokePosition={Enum.BorderStrokePosition.Outer}
					/>
					<VStack spacing="None" HorizontalFlex={autoWidth ? Enum.UIFlexAlignment.None : Enum.UIFlexAlignment.Fill}>{props.children}</VStack>
				</Container>
			</TableLayoutContext.Provider>
		</TableScaleContext.Provider>
	);
}) as TableComponent;

Table.Header = TableHeader;
Table.Body = TableBody;
Table.Row = TableRow;
Table.Head = TableHead;
Table.Cell = TableCell;

export { Table };
