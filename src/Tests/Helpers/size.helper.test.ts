import { Test, Assert, Decorators, Tag, DisplayName } from "@rbxts/lunit";
import { SizeHelper } from "../../Helpers/size.helper";
import { CssRadiusToken, CssSize } from "../../Interfaces/css.types";
import { ThemeTemplate } from "../../Theme";

const { Each } = Decorators;

const RADIUS_THEME = {
	radius: { sm: 3, md: 7, lg: 11, default: "md" },
} as unknown as ThemeTemplate;

@Tag("Lune")
class RadiusTokenResolution {
	@Each([
		["sm", 3],
		["md", 7],
		["lg", 11],
	])
	@DisplayName("A radius token resolves to the matching entry of the theme's radius scale")
	@Test
	public tokenResolves(token: CssRadiusToken, expected: number) {
		Assert.equal(SizeHelper.resolveRadius(RADIUS_THEME, token), expected);
	}

	@Each([[8], [0], ["50%"], ["12px"]])
	@DisplayName("A pixel or percent radius is returned unchanged so the caller's own parser still handles it")
	@Test
	public sizePassesThrough(radius: CssSize) {
		Assert.equal(SizeHelper.resolveRadius(RADIUS_THEME, radius), radius);
	}

	@DisplayName("An unset radius stays undefined instead of falling back to a theme value")
	@Test
	public undefinedStaysUnset() {
		Assert.undefined(SizeHelper.resolveRadius(RADIUS_THEME, undefined));
	}
}

export = RadiusTokenResolution;
