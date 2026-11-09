import React from "@rbxts/react";
import { Assert } from "@rbxts/lunit";

import { MountedElement } from "./layout";

interface HostFiber {
	child?: HostFiber;
	sibling?: HostFiber;
	stateNode?: unknown;
	memoizedProps?: Map<unknown, unknown>;
}

export function findHostFiber(mounted: MountedElement, instance: Instance): HostFiber {
	const internalRoot = (mounted.root as unknown as { _internalRoot: { current: HostFiber } })._internalRoot;
	const pending: HostFiber[] = [internalRoot.current];

	while (pending.size() > 0) {
		const fiber = pending.pop()!;
		if (fiber.stateNode === instance) return fiber;
		if (fiber.child !== undefined) pending.push(fiber.child);
		if (fiber.sibling !== undefined) pending.push(fiber.sibling);
	}

	return Assert.fail(`Expected a mounted host fiber for ${instance.GetFullName()}`);
}

export function activateButton(mounted: MountedElement, button: GuiButton) {
	const activatedKey = (React as unknown as { Event: Record<string, unknown> }).Event.Activated;
	const handler = findHostFiber(mounted, button).memoizedProps?.get(activatedKey) as
		((rbx: GuiButton, input: unknown, clickCount: number) => void) | undefined;

	Assert.notUndefined(handler, `Expected ${button.Name} to have an Activated handler`);
	handler!(button, {}, 1);
	task.wait();
}

export function fireHostEvent(mounted: MountedElement, instance: Instance, eventName: string, ...args: unknown[]) {
	const eventKey = (React as unknown as { Event: Record<string, unknown> }).Event[eventName];
	const handler = findHostFiber(mounted, instance).memoizedProps?.get(eventKey) as
		((rbx: Instance, ...rest: unknown[]) => void) | undefined;

	Assert.notUndefined(handler, `Expected ${instance.Name} to have a ${eventName} handler`);
	handler!(instance, ...args);
	task.wait();
}
