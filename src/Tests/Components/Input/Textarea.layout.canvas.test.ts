import { Test, Assert, Decorators, Tag, DisplayName } from "@rbxts/lunit";

const { Each } = Decorators;
import { resolveTextareaCanvasHeight } from "../../../Components/Input/Textarea.layout";

const VIEWPORT = 160;
const PADDING = 12;

@Tag("Lune")
class TextareaCanvasTolerance {
	@DisplayName("Content within one screen pixel of the view counts as fitting, measured in design px at the given scale")
	@Each([[1.5, 160.6, 160], [1.5, 160.7, 160.7], [0.75, 161.3, 160], [0.75, 161.4, 161.4], [1, 161, 160], [1, 161.5, 161.5]])
	@Test
	public scaledTolerance(scale: number, content: number, expected: number) {
		Assert.equal(resolveTextareaCanvasHeight(content, 0, 0, VIEWPORT, scale), expected);
	}

	@DisplayName("At scale 0.75 the fitting tolerance is four thirds of a design pixel")
	@Test
	public threeQuarterTolerance() {
		Assert.equal(resolveTextareaCanvasHeight(VIEWPORT + 4 / 3, 0, 0, VIEWPORT, 0.75), VIEWPORT);
		Assert.equal(resolveTextareaCanvasHeight(VIEWPORT + 4 / 3 + 0.01, 0, 0, VIEWPORT, 0.75), VIEWPORT + 4 / 3 + 0.01);
	}

	@DisplayName("A zero, negative or NaN screen scale uses a one design pixel tolerance")
	@Each([[0], [-2], [0 / 0]])
	@Test
	public badScale(scale: number) {
		Assert.equal(resolveTextareaCanvasHeight(160.9, 0, 0, VIEWPORT, scale), VIEWPORT);
		Assert.equal(resolveTextareaCanvasHeight(161, 0, 0, VIEWPORT, scale), VIEWPORT);
		Assert.equal(resolveTextareaCanvasHeight(161.5, 0, 0, VIEWPORT, scale), 161.5);
	}

	@DisplayName("Four-argument calls match an explicit scale of one with padding included")
	@Each([[136.75], [137], [137.5], [200], [0]])
	@Test
	public fourArgsMatch(textHeight: number) {
		Assert.equal(
			resolveTextareaCanvasHeight(textHeight, PADDING, PADDING, VIEWPORT),
			resolveTextareaCanvasHeight(textHeight, PADDING, PADDING, VIEWPORT, 1),
		);
	}

	@DisplayName("Four-argument calls still fit content up to one pixel over the view and grow past it")
	@Test
	public fourArgsValues() {
		Assert.equal(resolveTextareaCanvasHeight(136.75, PADDING, PADDING, VIEWPORT), VIEWPORT);
		Assert.equal(resolveTextareaCanvasHeight(137, PADDING, PADDING, VIEWPORT), VIEWPORT);
		Assert.equal(resolveTextareaCanvasHeight(137.5, PADDING, PADDING, VIEWPORT), 161.5);
	}
}

export = TextareaCanvasTolerance;
