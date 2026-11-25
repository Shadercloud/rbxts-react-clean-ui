import { Test, Assert, Decorators, Tag, DisplayName } from "@rbxts/lunit";

const { Each } = Decorators;
import { resolveTextareaScreenScale, resolveTextareaWholePixels } from "../../../Components/Input/Textarea.layout";

@Tag("Lune")
class TextareaWholePixels {
	@DisplayName("Fractional sizes round up to the next whole design pixel and whole sizes stay put")
	@Each([[124.8, 125], [125.0000001, 125], [125, 125], [25.2, 26], [0, 0]])
	@Test
	public roundsUp(value: number, expected: number) {
		Assert.equal(resolveTextareaWholePixels(value), expected);
	}

	@DisplayName("Negative, NaN and infinite sizes resolve to zero")
	@Each([[-3], [0 / 0], [math.huge], [-math.huge]])
	@Test
	public badValues(value: number) {
		Assert.equal(resolveTextareaWholePixels(value), 0);
	}

	@DisplayName("A measured height within one pixel of design times context scale returns the context scale")
	@Each([[124, 124.8, 1, 1], [161, 160, 1, 1], [159, 160, 1, 1], [180.5, 120, 1.5, 1.5]])
	@Test
	public snapsToContext(screen: number, design: number, context: number, expected: number) {
		Assert.equal(resolveTextareaScreenScale(screen, design, context), expected);
	}

	@DisplayName("A measured height more than one pixel off the context scale returns the measured ratio")
	@Test
	public measuredRatio() {
		Assert.equal(resolveTextareaScreenScale(240, 160, 1), 1.5);
	}

	@DisplayName("Before layout the context scale is used, and a bad context scale resolves to one")
	@Each([[0, 160, 0.75, 0.75], [100, 0, 0, 1]])
	@Test
	public unmeasured(screen: number, design: number, context: number, expected: number) {
		Assert.equal(resolveTextareaScreenScale(screen, design, context), expected);
	}
}

export = TextareaWholePixels;
