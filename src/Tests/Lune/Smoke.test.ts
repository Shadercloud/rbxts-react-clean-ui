import { Test, Assert } from "@rbxts/lunit";

class Smoke {
	@Test
	public addsTwoNumbers() {
		Assert.equal(1 + 1, 2);
	}
}

export = Smoke;
