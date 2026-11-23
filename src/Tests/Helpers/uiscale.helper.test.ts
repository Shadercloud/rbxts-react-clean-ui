import { Test, Assert, Tag, DisplayName, Decorators } from "@rbxts/lunit";
import { toDesignPixels, toScreenPixels } from "../../Helpers/uiscale.helper";

const { Each } = Decorators;

const EPSILON = 1e-9;

function assertApprox(actual: number, expected: number, label: string) {
	Assert.true(math.abs(actual - expected) <= EPSILON, `${label}: expected ${expected}, got ${actual}`);
}

@Tag("Lune")
class UiScaleHelperNumber {
	@Each([
		[300, 1.5, 200],
		[100, 1.25, 80],
		[420, 1.25, 336],
		[0, 1.5, 0],
		[-30, 1.5, -20],
	])
	@DisplayName("Screen pixels divided by the scale give design pixels")
	@Test
	public designDivides(value: number, scale: number, expected: number) {
		assertApprox(toDesignPixels(value, scale), expected, `toDesignPixels(${value}, ${scale})`);
	}

	@Each([
		[200, 1.5, 300],
		[80, 1.25, 100],
		[336, 1.25, 420],
		[0, 1.5, 0],
		[-20, 1.5, -30],
	])
	@DisplayName("Design pixels multiplied by the scale give screen pixels")
	@Test
	public screenMultiplies(value: number, scale: number, expected: number) {
		assertApprox(toScreenPixels(value, scale), expected, `toScreenPixels(${value}, ${scale})`);
	}

	@Each([
		[123.4, 1.25],
		[777, 1.5],
		[1, 1.2],
		[59.5, 0.75],
	])
	@DisplayName("Converting to design pixels and back to screen pixels returns the original value")
	@Test
	public roundTrip(value: number, scale: number) {
		assertApprox(toScreenPixels(toDesignPixels(value, scale), scale), value, `round trip of ${value} at ${scale}`);
		assertApprox(toDesignPixels(toScreenPixels(value, scale), scale), value, `reverse round trip of ${value} at ${scale}`);
	}

	@Each([[0], [1], [123.4], [-50]])
	@DisplayName("At scale 1 both conversions return the value unchanged")
	@Test
	public identityAtOne(value: number) {
		Assert.equal(toDesignPixels(value, 1), value);
		Assert.equal(toScreenPixels(value, 1), value);
	}
}

export = UiScaleHelperNumber;
