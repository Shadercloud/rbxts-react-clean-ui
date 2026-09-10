import { Test, Assert, Tag, DisplayName } from "@rbxts/lunit";
import { resolveSteppedValue } from "../../../Components/Input/Increment.step";

@Tag("Lune")
class IncrementStepValidation {
	@DisplayName("Increments by the default step when no bounds are set")
	@Test
	public defaultStep() {
		Assert.equal(resolveSteppedValue(5, "increment", 1), 6);
	}

	@DisplayName("Decrements by the default step when no bounds are set")
	@Test
	public defaultStepDown() {
		Assert.equal(resolveSteppedValue(5, "decrement", 1), 4);
	}

	@DisplayName("Increments by a custom step size when no bounds are set")
	@Test
	public customStep() {
		Assert.equal(resolveSteppedValue(10, "increment", 5), 15);
	}

	@DisplayName("Decrements by a custom step size when no bounds are set")
	@Test
	public customStepDown() {
		Assert.equal(resolveSteppedValue(10, "decrement", 5), 5);
	}

	@DisplayName("A step that would overshoot max is clamped to max")
	@Test
	public clampsToMax() {
		Assert.equal(resolveSteppedValue(8, "increment", 5, 0, 10), 10);
	}

	@DisplayName("A step that would undershoot min is clamped to min")
	@Test
	public clampsToMin() {
		Assert.equal(resolveSteppedValue(2, "decrement", 5, 0, 10), 0);
	}

	@DisplayName("Returns undefined instead of a new value when already sitting at max")
	@Test
	public noOpAtMax() {
		Assert.undefined(resolveSteppedValue(10, "increment", 1, 0, 10));
	}

	@DisplayName("Returns undefined instead of a new value when already sitting at min")
	@Test
	public noOpAtMin() {
		Assert.undefined(resolveSteppedValue(0, "decrement", 1, 0, 10));
	}

	@DisplayName("Ten increments of 0.1 land exactly on 1 with no floating-point error")
	@Test
	public decimalStepExact() {
		let current = 0;

		for (let index = 0; index < 10; index++) {
			current = resolveSteppedValue(current, "increment", 0.1)!;
		}

		Assert.equal(current, 1);
	}

	@DisplayName("Ninety increments of 0.1 stay exact and never accumulate drift")
	@Test
	public noDecimalDrift() {
		let current = 0;

		for (let index = 0; index < 90; index++) {
			current = resolveSteppedValue(current, "increment", 0.1)!;
		}

		Assert.equal(current, 9);
	}

	@DisplayName("Ten decrements of 0.1 from 1 land exactly on 0")
	@Test
	public decimalStepDownExact() {
		let current = 1;

		for (let index = 0; index < 10; index++) {
			current = resolveSteppedValue(current, "decrement", 0.1)!;
		}

		Assert.equal(current, 0);
	}

	@DisplayName("Ten increments of 0.3 land exactly on 3 despite the awkward binary fraction")
	@Test
	public oddDecimalStepExact() {
		let current = 0;

		for (let index = 0; index < 10; index++) {
			current = resolveSteppedValue(current, "increment", 0.3)!;
		}

		Assert.equal(current, 3);
	}
}

export = IncrementStepValidation;
