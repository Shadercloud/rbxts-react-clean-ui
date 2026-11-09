import React from "@rbxts/react";

type EventCallback = (...args: never[]) => void;

interface ReactEventMarkers {
    Event: Record<string, unknown>;
}

export class ElementHelper {
    public static isHostElement(element: React.ReactElement): boolean {
        return typeIs(element.type, "string");
    }

    public static assignRef<T>(ref: React.ForwardedRef<T>, instance: T | undefined): void {
        if (typeIs(ref, "function")) {
            ref(instance);
        } else if (ref) {
            ref.current = instance;
        }
    }

    public static getEventKey(name: string): unknown {
        return (React as unknown as ReactEventMarkers).Event[name];
    }

    public static cloneWithEvents<P>(
        element: React.ReactElement<P>,
        props: Record<string, unknown>,
        events: Record<string, EventCallback>,
    ): React.ReactElement<P> {
        const config = new Map<unknown, unknown>();

        for (const [key, value] of pairs(props)) {
            config.set(key, value);
        }

        const elementProps = element.props as unknown as Map<unknown, unknown>;

        if (this.isHostElement(element)) {
            for (const [name, handler] of pairs(events)) {
                const key = this.getEventKey(name);
                const original = elementProps.get(key) as Callback | undefined;

                config.set(key, (...args: unknown[]) => {
                    original?.(...args);
                    (handler as Callback)(...args);
                });
            }
        } else {
            const originalEvents = elementProps.get("Event") as Record<string, Callback> | undefined;
            const mergedEvents: Record<string, Callback> = originalEvents !== undefined ? { ...originalEvents } : {};

            for (const [name, handler] of pairs(events)) {
                const original = originalEvents?.[name];

                mergedEvents[name] = (...args: unknown[]) => {
                    original?.(...args);
                    (handler as Callback)(...args);
                };
            }

            config.set("Event", mergedEvents);
        }

        return React.cloneElement(element, config as unknown as Partial<P>);
    }
}
