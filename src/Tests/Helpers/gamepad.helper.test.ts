import { Test, Assert, Decorators, Runtime, Tag, DisplayName } from "@rbxts/lunit";
import { GamepadHelper } from "../../Helpers/gamepad.helper";
import { STUDIO_SKIP_MESSAGE } from "./layout";

const { Skip, Each } = Decorators;

function inputType(name: string): Enum.UserInputType {
	const found = Enum.UserInputType.GetEnumItems().find((item) => item.Name === name);
	Assert.notUndefined(found, `Expected Enum.UserInputType.${name} to exist`);
	return found!;
}

function makeFrame(parent: Instance, name: string): Frame {
	const frame = new Instance("Frame");
	frame.Name = name;
	frame.Parent = parent;
	return frame;
}

function withTree(fn: (root: Folder) => void) {
	const root = new Instance("Folder");
	root.Name = "SelectionScopeTree";

	try {
		fn(root);
	} finally {
		root.Destroy();
	}
}

@Tag("Studio")
class GamepadHelperChecks {
	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Every Gamepad1 to Gamepad8 input type counts as gamepad input")
	@Each([["Gamepad1"], ["Gamepad2"], ["Gamepad3"], ["Gamepad4"], ["Gamepad5"], ["Gamepad6"], ["Gamepad7"], ["Gamepad8"]])
	@Test
	public gamepadTypes(name: string) {
		Assert.true(GamepadHelper.isGamepadInputType(inputType(name)), `Expected ${name} to count as gamepad input`);
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Mouse, keyboard, touch and None input types are not gamepad input")
	@Each([["Keyboard"], ["MouseMovement"], ["MouseButton1"], ["MouseWheel"], ["Touch"], ["None"]])
	@Test
	public otherTypes(name: string) {
		Assert.false(GamepadHelper.isGamepadInputType(inputType(name)), `Expected ${name} not to count as gamepad input`);
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("No selection, or no scope, is never inside the scope")
	@Test
	public missingIsOutside() {
		withTree((root) => {
			const scope = makeFrame(root, "Scope");
			const child = makeFrame(scope, "Child");

			Assert.false(GamepadHelper.isSelectionWithin(undefined, scope), "Expected no selection to be outside the scope");
			Assert.false(GamepadHelper.isSelectionWithin(child, undefined), "Expected no scope to contain nothing");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("The scope itself and any nested descendant count as inside the scope")
	@Test
	public scopeAndDescendants() {
		withTree((root) => {
			const scope = makeFrame(root, "Scope");
			const child = makeFrame(scope, "Child");
			const grandchild = makeFrame(child, "Grandchild");

			Assert.true(GamepadHelper.isSelectionWithin(scope, scope), "Expected the scope itself to be inside");
			Assert.true(GamepadHelper.isSelectionWithin(child, scope), "Expected a direct child to be inside");
			Assert.true(GamepadHelper.isSelectionWithin(grandchild, scope), "Expected a nested descendant to be inside");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("A sibling of the scope and an ancestor of the scope both count as outside it")
	@Test
	public siblingsAndAncestorsOutside() {
		withTree((root) => {
			const outer = makeFrame(root, "Outer");
			const scope = makeFrame(outer, "Scope");
			const sibling = makeFrame(outer, "Sibling");

			Assert.false(GamepadHelper.isSelectionWithin(sibling, scope), "Expected a sibling to be outside");
			Assert.false(GamepadHelper.isSelectionWithin(outer, scope), "Expected an ancestor to be outside");
		});
	}

	@Skip(!Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	@DisplayName("Selecting a detached GuiObject never throws, whether or not the engine accepts it")
	@Test
	public trySetSwallowsErrors() {
		const detached = new Instance("Frame");
		detached.Selectable = true;

		try {
			GamepadHelper.trySetSelectedObject(detached);
			GamepadHelper.trySetSelectedObject(undefined);
		} finally {
			detached.Destroy();
		}
	}
}

export = GamepadHelperChecks;
