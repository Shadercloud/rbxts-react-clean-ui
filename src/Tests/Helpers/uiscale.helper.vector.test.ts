import { Test, Assert, Decorators, Runtime, Tag, DisplayName } from "@rbxts/lunit";
import { toDesignPixels, toScreenPixels } from "../../Helpers/uiscale.helper";
import { STUDIO_SKIP_MESSAGE } from "./layout";

const { Skip, Each } = Decorators;

const EPSILON = 1e-4;

function assertVectorApprox(actual: Vector2, expected: Vector2, label: string) {
	Assert.true(
		math.abs(actual.X - expected.X) <= EPSILON && math.abs(actual.Y - expected.Y) <= EPSILON,
		`${label}: expected (${expected.X}, ${expected.Y}), got (${actual.X}, ${actual.Y})`,
	);
}

@Tag("Studio")
class UiScaleHelperVector {
	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@Each([
		[300, 150, 1.5, 200, 100],
		[1000, 500, 1.25, 800, 400],
		[64, 32, 1, 64, 32],
	])
	@DisplayName("A Vector2 in screen pixels is divided by the scale on both axes")
	@Test
	public designDivides(x: number, y: number, scale: number, expectedX: number, expectedY: number) {
		const result = toDesignPixels(new Vector2(x, y), scale);

		Assert.true(typeIs(result, "Vector2"), "Expected a Vector2 input to produce a Vector2");
		assertVectorApprox(result, new Vector2(expectedX, expectedY), `toDesignPixels((${x}, ${y}), ${scale})`);
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@Each([
		[200, 100, 1.5, 300, 150],
		[800, 400, 1.25, 1000, 500],
		[64, 32, 1, 64, 32],
	])
	@DisplayName("A Vector2 in design pixels is multiplied by the scale on both axes")
	@Test
	public screenMultiplies(x: number, y: number, scale: number, expectedX: number, expectedY: number) {
		const result = toScreenPixels(new Vector2(x, y), scale);

		Assert.true(typeIs(result, "Vector2"), "Expected a Vector2 input to produce a Vector2");
		assertVectorApprox(result, new Vector2(expectedX, expectedY), `toScreenPixels((${x}, ${y}), ${scale})`);
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@Each([[1.25], [1.5], [1.2]])
	@DisplayName("A Vector2 converted to design pixels and back keeps its original components")
	@Test
	public roundTrip(scale: number) {
		const value = new Vector2(123.5, 77.25);

		assertVectorApprox(toScreenPixels(toDesignPixels(value, scale), scale), value, `round trip at ${scale}`);
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Vector2.zero stays zero at any scale")
	@Test
	public zeroStaysZero() {
		assertVectorApprox(toDesignPixels(Vector2.zero, 1.5), Vector2.zero, "toDesignPixels(zero)");
		assertVectorApprox(toScreenPixels(Vector2.zero, 1.5), Vector2.zero, "toScreenPixels(zero)");
	}
}

export = UiScaleHelperVector;
