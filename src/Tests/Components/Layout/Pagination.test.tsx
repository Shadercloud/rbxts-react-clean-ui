import React from "@rbxts/react";
import ReactRoblox from "@rbxts/react-roblox";
import { Test, Assert, Decorators, Runtime, Tag, DisplayName } from "@rbxts/lunit";

const { Skip } = Decorators;
import { Pagination } from "../../../Components/Layout/Pagination";

function renderPagination(element: React.ReactElement) {
	const host = new Instance("Folder");
	const root = ReactRoblox.createRoot(host);

	root.render(element);
	task.wait();

	return { host, root };
}

function getNamedDescendants(host: Instance, name: string) {
	return host.GetDescendants().filter((descendant) => descendant.Name === name);
}

function getButton(host: Instance, name: string) {
	const button = host.FindFirstChild(name, true);
	Assert.notUndefined(button);
	Assert.true(button!.IsA("ImageButton"));
	return button as ImageButton;
}

function unmount(root: ReactRoblox.Root, host: Instance) {
	root.unmount();
	host.Destroy();
}

function getOrderedPageLabels(host: Instance): string[] {
	const list = host.FindFirstChild("PaginationList", true);
	Assert.notUndefined(list);

	const entries: GuiObject[] = [];
	for (const child of list!.GetChildren()) {
		if (child.IsA("GuiObject")) entries.push(child);
	}

	entries.sort((a, b) => a.LayoutOrder < b.LayoutOrder);

	return entries.map((entry) =>
		entry.Name === "PaginationEllipsis" ? "ellipsis" : entry.Name.sub("PaginationItem-".size() + 1),
	);
}

@Tag("Studio")
class PaginationMountValidation {
	@Skip(!Runtime.isRoblox(), "Requires a real Roblox Instance tree - run inside Roblox Studio via the TestRunner.")
	@DisplayName("Seven pages at siblingCount 1 render every item with no ellipsis")
	@Test
	public allPages() {
		const { host, root } = renderPagination(<Pagination page={3} totalPages={7} onPageChange={() => {}} />);

		for (let page = 1; page <= 7; page++) Assert.notUndefined(host.FindFirstChild(`PaginationItem-${page}`, true));
		Assert.equal(getNamedDescendants(host, "PaginationEllipsis").size(), 0);

		unmount(root, host);
	}

	@Skip(!Runtime.isRoblox(), "Requires a real Roblox Instance tree - run inside Roblox Studio via the TestRunner.")
	@DisplayName("On page 1 of 10 the leading run extends to 1..5 followed by a single ellipsis and the last page")
	@Test
	public startWindow() {
		const { host, root } = renderPagination(<Pagination page={1} totalPages={10} onPageChange={() => {}} />);

		// Near the start, the leading run of numbers extends (1..5) to keep the
		// total item count constant with the middle/end windows.
		for (const page of [1, 2, 3, 4, 5, 10]) Assert.notUndefined(host.FindFirstChild(`PaginationItem-${page}`, true));
		Assert.undefined(host.FindFirstChild("PaginationItem-6", true));
		Assert.equal(getNamedDescendants(host, "PaginationEllipsis").size(), 1);

		unmount(root, host);
	}

	@Skip(!Runtime.isRoblox(), "Requires a real Roblox Instance tree - run inside Roblox Studio via the TestRunner.")
	@DisplayName("On page 10 of 10 the first page, a single ellipsis and the trailing run 6..10 are shown")
	@Test
	public endWindow() {
		const { host, root } = renderPagination(<Pagination page={10} totalPages={10} onPageChange={() => {}} />);

		// Near the end, the trailing run of numbers extends (6..10) to keep the
		// total item count constant with the middle/start windows.
		for (const page of [1, 6, 7, 8, 9, 10]) Assert.notUndefined(host.FindFirstChild(`PaginationItem-${page}`, true));
		Assert.undefined(host.FindFirstChild("PaginationItem-5", true));
		Assert.equal(getNamedDescendants(host, "PaginationEllipsis").size(), 1);

		unmount(root, host);
	}

