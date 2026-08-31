import { Test, Assert } from "@rbxts/lunit";
import { resolveValidatedText, resolveClampedText } from "../../Components/Input/Input.validation";

class InputNumberValidation {
	@Test
	public keepsLastValidTextWhenAnInvalidCharacterIsTyped() {
		let lastValid = "";

		for (const candidate of ["1", "12", "123", "123A"]) {
			const resolved = resolveValidatedText("Number", candidate, lastValid);
			if (resolved === candidate) {
				lastValid = candidate;
			}
		}

		Assert.equal(lastValid, "123");
	}

	@Test
	public clampsDownToMaxWhenTextIsOverRange() {
		const resolved = resolveClampedText("Number", "50", 0, 10);

		Assert.equal(resolved, "10");
	}

	@Test
	public clampsUpToMinWhenTextIsUnderRange() {
		const resolved = resolveClampedText("Number", "-5", 0, 10);

		Assert.equal(resolved, "0");
	}

	@Test
	public returnsUndefinedWhenTextIsWithinRange() {
		const resolved = resolveClampedText("Number", "5", 0, 10);

		Assert.undefined(resolved);
	}

	@Test
	public returnsUndefinedWhenTextIsNonNumeric() {
		const resolved = resolveClampedText("Number", "abc", 0, 10);

		Assert.undefined(resolved);
	}
}

export = InputNumberValidation;
