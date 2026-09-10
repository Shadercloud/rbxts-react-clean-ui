import { Test, Assert, Tag, DisplayName } from "@rbxts/lunit";
import { resolveValidatedText, resolveClampedText } from "../../../Components/Input/Input.validation";

@Tag("Lune")
class InputNumberValidation {
	@DisplayName("Number validation rejects a candidate containing a letter and keeps the previous numeric text")
	@Test
	public rejectsInvalidChar() {
		let lastValid = "";

		for (const candidate of ["1", "12", "123", "123A"]) {
			const resolved = resolveValidatedText("Number", candidate, lastValid);
			if (resolved === candidate) {
				lastValid = candidate;
			}
		}

		Assert.equal(lastValid, "123");
	}

	@DisplayName("Text above the range resolves to the max as a string")
	@Test
	public clampsToMax() {
		const resolved = resolveClampedText("Number", "50", 0, 10);

		Assert.equal(resolved, "10");
	}

	@DisplayName("Negative text below the range resolves to the min as a string")
	@Test
	public clampsToMin() {
		const resolved = resolveClampedText("Number", "-5", 0, 10);

		Assert.equal(resolved, "0");
	}

	@DisplayName("Text already inside the range needs no clamping and resolves to undefined")
	@Test
	public inRangeUntouched() {
		const resolved = resolveClampedText("Number", "5", 0, 10);

		Assert.undefined(resolved);
	}

	@DisplayName("Non-numeric text cannot be clamped and resolves to undefined")
	@Test
	public nonNumericUntouched() {
		const resolved = resolveClampedText("Number", "abc", 0, 10);

		Assert.undefined(resolved);
	}
}

export = InputNumberValidation;