	@Skip(!Runtime.isRoblox(), "Requires a real Roblox Instance tree - run inside Roblox Studio via the TestRunner.")
	@DisplayName("With siblingCount 0 the middle window collapses to just the current page flanked by two ellipses")
	@Test
	public zeroSiblings() {
		const { host, root } = renderPagination(
			<Pagination page={5} totalPages={10} siblingCount={0} onPageChange={() => {}} />,
		);

		for (const page of [1, 5, 10]) Assert.notUndefined(host.FindFirstChild(`PaginationItem-${page}`, true));
		Assert.undefined(host.FindFirstChild("PaginationItem-4", true));
		Assert.undefined(host.FindFirstChild("PaginationItem-6", true));
		Assert.equal(getNamedDescendants(host, "PaginationEllipsis").size(), 2);

		unmount(root, host);
	}

	@Skip(!Runtime.isRoblox(), "Requires a real Roblox Instance tree - run inside Roblox Studio via the TestRunner.")
	@DisplayName("With siblingCount 2 on page 6 of 12 the window spans 4..8 between two ellipses")
	@Test
	public twoSiblings() {
		const { host, root } = renderPagination(
			<Pagination page={6} totalPages={12} siblingCount={2} onPageChange={() => {}} />,
		);

		for (const page of [1, 4, 5, 6, 7, 8, 12]) {
			Assert.notUndefined(host.FindFirstChild(`PaginationItem-${page}`, true));
		}
		Assert.undefined(host.FindFirstChild("PaginationItem-3", true));
		Assert.undefined(host.FindFirstChild("PaginationItem-9", true));
		Assert.equal(getNamedDescendants(host, "PaginationEllipsis").size(), 2);

		unmount(root, host);
	}

	@Skip(!Runtime.isRoblox(), "Requires a real Roblox Instance tree - run inside Roblox Studio via the TestRunner.")
	@DisplayName("On the first page Prev is inactive, Next is active and the current item has an opaque background")
	@Test
	public firstPageState() {
		const { host, root } = renderPagination(
			<Pagination page={1} totalPages={3} onPageChange={() => {}} />,
		);

		const previous = getButton(host, "PaginationPrev");
		const nextButton = getButton(host, "PaginationNext");
		const selected = getButton(host, "PaginationItem-1");
		const unselected = getButton(host, "PaginationItem-2");
		Assert.false(previous.Active);
		Assert.false(previous.Selectable);
		Assert.true(nextButton.Active);
		Assert.true(nextButton.Selectable);
		// The selected item uses the focus intent. Every bundled theme distinguishes it
		// from the default state by making the background opaque (transparency 0 vs 1),
		// not by colour: the default state inherits the base primary background
		// (#FFFFFF in the default theme), which is identical to the focus colour.
		Assert.true(selected.BackgroundTransparency < unselected.BackgroundTransparency);

		unmount(root, host);
	}

	@Skip(!Runtime.isRoblox(), "Requires a real Roblox Instance tree - run inside Roblox Studio via the TestRunner.")
	@DisplayName("On the last page Next is inactive and unselectable while Prev stays interactive")
	@Test
	public lastPageState() {
		const { host, root } = renderPagination(<Pagination page={3} totalPages={3} onPageChange={() => {}} />);

		const previous = getButton(host, "PaginationPrev");
		const nextButton = getButton(host, "PaginationNext");
		Assert.true(previous.Active);
		Assert.true(previous.Selectable);
		Assert.false(nextButton.Active);
		Assert.false(nextButton.Selectable);

		unmount(root, host);
	}

