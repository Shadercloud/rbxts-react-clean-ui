import { Eye, ImageIcon, Code } from "lucide-react";
import { LoomPreview } from "./loom";
import { Tabs, TabsList, TabsTrigger, TabsContent } from "./tabs";
import { Image } from "./image";

interface DemoProps {
    preview: string;
    previewHeight?: number;
    screenshot?: string;
    screenshotAlt?: string;
    children: React.ReactNode;
}

export function Demo({
    preview,
    previewHeight = 400,
    screenshot,
    screenshotAlt = "Component screenshot",
    children,
}: DemoProps) {
    return (
        <Tabs defaultValue="preview">
            <TabsList>
                <TabsTrigger value="preview">
                    <Eye className="h-4 w-4" />
                    Loom Preview
                </TabsTrigger>

                {screenshot && (
                    <TabsTrigger value="screenshot">
                        <ImageIcon className="h-4 w-4" />
                        Screenshot
                    </TabsTrigger>
                )}

                <TabsTrigger value="code">
                    <Code className="h-4 w-4" />
                    Code
                </TabsTrigger>
            </TabsList>

            <TabsContent value="preview">
                <LoomPreview
                    target={preview}
                    height={previewHeight}
                />
            </TabsContent>

            {screenshot && (
                <TabsContent value="screenshot" className="flex justify-center">
                    <Image alt={screenshotAlt} src={screenshot} />
                </TabsContent>
            )}

            <TabsContent value="code">
                {children}
            </TabsContent>
        </Tabs>
    );
}