import { TestRunner } from "@rbxts/lunit";

export function runPackageTests() {
	return new TestRunner([script.Parent]).run();
}
