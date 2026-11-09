import React from "@rbxts/react";
import { Test, Assert, Decorators, Runtime, Tag, DisplayName } from "@rbxts/lunit";

const { Skip, Each } = Decorators;
import { Tabs } from "../../../Components/Layout/Tabs";
import { Text } from "../../../Components/Typography/Text";
import { ThemeProvider } from "../../../Providers/theme.provider";
import { DefaultTheme, ThemeTemplate, extendTheme } from "../../../Theme";
import { activateButton } from "../../Helpers/fiber";
import {
	STUDIO_SKIP_MESSAGE,
	assertAllDescendantsContained,
	assertContained,
	assertStackedHorizontally,
	findDescendant,
	rect,
	waitForDescendant,
	waitForGuiObject,
	waitForLayout,
	withMounted,
} from "../../Helpers/layout";

const TAB_VALUES = ["one", "two", "three"];

const DEFAULT_TEXT = Color3.fromRGB(10, 120, 30);
const HOVER_TEXT = Color3.fromRGB(90, 90, 200);
const FOCUS_TEXT = Color3.fromRGB(220, 40, 40);
const DEFAULT_BORDER = Color3.fromRGB(51, 29, 7);
const FOCUS_BORDER = Color3.fromRGB(250, 200, 20);
const GRADIENT_TOP = Color3.fromRGB(186, 133, 74);
const GRADIENT_BOTTOM = Color3.fromRGB(122, 74, 32);

interface TabsFixtureProps {
	defaultValue?: string;
	value?: string;
	onValueChange?: (value: string) => void;
	fill?: boolean;
	bodyLayoutOrder?: number;
}

function tabsFixture(props: TabsFixtureProps = {}) {
	return (
		<Tabs defaultValue={props.defaultValue} value={props.value} onValueChange={props.onValueChange}>
			<Tabs.List fill={props.fill}>
				<Tabs.Title value="one" text="One" />
				<Tabs.Title value="two" text="Two" />
				<Tabs.Title value="three" text="Three" />
			</Tabs.List>
			<Tabs.Body LayoutOrder={props.bodyLayoutOrder}>
				<Tabs.Content value="one">
					<Text text="Panel one" />
				</Tabs.Content>
				<Tabs.Content value="two">
					<Text text="Panel two" />
				</Tabs.Content>
				<Tabs.Content value="three">
					<Text text="Panel three" />
				</Tabs.Content>
			</Tabs.Body>
		</Tabs>
	);
}

function themed(theme: ThemeTemplate, props: TabsFixtureProps = {}) {
	return <ThemeProvider theme={theme}>{tabsFixture(props)}</ThemeProvider>;
}

function stateTheme(buttonBorderThickness: number): ThemeTemplate {
	return extendTheme(DefaultTheme, {
		components: {
			tabs: {
				button: {
					borderThickness: buttonBorderThickness,
					intents: {
						primary: {
							default: { textColor: DEFAULT_TEXT, borderColor: DEFAULT_BORDER },
							hover: { textColor: HOVER_TEXT },
							focus: {
								textColor: FOCUS_TEXT,
								borderColor: FOCUS_BORDER,
								backgroundColor: Color3.fromRGB(255, 255, 255),
								backgroundGradient: { colors: [GRADIENT_TOP, GRADIENT_BOTTOM], rotation: 90 },
							},
						},
					},
				},
			},
		},
	});
}

function waitForSelectedContent(host: Instance, value: string): ImageLabel {
	return waitForGuiObject<ImageLabel>(
		host,
		`TabContent_${value}`,
		(gui) => gui.Visible && gui.AbsoluteSize.X > 0,
		`Timed out waiting for TabContent_${value} to become the visible panel`,
	);
}

function getVisiblePanels(host: Instance): string[] {
	const visible: string[] = [];
	for (const value of TAB_VALUES) {
		const panel = host.FindFirstChild(`TabContent_${value}`, true) as ImageLabel | undefined;
		if (panel !== undefined && panel.Visible) visible.push(value);
	}
	return visible;
}

function assertOnlySelectedVisible(host: Instance, selected: string) {
	for (const value of TAB_VALUES) {
		const panel = findDescendant<ImageLabel>(host, `TabContent_${value}`);

		Assert.equal(
			panel.Visible,
			value === selected,
			`Expected TabContent_${value} Visible to be ${value === selected} while "${selected}" is selected`,
		);
	}
}

