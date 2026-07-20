import defaultMdxComponents from 'fumadocs-ui/mdx';
import type { MDXComponents } from 'mdx/types';
import Zoom from "react-medium-image-zoom";
import "react-medium-image-zoom/dist/styles.css";

export function getMDXComponents(components?: MDXComponents) {
  return {
    ...defaultMdxComponents,
    Image: (props) => (
      <Zoom>
        <img {...props} />
      </Zoom>
    ),
    ...components,
  } satisfies MDXComponents;
}

export const useMDXComponents = getMDXComponents;

declare global {
  type MDXProvidedComponents = ReturnType<typeof getMDXComponents>;
}
