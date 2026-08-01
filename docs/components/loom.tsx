
"use client";

import React from "react";

type ComponentTheme = "default" | "sandstone" | "dark";

interface LoomPreviewProps {
    target: string;
    height?: number;
    chrome?: "none" | "full";
    theme?: "light" | "dark";
    defaultComponentTheme?: ComponentTheme;
}

export function LoomPreview({
    target,
    height = 400,
    chrome = "none",
    theme = "light",
    defaultComponentTheme = "default",
}: LoomPreviewProps) {
    const basePath = process.env.NEXT_PUBLIC_BASE_PATH ?? "";

    const [componentTheme, setComponentTheme] =
        React.useState<ComponentTheme>(defaultComponentTheme);

    const [background, setBackground] = React.useState("#ffffff");
    React.useEffect(() => {
        const update = () => {
            const value = getComputedStyle(document.documentElement)
                .getPropertyValue("--color-fd-secondary")
                .trim();

            if (value) {
                setBackground(value);
            }
        };

        update();

        const observer = new MutationObserver(update);
        observer.observe(document.documentElement, {
            attributes: true,
            attributeFilter: ["class"],
        });

        return () => observer.disconnect();
    }, []);

    const params = new URLSearchParams({
        chrome,
        target,
        theme,
        ct: componentTheme,
        background,
    });

    return (
        <div
            style={{
                display: "flex",
                flexDirection: "column",
                width: "100%",
                height,
                overflow: "hidden",
                border: "1px solid var(--color-fd-border)",
                borderRadius: "8px",
                background: "var(--color-fd-secondary)",
            }}
        >
            <div
                style={{
                    display: "flex",
                    alignItems: "center",
                    gap: "8px",
                    padding: "10px",
                    borderTop: "1px solid var(--color-fd-border)",
                    background: "var(--color-fd-card)",
                }}
            >
                <label
                    htmlFor={`loom-theme-${target}`}
                    style={{
                        fontSize: "14px",
                        fontWeight: 500,
                        color: "var(--color-fd-muted-foreground)",
                    }}
                >
                    Theme
                </label>

                <select
                    id={`loom-theme-${target}`}
                    value={componentTheme}
                    onChange={(event) => {
                        setComponentTheme(
                            event.target.value as ComponentTheme,
                        );
                    }}
                    style={{
                        height: "32px",
                        minWidth: "170px",
                        padding: "0 32px 0 10px",
                        border: "1px solid var(--color-fd-border)",
                        borderRadius: "6px",
                        background: "var(--color-fd-background)",
                        color: "var(--color-fd-foreground)",
                        fontSize: "14px",
                        cursor: "pointer",
                        outline: "none",
                    }}
                >
                    <option value="default">Default Theme</option>
                    <option value="sandstone">Sandstone Theme</option>
                    <option value="dark">Dark Theme</option>
                </select>
            </div>
            <div style={{
                flex: 1,
                minHeight: 0,
                border: 0,
                padding: 8,
            }}>
                <iframe
                    src={`${basePath}/loom-preview?${params.toString()}`}
                    title={`Loom preview: ${target}`}
                    loading="lazy"
                    style={{
                        display: "block",
                        width: "100%",
                        height: "100%",
                        border: 0,
                    }}
                />
            </div>


        </div>
    );
}
