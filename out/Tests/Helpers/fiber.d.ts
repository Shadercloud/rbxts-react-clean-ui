import { MountedElement } from "./layout";
interface HostFiber {
    child?: HostFiber;
    sibling?: HostFiber;
    stateNode?: unknown;
    memoizedProps?: Map<unknown, unknown>;
}
export declare function findHostFiber(mounted: MountedElement, instance: Instance): HostFiber;
export declare function activateButton(mounted: MountedElement, button: GuiButton): void;
export declare function fireHostEvent(mounted: MountedElement, instance: Instance, eventName: string, ...args: unknown[]): void;
export {};
