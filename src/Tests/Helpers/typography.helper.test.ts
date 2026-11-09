import { Test, Assert, Tag, DisplayName, Decorators } from "@rbxts/lunit";
import { TypographyHelper } from "../../Helpers/typography.helper";

const { Each } = Decorators;

function assertFamilyEndsWith(face: Font, suffix: string, label: string) {
	Assert.equal(
		face.Family.sub(-suffix.size()),
		suffix,
		`${label}: expected Family to end with ${suffix}, got ${face.Family}`,
	);
}

@Tag("Studio")
class TypographyFontFace {
	@Each([
		[Enum.Font.Fantasy, "Balthazar.json"],
		[Enum.Font.Garamond, "Guru.json"],
		[Enum.Font.Bodoni, "AccanthisADFStd.json"],
		[Enum.Font.Antique, "RomanAntique.json"],
	])
	@DisplayName("Legacy enums whose name differs from their family resolve to the real family file")
	@Test
	public legacyFamily(font: Enum.Font, suffix: string) {
		assertFamilyEndsWith(TypographyHelper.toFontFace(font), suffix, font.Name);
	}

	@Each([
		[Enum.Font.Merriweather, Enum.FontWeight.Regular],
		[Enum.Font.Fondamento, Enum.FontWeight.Bold],
		[Enum.Font.BuilderSans, Enum.FontWeight.Medium],
	])
	@DisplayName("Enums whose name already matches their family produce the same Family and Weight as Font.fromName")
	@Test
	public matchesFromName(font: Enum.Font, weight: Enum.FontWeight) {
		const face = TypographyHelper.toFontFace(font, weight);
		const expected = Font.fromName(font.Name, weight);

		Assert.equal(face.Family, expected.Family, `${font.Name}: Family mismatch`);
		Assert.equal(face.Weight, expected.Weight, `${font.Name}: Weight mismatch`);
	}

	@DisplayName("A requested Bold weight is kept on the resolved face")
	@Test
	public keepsBold() {
		const face = TypographyHelper.toFontFace(Enum.Font.Fantasy, Enum.FontWeight.Bold);

		Assert.equal(face.Weight, Enum.FontWeight.Bold);
	}

	@DisplayName("A requested Regular weight overrides the Bold baked into SourceSansBold")
	@Test
	public overridesBakedWeight() {
		const face = TypographyHelper.toFontFace(Enum.Font.SourceSansBold, Enum.FontWeight.Regular);

		Assert.equal(face.Weight, Enum.FontWeight.Regular);
	}

	@DisplayName("Omitting weight and style gives a Regular, Normal face")
	@Test
	public defaultWeightAndStyle() {
		const face = TypographyHelper.toFontFace(Enum.Font.Fantasy);

		Assert.equal(face.Weight, Enum.FontWeight.Regular);
		Assert.equal(face.Style, Enum.FontStyle.Normal);
	}

	@DisplayName("Enum.Font.Unknown falls back without throwing and still returns a Font")
	@Test
	public unknownFallsBack() {
		const [ok, result] = pcall(() => TypographyHelper.toFontFace(Enum.Font.Unknown));

		Assert.true(ok, `Expected toFontFace(Unknown) not to throw, got ${result}`);
		Assert.equal(typeOf(result), "Font", `Expected a Font, got ${typeOf(result)}`);
	}
}

export = TypographyFontFace;