function waitForButton(host: Instance, value: string): ImageButton {
	return waitForGuiObject<ImageButton>(host, `TabButton-${value}`);
}

function settleFrames(count: number) {
	for (let frame = 0; frame < count; frame++) {
		task.wait();
	}
}

function titleTextOf(button: ImageButton): TextLabel {
	return findDescendant<TextLabel>(button, "TabTitleText");
}

function titleIconOf(button: ImageButton): ImageLabel {
	return findDescendant<ImageLabel>(button, "TabTitleIcon");
}

function iconTabsFixture(selected: string) {
	return (
		<Tabs value={selected}>
			<Tabs.List>
				<Tabs.Title value="text" text="Text" />
				<Tabs.Title value="both" icon="home" text="Home" />
				<Tabs.Title value="icon" icon="cog" />
				<Tabs.Title value="empty" icon="check" text="" />
				<Tabs.Title value="pair" icon="check" text="Pair" />
			</Tabs.List>
			<Tabs.Body>
				<Tabs.Content value="text">
					<Text text="Panel text" />
				</Tabs.Content>
				<Tabs.Content value="both">
					<Text text="Panel both" />
				</Tabs.Content>
				<Tabs.Content value="icon">
					<Text text="Panel icon" />
				</Tabs.Content>
				<Tabs.Content value="empty">
					<Text text="Panel empty" />
				</Tabs.Content>
				<Tabs.Content value="pair">
					<Text text="Panel pair" />
				</Tabs.Content>
			</Tabs.Body>
		</Tabs>
	);
}

function themedIconTabs(selected: string) {
	return <ThemeProvider theme={stateTheme(0)}>{iconTabsFixture(selected)}</ThemeProvider>;
}

