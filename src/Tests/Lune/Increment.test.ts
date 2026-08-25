import { Test, Assert } from "@rbxts/lunit";
import { resolveSteppedValue } from "../../Components/Input/Increment.step";

class IncrementStepValidation {
	@Test
	public incrementsByDefaultStepWithNoBounds() {
		Assert.equal(resolveSteppedValue(5, "increment", 1), 6);
	}

	@Test
	public decrementsByDefaultStepWithNoBounds() {
		Assert.equal(resolveSteppedValue(5, "decrement", 1), 4);
	}

	@Test
	public incrementsByCustomStepWithNoBounds() {
		Assert.equal(resolveSteppedValue(10, "increment", 5), 15);
	}

	@Test
	public decrementsByCustomStepWithNoBounds() {
		Assert.equal(resolveSteppedValue(10, "decrement", 5), 5);
	}

	@Test
	public incrementingPastMaxClampsToMax() {
		Assert.equal(resolveSteppedValue(8, "increment", 5, 0, 10), 10);
	}

	@Test
	public decrementingPastMinClampsToMin() {
		Assert.equal(resolveSteppedValue(2, "decrement", 5, 0, 10), 0);
	}

	@Test
	public incrementingWhenAlreadyAtMaxReturnsUndefined() {
		Assert.undefined(resolveSteppedValue(10, "increment", 1, 0, 10));
	}

	@Test
	public decrementingWhenAlreadyAtMinReturnsUndefined() {
		Assert.undefined(resolveSteppedValue(0, "decrement", 1, 0, 10));
	}

	@Test
	public repeatedDecimalStepIncrementsLandOnExactValue() {
		let current = 0;

		for (let index = 0; index < 10; index++) {
			current = resolveSteppedValue(current, "increment", 0.1)!;
		}

		Assert.equal(current, 1);
	}

	@Test
	public repeatedDecimalStepIncrementsDoNotDriftOverManyCalls() {
		let current = 0;

		for (let index = 0; index < 90; index++) {
			current = resolveSteppedValue(current, "increment", 0.1)!;
		}

		Assert.equal(current, 9);
	}

	@Test
	public repeatedDecimalStepDecrementsLandOnExactValue() {
		let current = 1;

		for (let index = 0; index < 10; index++) {
			current = resolveSteppedValue(current, "decrement", 0.1)!;
		}

		Assert.equal(current, 0);
	}

	@Test
	public repeatedDifferentDecimalStepIncrementsLandOnExactValue() {
		let current = 0;

		for (let index = 0; index < 10; index++) {
			current = resolveSteppedValue(current, "increment", 0.3)!;
		}

		Assert.equal(current, 3);
	}
}

export = IncrementStepValidation;
