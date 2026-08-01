import defaultMdxComponents from 'fumadocs-ui/mdx';
import type { MDXComponents } from 'mdx/types';
import Zoom from "react-medium-image-zoom";
import "react-medium-image-zoom/dist/styles.css";
import { LoomPreview } from './loom';
import * as TabsComponents from 'fumadocs-ui/components/tabs';
import { Eye, ImageIcon, Code } from "lucide-react";

const basePath =
  process.env.NODE_ENV === "production"
    ? "/rbxts-react-clean-ui"
    : "";

export function getMDXComponents(components?: MDXComponents) {
  return {
    ...defaultMdxComponents,
    ...TabsComponents,
    Eye,
    ImageIcon,
    Code,
    LoomPreview,
    Image: (props: React.ComponentProps<"img">) => {
      let src = props.src;

      if (
        typeof src === "string" &&
        src.startsWith("/") &&
        !src.startsWith(basePath + "/")
      ) {
        src = `${basePath}${src}`;
      }

      return (
        <Zoom>
          <img {...props} src={src} />
        </Zoom>
      );
    },
    ...components,
  } satisfies MDXComponents;
}

export const useMDXComponents = getMDXComponents;

declare global {
  type MDXProvidedComponents = ReturnType<typeof getMDXComponents>;
}
