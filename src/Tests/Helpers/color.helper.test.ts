import { Test, Assert, Tag, DisplayName } from "@rbxts/lunit";
import { ColorHelper } from "../../Helpers/color.helper";
import { CssBackgroundGradient } from "../../Interfaces/css.types";
import { DefaultTheme, IntentScheme, ThemeTemplate } from "../../Theme";

const RED = Color3.fromRGB(255, 0, 0);
const GREEN = Color3.fromRGB(0, 255, 0);
const BLUE = Color3.fromRGB(0, 0, 255);
const WHITE = Color3.fromRGB(255, 255, 255);
const BLACK = Color3.fromRGB(0, 0, 0);

function themeWith(primaryDefault: Partial<IntentScheme> = {}): ThemeTemplate {
	const base = { textColor: BLACK, backgroundColor: WHITE, borderColor: BLACK };

	return {
		colors: {
			intents: {
				primary: { default: { ...base, ...primaryDefault } },
				danger: { default: base },
			},
		},
	} as unknown as ThemeTemplate;
}

function assertSameScheme(actual: IntentScheme, expected: IntentScheme, label: string) {
	Assert.equal(actual.textColor, expected.textColor, `${label}: textColor`);
	Assert.equal(actual.backgroundColor, expected.backgroundColor, `${label}: backgroundColor`);
	Assert.equal(actual.borderColor, expected.borderColor, `${label}: borderColor`);
	Assert.equal(actual.backgroundTransparency, expected.backgroundTransparency, `${label}: backgroundTransparency`);
	Assert.equal(actual.borderThickness, expected.borderThickness, `${label}: borderThickness`);
	Assert.equal(actual.backgroundGradient === undefined, expected.backgroundGradient === undefined, `${label}: gradient presence`);
	Assert.equal(actual.backgroundGradient?.rotation, expected.backgroundGradient?.rotation, `${label}: gradient rotation`);
}

function gradientOf(scheme: IntentScheme): Partial<CssBackgroundGradient> {
	Assert.notUndefined(scheme.backgroundGradient, "Expected the merged scheme to carry a backgroundGradient");
	return scheme.backgroundGradient!;
}

function assertColors(actual: Partial<CssBackgroundGradient>["colors"], expected: Color3[], label: string) {
	Assert.notUndefined(actual, `${label}: expected merged colours`);
	const colors = actual as Color3[];

	Assert.equal(colors.size(), expected.size(), `${label}: expected ${expected.size()} colours, got ${colors.size()}`);

	for (let index = 0; index < expected.size(); index++) {
		Assert.equal(colors[index], expected[index], `${label}: colour ${index} mismatch`);
	}
}

@Tag("Studio")
class IntentGradientMerge {
	@DisplayName("A hover layer that sets only rotation keeps the default layer's colours and overrides its rotation")
	@Test
	public hoverKeepsColors() {
		const scheme = ColorHelper.getIntentColors(themeWith(), "primary", "hover", {
			primary: {
				default: { backgroundGradient: { colors: [RED, BLUE], rotation: 90 } },
				hover: { backgroundGradient: { rotation: 45 } },
			},
		});
		const gradient = gradientOf(scheme);

		assertColors(gradient.colors, [RED, BLUE], "hover merge");
		Assert.equal(gradient.rotation, 45);
	}

	@DisplayName("The default state ignores the hover layer and keeps the default rotation")
	@Test
	public defaultStateRotation() {
		const scheme = ColorHelper.getIntentColors(themeWith(), "primary", "default", {
			primary: {
				default: { backgroundGradient: { colors: [RED, BLUE], rotation: 90 } },
				hover: { backgroundGradient: { rotation: 45 } },
			},
		});

		Assert.equal(gradientOf(scheme).rotation, 90);
	}

