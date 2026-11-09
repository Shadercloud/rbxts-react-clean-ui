import { Test, Assert, Decorators, Runtime, Tag, DisplayName } from "@rbxts/lunit";
import { SizeHelper } from "../../Helpers/size.helper";
import { CssPixelSize } from "../../Interfaces/css.types";
import { STUDIO_SKIP_MESSAGE } from "./layout";

const { Each, Skip } = Decorators;

function constraintOf(props: Parameters<typeof SizeHelper.GetSizeConstraint>[0]) {
	const constraint = SizeHelper.GetSizeConstraint(props);
	Assert.notUndefined(constraint, "Expected a size constraint when a min or max prop is set");
	return constraint!;
}

@Tag("Studio")
class SizeConstraintResolution {
	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("With no min or max prop the helper returns undefined so no UISizeConstraint is rendered")
	@Test
	public unsetIsUndefined() {
		Assert.undefined(SizeHelper.GetSizeConstraint({}));
		Assert.undefined(SizeHelper.GetSizeConstraint({ width: 100, height: "50%" }));
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Only a maxWidth leaves both minimums at 0 and the other maximum unbounded")
	@Test
	public unsetDefaults() {
		const constraint = constraintOf({ maxWidth: 200 });

		Assert.equal(constraint.MinSize, new Vector2(0, 0));
		Assert.equal(constraint.MaxSize.X, 200);
		Assert.equal(constraint.MaxSize.Y, math.huge);
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Only a minHeight leaves both maximums unbounded")
	@Test
	public minOnlyUnbounded() {
		const constraint = constraintOf({ minHeight: 10 });

		Assert.equal(constraint.MinSize, new Vector2(0, 10));
		Assert.equal(constraint.MaxSize.X, math.huge);
		Assert.equal(constraint.MaxSize.Y, math.huge);
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("All four props map straight onto MinSize and MaxSize")
	@Test
	public allFourMapped() {
		const constraint = constraintOf({ minWidth: 10, maxWidth: 300, minHeight: 20, maxHeight: 400 });

		Assert.equal(constraint.MinSize, new Vector2(10, 20));
		Assert.equal(constraint.MaxSize, new Vector2(300, 400));
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("A negative minimum is clamped to 0 on both axes")
	@Test
	public negativeMinZero() {
		const constraint = constraintOf({ minWidth: -5, minHeight: "-12px" });

		Assert.equal(constraint.MinSize, new Vector2(0, 0));
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("A maximum below its minimum is raised to the minimum on each axis")
	@Test
	public maxRaisedToMin() {
		const constraint = constraintOf({ minWidth: 100, maxWidth: 50, minHeight: 40, maxHeight: 10 });

		Assert.equal(constraint.MinSize, new Vector2(100, 40));
		Assert.equal(constraint.MaxSize, new Vector2(100, 40));
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("A negative maximum with no minimum is raised to the 0 minimum")
	@Test
	public negativeMaxZero() {
		const constraint = constraintOf({ maxWidth: -10 });

		Assert.equal(constraint.MaxSize.X, 0);
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@Each([[25], ["25"], ["25px"], [" 25 px "]])
	@DisplayName("Numbers, bare numeric strings and px strings all resolve to the same pixel value")
	@Test
	public pixelParsing(value: CssPixelSize) {
		const constraint = constraintOf({ minWidth: value, maxWidth: value, minHeight: value, maxHeight: value });

		Assert.equal(constraint.MinSize, new Vector2(25, 25));
		Assert.equal(constraint.MaxSize, new Vector2(25, 25));
	}
}

export = SizeConstraintResolution;
