import defaultMdxComponents from 'fumadocs-ui/mdx';
import type { MDXComponents } from 'mdx/types';
import "react-medium-image-zoom/dist/styles.css";
import { LoomPreview } from './loom';
import * as TabsComponents from 'fumadocs-ui/components/tabs';
import { Eye, ImageIcon, Code } from "lucide-react";
import { Image } from './image';
import { Demo } from './demo';

export function getMDXComponents(components?: MDXComponents) {
  return {
    ...defaultMdxComponents,
    ...TabsComponents,
    Eye,
    ImageIcon,
    Code,
    LoomPreview,
    Image,
    Demo,
    ...components,
  } satisfies MDXComponents;
}

export const useMDXComponents = getMDXComponents;

declare global {
  type MDXProvidedComponents = ReturnType<typeof getMDXComponents>;
}