	@DisplayName("When no theme or component layer sets a gradient the merged backgroundGradient is undefined")
	@Test
	public noGradientLayer() {
		const scheme = ColorHelper.getIntentColors(themeWith(), "primary", "hover", {
			primary: {
				default: { backgroundColor: GREEN },
				hover: { backgroundColor: BLUE },
			},
		});

		Assert.undefined(scheme.backgroundGradient);
		Assert.equal(scheme.backgroundColor, BLUE);
	}

	@DisplayName("A later layer's colours replace the earlier array outright instead of merging index by index")
	@Test
	public colorsReplaced() {
		const scheme = ColorHelper.getIntentColors(themeWith(), "primary", "hover", {
			primary: {
				default: { backgroundGradient: { colors: [RED, GREEN, BLUE] } },
				hover: { backgroundGradient: { colors: [WHITE, BLACK] } },
			},
		});

		assertColors(gradientOf(scheme).colors, [WHITE, BLACK], "replaced colours");
	}

	@DisplayName("A later layer that sets colours but no stops drops the earlier stops so its colours space evenly")
	@Test
	public colorsResetStops() {
		const scheme = ColorHelper.getIntentColors(themeWith(), "primary", "hover", {
			primary: {
				default: { backgroundGradient: { colors: [RED, GREEN, BLUE], stops: [0, 0.2, 1] } },
				hover: { backgroundGradient: { colors: [WHITE, BLACK, GREEN] } },
			},
		});
		const gradient = gradientOf(scheme);

		assertColors(gradient.colors, [WHITE, BLACK, GREEN], "hover colours");
		Assert.undefined(gradient.stops);
	}

	@DisplayName("A later layer that sets both colours and stops keeps its own stops over the earlier ones")
	@Test
	public ownStopsKept() {
		const scheme = ColorHelper.getIntentColors(themeWith(), "primary", "hover", {
			primary: {
				default: { backgroundGradient: { colors: [RED, GREEN, BLUE], stops: [0, 0.2, 1] } },
				hover: { backgroundGradient: { colors: [WHITE, BLACK, GREEN], stops: [0, 0.7, 1] } },
			},
		});
		const gradient = gradientOf(scheme);

		assertColors(gradient.colors, [WHITE, BLACK, GREEN], "hover colours");
		Assert.deepEqual(gradient.stops, [0, 0.7, 1]);
	}

	@DisplayName("A later layer that sets only stops repositions the inherited colours")
	@Test
	public stopsRepositionColors() {
		const scheme = ColorHelper.getIntentColors(themeWith(), "primary", "hover", {
			primary: {
				default: { backgroundGradient: { colors: [RED, GREEN, BLUE], stops: [0, 0.2, 1] } },
				hover: { backgroundGradient: { stops: [0, 0.8, 1] } },
			},
		});
		const gradient = gradientOf(scheme);

		assertColors(gradient.colors, [RED, GREEN, BLUE], "inherited colours");
		Assert.deepEqual(gradient.stops, [0, 0.8, 1]);
	}

	@DisplayName("A later layer that sets only colours still inherits the earlier layer's rotation")
	@Test
	public colorsKeepRotation() {
		const scheme = ColorHelper.getIntentColors(themeWith(), "primary", "hover", {
			primary: {
				default: { backgroundGradient: { colors: [RED, BLUE], rotation: 90 } },
				hover: { backgroundGradient: { colors: [WHITE, BLACK] } },
			},
		});
		const gradient = gradientOf(scheme);

		assertColors(gradient.colors, [WHITE, BLACK], "hover colours");
		Assert.equal(gradient.rotation, 90);
	}

	@DisplayName("An explicit undefined stops on a colourless layer counts as unset and keeps the inherited stops")
	@Test
	public undefinedStopsIgnored() {
		const scheme = ColorHelper.getIntentColors(themeWith(), "primary", "hover", {
			primary: {
				default: { backgroundGradient: { colors: [RED, GREEN, BLUE], stops: [0, 0.2, 1] } },
				hover: { backgroundGradient: { rotation: 45, stops: undefined } },
			},
		});
		const gradient = gradientOf(scheme);

		assertColors(gradient.colors, [RED, GREEN, BLUE], "inherited colours");
		Assert.deepEqual(gradient.stops, [0, 0.2, 1]);
		Assert.equal(gradient.rotation, 45);
	}

