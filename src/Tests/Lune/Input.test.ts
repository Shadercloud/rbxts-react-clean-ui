import { Test, Assert } from "@rbxts/lunit";
import { resolveValidatedText } from "../../Components/Input/Input.validation";

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
}

export = InputNumberValidation;