	@Skip(!Runtime.isRoblox(), "Requires a real Roblox Instance tree - run inside Roblox Studio via the TestRunner.")
	@DisplayName("Passing a lone Pagination.Item child omits the default Prev, Next and List entirely")
	@Test
	public customChildren() {
		const { host, root } = renderPagination(
			<Pagination page={2} totalPages={5} onPageChange={() => {}}>
				<Pagination.Item value={4} />
			</Pagination>,
		);

		Assert.notUndefined(host.FindFirstChild("PaginationItem-4", true));
		Assert.undefined(host.FindFirstChild("PaginationPrev", true));
		Assert.undefined(host.FindFirstChild("PaginationNext", true));
		Assert.undefined(host.FindFirstChild("PaginationList", true));

		unmount(root, host);
	}

	@Skip(!Runtime.isRoblox(), "Requires a real Roblox Instance tree - run inside Roblox Studio via the TestRunner.")
	@DisplayName("Items placed inside an explicit Pagination.List render as-is instead of the computed page window")
	@Test
	public customList() {
		const { host, root } = renderPagination(
			<Pagination page={2} totalPages={10} onPageChange={() => {}}>
				<Pagination.List>
					<Pagination.Item value={8} />
					<Pagination.Ellipsis />
				</Pagination.List>
			</Pagination>,
		);

		Assert.notUndefined(host.FindFirstChild("PaginationList", true));
		Assert.notUndefined(host.FindFirstChild("PaginationItem-8", true));
		Assert.undefined(host.FindFirstChild("PaginationItem-1", true));
		Assert.equal(getNamedDescendants(host, "PaginationEllipsis").size(), 1);

		unmount(root, host);
	}

	@Skip(!Runtime.isRoblox(), "Requires a real Roblox Instance tree - run inside Roblox Studio via the TestRunner.")
	@DisplayName("Stepping from page 6 to 7 to 8 keeps LayoutOrder ascending with ellipses in the right slots")
	@Test
	public visualOrder() {
		const { host, root } = renderPagination(
			<Pagination page={6} totalPages={12} siblingCount={1} onPageChange={() => {}} />,
		);

		Assert.deepEqual(getOrderedPageLabels(host), ["1", "ellipsis", "5", "6", "7", "ellipsis", "12"]);

		root.render(<Pagination page={7} totalPages={12} siblingCount={1} onPageChange={() => {}} />);
		task.wait();
		Assert.deepEqual(getOrderedPageLabels(host), ["1", "ellipsis", "6", "7", "8", "ellipsis", "12"]);

		root.render(<Pagination page={8} totalPages={12} siblingCount={1} onPageChange={() => {}} />);
		task.wait();
		Assert.deepEqual(getOrderedPageLabels(host), ["1", "ellipsis", "7", "8", "9", "ellipsis", "12"]);

		unmount(root, host);
	}

	@Skip(!Runtime.isRoblox(), "Requires a real Roblox Instance tree - run inside Roblox Studio via the TestRunner.")
	@DisplayName("Items plus ellipses always total siblingCount * 2 + 5 no matter which page is current")
	@Test
	public constantItemCount() {
		const totalPages = 12;
		const siblingCount = 1;
		const expectedItemCount = siblingCount * 2 + 5;

		const { host, root } = renderPagination(
			<Pagination page={1} totalPages={totalPages} siblingCount={siblingCount} onPageChange={() => {}} />,
		);

		const countRenderedItems = () =>
			getNamedDescendants(host, "PaginationEllipsis").size() +
			host
				.GetDescendants()
				.filter((descendant) => descendant.Name.sub(1, "PaginationItem-".size()) === "PaginationItem-").size();

		for (const page of [1, 2, 4, 6, 7, 8, 10, 11, 12]) {
			root.render(
				<Pagination page={page} totalPages={totalPages} siblingCount={siblingCount} onPageChange={() => {}} />,
			);
			task.wait();
			Assert.equal(countRenderedItems(), expectedItemCount);
		}

		unmount(root, host);
	}
}

export = PaginationMountValidation;
