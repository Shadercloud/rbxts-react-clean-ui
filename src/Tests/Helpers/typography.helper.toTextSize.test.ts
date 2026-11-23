import { Test, Assert, Tag, DisplayName, Decorators } from "@rbxts/lunit";
import { TypographyHelper } from "../../Helpers/typography.helper";

const { Each } = Decorators;

function fontSizeNamed(name: string): Enum.FontSize {
	return { Name: name } as unknown as Enum.FontSize;
}

@Tag("Lune")
class TypographyToTextSize {
	@Each([
		["Size8", 8],
		["Size10", 10],
		["Size18", 18],
		["Size48", 48],
		["Size96", 96],
	])
	@DisplayName("A SizeN font size name resolves to N pixels")
	@Test
	public parsesPixels(name: string, expected: number) {
		Assert.equal(TypographyHelper.toTextSize(fontSizeNamed(name)), expected);
	}

	@Each([["Legacy"], ["Size"], ["SizeLarge"], ["Size18px"], ["XSize18"]])
	@DisplayName("A font size name that is not Size followed only by digits has no pixel size")
	@Test
	public unknownIsUndefined(name: string) {
		Assert.undefined(TypographyHelper.toTextSize(fontSizeNamed(name)));
	}
}

export = TypographyToTextSize;