@Tag("Studio")
class TabsMountValidation {
	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName(
		"Without defaultValue the first declared tab claims the selection, so only its panel is visible and the rest stay mounted but hidden",
	)
	@Test
	public firstTabSelectedByDefault() {
		withMounted(400, 300, tabsFixture(), (mounted) => {
			const visible = waitForLayout(() => {
				const panels = getVisiblePanels(mounted.host);
				return panels.size() === 1 ? panels : undefined;
			}, "Timed out waiting for exactly one TabContent panel to become visible");

			Assert.equal(
				visible[0],
				"one",
				`Expected the first declared tab "one" to be selected without a defaultValue, but "${visible[0]}" was visible`,
			);

			assertOnlySelectedVisible(mounted.host, "one");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("defaultValue seeds the selection so a non-first tab's panel is the one shown")
	@Test
	public defaultValueSelectsTab() {
		withMounted(400, 300, tabsFixture({ defaultValue: "two" }), (mounted) => {
			waitForSelectedContent(mounted.host, "two");

			assertOnlySelectedVisible(mounted.host, "two");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Tab buttons are laid out left-to-right in declaration order inside the list")
	@Test
	public titlesInOrder() {
		withMounted(400, 300, tabsFixture({ defaultValue: "one" }), (mounted) => {
			waitForSelectedContent(mounted.host, "one");

			const list = findDescendant<ImageLabel>(mounted.host, "TabsList");
			const buttons: GuiObject[] = [];
			for (const value of TAB_VALUES) {
				const button = waitForGuiObject<ImageButton>(list, `TabButton-${value}`);
				Assert.equal(button.Parent, list, `Expected TabButton-${value} to be a direct child of TabsList`);
				buttons.push(button);
			}

			assertStackedHorizontally(buttons, "tab buttons");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("The list, the body and every visible descendant of each stay inside their container and the host")
	@Test
	public contentsContained() {
		withMounted(400, 300, tabsFixture({ defaultValue: "one" }), (mounted) => {
			waitForSelectedContent(mounted.host, "one");

			const list = waitForGuiObject<ImageLabel>(mounted.host, "TabsList");
			const body = waitForGuiObject<ImageLabel>(mounted.host, "TabsBody");

			assertContained(list, mounted.host, "list vs host");
			assertContained(body, mounted.host, "body vs host");
			assertAllDescendantsContained(list, "tabs list");
			assertAllDescendantsContained(body, "tabs body");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName(
		"In controlled mode the visible panel is whatever value says, and re-rendering with a new value moves it",
	)
	@Test
	public controlledFollowsValue() {
		withMounted(400, 300, tabsFixture({ value: "two" }), (mounted) => {
			waitForSelectedContent(mounted.host, "two");
			assertOnlySelectedVisible(mounted.host, "two");

			mounted.update(tabsFixture({ value: "three" }));

			waitForSelectedContent(mounted.host, "three");
			assertOnlySelectedVisible(mounted.host, "three");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName(
		"Clicking another title in controlled mode reports it through onValueChange but keeps the panel until value is fed back",
	)
	@Test
	public controlledClickOnlyReports() {
		const reported: string[] = [];
		const onValueChange = (value: string) => {
			reported.push(value);
		};

		withMounted(400, 300, tabsFixture({ value: "one", onValueChange }), (mounted) => {
			waitForSelectedContent(mounted.host, "one");

			activateButton(mounted, waitForButton(mounted.host, "two"));

			waitForLayout(
				() => (reported.size() > 0 ? true : undefined),
				"Timed out waiting for onValueChange to fire after clicking TabButton-two",
			);
			Assert.deepEqual(reported, ["two"]);

			settleFrames(5);
			assertOnlySelectedVisible(mounted.host, "one");

			mounted.update(tabsFixture({ value: "two", onValueChange }));

			waitForSelectedContent(mounted.host, "two");
			assertOnlySelectedVisible(mounted.host, "two");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("A controlled value that matches no title shows no panel, because titles make no mount-time claim")
	@Test
	public controlledUnknownValue() {
		withMounted(400, 300, tabsFixture({ value: "missing" }), (mounted) => {
			waitForGuiObject<ImageButton>(mounted.host, "TabButton-one");
			settleFrames(5);

			Assert.deepEqual(getVisiblePanels(mounted.host), []);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("In uncontrolled mode clicking a title switches the panel immediately and still fires onValueChange")
	@Test
	public uncontrolledClickSwitches() {
		const reported: string[] = [];

		withMounted(
			400,
			300,
			tabsFixture({ defaultValue: "one", onValueChange: (value) => reported.push(value) }),
			(mounted) => {
				waitForSelectedContent(mounted.host, "one");

				activateButton(mounted, waitForButton(mounted.host, "three"));

				waitForSelectedContent(mounted.host, "three");
				assertOnlySelectedVisible(mounted.host, "three");
				Assert.deepEqual(reported, ["three"]);
			},
		);
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("The selected title's text uses the focus textColor and unselected titles use the default textColor")
	@Test
	public textColorPerState() {
		withMounted(400, 300, themed(stateTheme(0), { defaultValue: "one" }), (mounted) => {
			waitForSelectedContent(mounted.host, "one");

			Assert.equal(titleTextOf(waitForButton(mounted.host, "one")).TextColor3, FOCUS_TEXT);
			Assert.equal(titleTextOf(waitForButton(mounted.host, "two")).TextColor3, DEFAULT_TEXT);
			Assert.equal(titleTextOf(waitForButton(mounted.host, "three")).TextColor3, DEFAULT_TEXT);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("With button.borderThickness 0 no tab button carries a Stroke")
	@Test
	public noStrokeAtZero() {
		withMounted(400, 300, themed(stateTheme(0), { defaultValue: "one" }), (mounted) => {
			waitForSelectedContent(mounted.host, "one");

			for (const value of TAB_VALUES) {
				Assert.undefined(
					waitForButton(mounted.host, value).FindFirstChild("Stroke"),
					`Expected TabButton-${value} to have no Stroke when borderThickness is 0`,
				);
			}
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName(
		"With a positive button.borderThickness each tab gets an inner Stroke coloured by its own state's borderColor",
	)
	@Test
	public strokePerState() {
		withMounted(400, 300, themed(stateTheme(3), { defaultValue: "one" }), (mounted) => {
			waitForSelectedContent(mounted.host, "one");

			const selectedStroke = findDescendant<UIStroke>(waitForButton(mounted.host, "one"), "Stroke");
			const unselectedStroke = findDescendant<UIStroke>(waitForButton(mounted.host, "two"), "Stroke");

			Assert.equal(selectedStroke.Thickness, 3);
			Assert.equal(selectedStroke.Color, FOCUS_BORDER);
			Assert.equal(selectedStroke.BorderStrokePosition, Enum.BorderStrokePosition.Inner);
			Assert.equal(unselectedStroke.Thickness, 3);
			Assert.equal(unselectedStroke.Color, DEFAULT_BORDER);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName(
		"A state-level borderThickness overrides button.borderThickness and can add a Stroke to that state alone",
	)
	@Test
	public stateBorderThickness() {
		const theme = extendTheme(stateTheme(0), {
			components: { tabs: { button: { intents: { primary: { focus: { borderThickness: 2 } } } } } },
		});

		withMounted(400, 300, themed(theme, { defaultValue: "two" }), (mounted) => {
			waitForSelectedContent(mounted.host, "two");

			const selectedStroke = findDescendant<UIStroke>(waitForButton(mounted.host, "two"), "Stroke");
			Assert.equal(selectedStroke.Thickness, 2);
			Assert.equal(selectedStroke.Color, FOCUS_BORDER);
			Assert.undefined(waitForButton(mounted.host, "one").FindFirstChild("Stroke"));
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName(
		"Only the state that defines a backgroundGradient renders a UIGradient, and it moves with the selection",
	)
	@Test
	public gradientPerState() {
		withMounted(400, 300, themed(stateTheme(0), { defaultValue: "one" }), (mounted) => {
			waitForSelectedContent(mounted.host, "one");

			const gradient = findDescendant<UIGradient>(waitForButton(mounted.host, "one"), "Gradient");
			Assert.true(gradient.IsA("UIGradient"), "Expected the selected tab's Gradient to be a UIGradient");
			Assert.equal(gradient.Rotation, 90);
			Assert.equal(gradient.Color.Keypoints[0].Value, GRADIENT_TOP);
			Assert.equal(gradient.Color.Keypoints[gradient.Color.Keypoints.size() - 1].Value, GRADIENT_BOTTOM);
			Assert.undefined(waitForButton(mounted.host, "two").FindFirstChild("Gradient"));

			mounted.update(themed(stateTheme(0), { value: "two" }));

			waitForDescendant<UIGradient>(
				waitForButton(mounted.host, "two"),
				"Gradient",
				() => true,
				"Timed out waiting for the newly selected tab to render its Gradient",
			);
			waitForLayout(
				() => (waitForButton(mounted.host, "one").FindFirstChild("Gradient") === undefined ? true : undefined),
				"Timed out waiting for the deselected tab to drop its Gradient",
			);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName(
		"A per-corner button.cornerRadius sets each UICorner corner, falling back to list.cornerRadius for unset corners",
	)
	@Test
	public perCornerRadius() {
		const theme = extendTheme(DefaultTheme, {
			components: {
				tabs: {
					list: { cornerRadius: 6 },
					button: { cornerRadius: { topLeft: 8, topRight: 10, bottomLeft: 0 } },
				},
			},
		});

		withMounted(400, 300, themed(theme, { defaultValue: "one" }), (mounted) => {
			waitForSelectedContent(mounted.host, "one");

			const corners = findDescendant<UICorner>(waitForButton(mounted.host, "two"), "Corners");
			Assert.equal(corners.TopLeftRadius, new UDim(0, 8));
			Assert.equal(corners.TopRightRadius, new UDim(0, 10));
			Assert.equal(corners.BottomLeftRadius, new UDim(0, 0));
			Assert.equal(corners.BottomRightRadius, new UDim(0, 6));
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("A per-corner button.cornerRadius that resolves to zero on every corner renders no Corners")
	@Test
	public allZeroCorners() {
		const theme = extendTheme(DefaultTheme, {
			components: { tabs: { list: { cornerRadius: 0 }, button: { cornerRadius: { topLeft: 0 } } } },
		});

		withMounted(400, 300, themed(theme, { defaultValue: "one" }), (mounted) => {
			waitForSelectedContent(mounted.host, "one");

			Assert.undefined(waitForButton(mounted.host, "two").FindFirstChild("Corners"));
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName(
		"Tabs.List fill switches the title row to a non-wrapping Fill layout and gives every title the same width",
	)
	@Test
	public listFillShares() {
		withMounted(400, 300, tabsFixture({ defaultValue: "one", fill: true }), (mounted) => {
			waitForSelectedContent(mounted.host, "one");

			const list = findDescendant<ImageLabel>(mounted.host, "TabsList");
			const layout = list.FindFirstChild("HStack") as UIListLayout | undefined;
			Assert.notUndefined(layout, "Expected TabsList to hold its HStack UIListLayout directly");
			Assert.equal(layout!.HorizontalFlex, Enum.UIFlexAlignment.Fill);
			Assert.false(layout!.Wraps, "Expected a fill list not to wrap");

			const buttons = TAB_VALUES.map((value) => waitForButton(list, value));
			for (const button of buttons) {
				Assert.equal(button.AutomaticSize, Enum.AutomaticSize.Y);
				Assert.notUndefined(
					button.FindFirstChild("TitleLayout"),
					`Expected ${button.Name} to centre its text with TitleLayout`,
				);
			}

			waitForLayout(
				() => (math.abs(rect(buttons[0]).width - rect(buttons[2]).width) <= 1 ? true : undefined),
				`Timed out waiting for fill titles to share a width (one=${rect(buttons[0]).width}, three=${rect(buttons[2]).width})`,
			);
			Assert.true(
				math.abs(rect(buttons[1]).width - rect(buttons[0]).width) <= 1,
				"Expected every fill title to be the same width",
			);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Without fill the title row keeps no flex, and titles hug their text with no TitleLayout")
	@Test
	public listWithoutFill() {
		withMounted(400, 300, tabsFixture({ defaultValue: "one" }), (mounted) => {
			waitForSelectedContent(mounted.host, "one");

			const list = findDescendant<ImageLabel>(mounted.host, "TabsList");
			const layout = findDescendant<UIListLayout>(list, "HStack");
			Assert.equal(layout.HorizontalFlex, Enum.UIFlexAlignment.None);

			const button = waitForButton(list, "one");
			Assert.equal(button.AutomaticSize, Enum.AutomaticSize.XY);
			Assert.undefined(button.FindFirstChild("TitleLayout"));
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("tabs.list.gap sets the pixel Padding of the title row layout")
	@Test
	public listGap() {
		const theme = extendTheme(DefaultTheme, { components: { tabs: { list: { gap: 11 } } } });

		withMounted(400, 300, themed(theme, { defaultValue: "one" }), (mounted) => {
			waitForSelectedContent(mounted.host, "one");

			const list = findDescendant<ImageLabel>(mounted.host, "TabsList");
			Assert.equal(findDescendant<UIListLayout>(list, "HStack").Padding, new UDim(0, 11));
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName(
		"tabs.gap sets the Padding of the root VStack between the list and the body, including negative overlap",
	)
	@Test
	public tabsGap() {
		const theme = extendTheme(DefaultTheme, { components: { tabs: { gap: -3 } } });

		withMounted(400, 300, themed(theme, { defaultValue: "one" }), (mounted) => {
			waitForSelectedContent(mounted.host, "one");

			const layout = mounted.host.FindFirstChild("VStack") as UIListLayout | undefined;
			Assert.notUndefined(layout, "Expected the Tabs root VStack layout directly under the host");
			Assert.equal(layout!.Padding, new UDim(0, -3));
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("TabsBody renders its Stroke from tabs.borderThickness and renders none when it is 0")
	@Test
	public bodyStrokeGated() {
		withMounted(400, 300, tabsFixture({ defaultValue: "one" }), (mounted) => {
			waitForSelectedContent(mounted.host, "one");

			const body = findDescendant<ImageLabel>(mounted.host, "TabsBody");
			const stroke = body.FindFirstChild("Stroke") as UIStroke | undefined;
			Assert.notUndefined(stroke, "Expected the default theme's TabsBody to carry a Stroke");
			Assert.equal(stroke!.Thickness, DefaultTheme.components.tabs.borderThickness);

			mounted.update(
				themed(extendTheme(DefaultTheme, { components: { tabs: { borderThickness: 0 } } }), {
					defaultValue: "one",
				}),
			);

			waitForLayout(
				() => (body.FindFirstChild("Stroke") === undefined ? true : undefined),
				"Timed out waiting for TabsBody to drop its Stroke with borderThickness 0",
			);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("A LayoutOrder passed to Tabs.Body lands on the TabsBody ImageLabel")
	@Test
	public bodyLayoutOrder() {
		withMounted(400, 300, tabsFixture({ defaultValue: "one", bodyLayoutOrder: 5 }), (mounted) => {
			waitForSelectedContent(mounted.host, "one");

			Assert.equal(findDescendant<ImageLabel>(mounted.host, "TabsBody").LayoutOrder, 5);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Without a LayoutOrder prop TabsBody keeps the engine default of 0")
	@Test
	public bodyLayoutOrderDefault() {
		withMounted(400, 300, tabsFixture({ defaultValue: "one" }), (mounted) => {
			waitForSelectedContent(mounted.host, "one");

			Assert.equal(findDescendant<ImageLabel>(mounted.host, "TabsBody").LayoutOrder, 0);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("A title with only text renders its TabTitleText label and no TabTitleIcon")
	@Test
	public textOnlyTitle() {
		withMounted(600, 300, themedIconTabs("both"), (mounted) => {
			waitForSelectedContent(mounted.host, "both");

			const button = waitForButton(mounted.host, "text");
			Assert.undefined(button.FindFirstChild("TabTitleIcon", true), "Expected a text-only title to have no TabTitleIcon");
			Assert.equal(titleTextOf(button).Text, "Text");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("A title with an icon and text renders both, with the icon ordered and laid out before the label")
	@Test
	public iconBeforeText() {
		withMounted(600, 300, themedIconTabs("both"), (mounted) => {
			waitForSelectedContent(mounted.host, "both");

			const button = waitForButton(mounted.host, "both");
			const icon = waitForGuiObject<ImageLabel>(button, "TabTitleIcon");
			const label = waitForGuiObject<TextLabel>(button, "TabTitleText");

			Assert.equal(label.Text, "Home");
			Assert.true(
				icon.LayoutOrder < label.LayoutOrder,
				`Expected TabTitleIcon LayoutOrder ${icon.LayoutOrder} to be lower than TabTitleText LayoutOrder ${label.LayoutOrder}`,
			);
			assertStackedHorizontally([icon, label], "tab title icon and text");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@Each([["icon"], ["empty"]])
	@DisplayName("A title with an icon and no text, or empty text, renders TabTitleIcon and no TabTitleText")
	@Test
	public iconOnlyTitle(value: string) {
		withMounted(600, 300, themedIconTabs("both"), (mounted) => {
			waitForSelectedContent(mounted.host, "both");

			const button = waitForButton(mounted.host, value);
			waitForGuiObject<ImageLabel>(button, "TabTitleIcon");
			Assert.undefined(
				button.FindFirstChild("TabTitleText", true),
				`Expected TabButton-${value} to render no TabTitleText without text`,
			);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("A selected title's icon takes the focus textColor, the same colour as its own label")
	@Test
	public selectedIconColor() {
		withMounted(600, 300, themedIconTabs("both"), (mounted) => {
			waitForSelectedContent(mounted.host, "both");

			const button = waitForButton(mounted.host, "both");
			Assert.equal(titleIconOf(button).ImageColor3, titleTextOf(button).TextColor3);
			Assert.equal(titleIconOf(button).ImageColor3, FOCUS_TEXT);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Unselected icons, with or without text, take the default textColor that unselected labels use")
	@Test
	public unselectedIconColor() {
		withMounted(600, 300, themedIconTabs("both"), (mounted) => {
			waitForSelectedContent(mounted.host, "both");

			const pair = waitForButton(mounted.host, "pair");
			const unselectedText = titleTextOf(pair).TextColor3;
			Assert.equal(unselectedText, DEFAULT_TEXT);
			Assert.equal(titleIconOf(pair).ImageColor3, unselectedText);
			Assert.equal(titleIconOf(waitForButton(mounted.host, "icon")).ImageColor3, unselectedText);
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Moving the selection swaps icon colours, so an icon-only title turns focus-coloured once selected")
	@Test
	public iconColorFollowsSelection() {
		withMounted(600, 300, themedIconTabs("both"), (mounted) => {
			waitForSelectedContent(mounted.host, "both");

			mounted.update(themedIconTabs("icon"));
			waitForSelectedContent(mounted.host, "icon");

			const iconOnly = titleIconOf(waitForButton(mounted.host, "icon"));
			const both = waitForButton(mounted.host, "both");
			waitForLayout(
				() => (iconOnly.ImageColor3 === FOCUS_TEXT ? true : undefined),
				`Timed out waiting for the selected icon-only title to take the focus textColor (got ${iconOnly.ImageColor3})`,
			);
			Assert.equal(titleIconOf(both).ImageColor3, titleTextOf(both).TextColor3);
			Assert.equal(titleIconOf(both).ImageColor3, DEFAULT_TEXT);
		});
	}
}

export = TabsMountValidation;