	@DisplayName("A flat override setting only rotation refines the theme gradient and leaves the theme's own value untouched")
	@Test
	public overrideRefinesTheme() {
		const theme = themeWith({ backgroundGradient: { colors: [RED, BLUE], rotation: 90 } });
		const scheme = ColorHelper.getIntentColors(theme, "primary", "default", undefined, {
			primary: { backgroundGradient: { rotation: 45 } },
		});
		const gradient = gradientOf(scheme);

		assertColors(gradient.colors, [RED, BLUE], "theme colours");
		Assert.equal(gradient.rotation, 45);
		Assert.equal(theme.colors.intents.primary.default.backgroundGradient!.rotation, 90);
	}

	@DisplayName("A matching-intent state layer refines the gradient supplied by the primary intent's default layer")
	@Test
	public matchingIntentRefines() {
		const scheme = ColorHelper.getIntentColors(themeWith(), "danger", "focus", {
			primary: { default: { backgroundGradient: { colors: [RED, BLUE], offset: new Vector2(0.5, 0) } } },
			danger: { focus: { backgroundGradient: { rotation: 180 } } },
		});
		const gradient = gradientOf(scheme);

		assertColors(gradient.colors, [RED, BLUE], "primary colours");
		Assert.equal(gradient.offset, new Vector2(0.5, 0));
		Assert.equal(gradient.rotation, 180);
	}

	@DisplayName("The secondary intent resolves DefaultTheme's own button secondary scheme, per state, instead of the primary one")
	@Test
	public secondaryFromTheme() {
		const intents = DefaultTheme.components.button.intents;
		const scheme = ColorHelper.getIntentColors(DefaultTheme, "secondary", "default", intents);
		const hover = ColorHelper.getIntentColors(DefaultTheme, "secondary", "hover", intents);
		const primary = ColorHelper.getIntentColors(DefaultTheme, "primary", "default", intents);

		Assert.equal(scheme.backgroundColor, Color3.fromHex("#E4E7EC"));
		Assert.equal(scheme.textColor, Color3.fromHex("#1D2433"));
		Assert.equal(scheme.borderColor, Color3.fromHex("#C5CAD3"));
		Assert.equal(hover.backgroundColor, Color3.fromHex("#D5D9E0"));
		Assert.equal(hover.borderColor, Color3.fromHex("#B8BEC9"));
		Assert.notEqual(scheme.backgroundColor, primary.backgroundColor);
	}

	@DisplayName("With no secondary entry in the theme or component colours, secondary resolves exactly like primary in every state")
	@Test
	public secondaryFallsBack() {
		const componentColors = {
			primary: {
				default: { textColor: RED, backgroundColor: GREEN, backgroundTransparency: 0.2, borderThickness: 2 },
				hover: { backgroundColor: BLUE, backgroundGradient: { colors: [RED, BLUE], rotation: 30 } },
			},
		};

		for (const state of ["default", "hover", "focus", "disabled"] as const) {
			assertSameScheme(
				ColorHelper.getIntentColors(themeWith(), "secondary", state, componentColors),
				ColorHelper.getIntentColors(themeWith(), "primary", state, componentColors),
				`secondary vs primary (${state})`,
			);
		}
	}

	@DisplayName("A secondary component entry layers over the primary one, so keys it leaves unset still come from primary")
	@Test
	public secondaryLayersOverPrimary() {
		const scheme = ColorHelper.getIntentColors(themeWith(), "secondary", "default", {
			primary: { default: { textColor: RED, backgroundColor: GREEN, borderThickness: 2 } },
			secondary: { default: { backgroundColor: BLUE, borderThickness: 3 } },
		});

		Assert.equal(scheme.textColor, RED);
		Assert.equal(scheme.backgroundColor, BLUE);
		Assert.equal(scheme.borderThickness, 3);
	}
}

export = IntentGradientMerge;
