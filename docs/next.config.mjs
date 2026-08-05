import { createMDX } from 'fumadocs-mdx/next';
import { withLoomGallery } from "loom-dev/next";
import fs from "node:fs";
import path from "node:path";
import { createRequire } from "node:module";

const require = createRequire(import.meta.url);

function getPackageVersion(packageName) {
  let directory = path.dirname(require.resolve(packageName));

  while (directory !== path.dirname(directory)) {
    const packageJsonPath = path.join(directory, "package.json");

    if (fs.existsSync(packageJsonPath)) {
      const packageJson = JSON.parse(
        fs.readFileSync(packageJsonPath, "utf8"),
      );

      if (packageJson.name === packageName) {
        return packageJson.version;
      }
    }

    directory = path.dirname(directory);
  }

  return undefined;
}

const loomVersion = getPackageVersion("@loom-dev/renderer");


const withMDX = createMDX();

const isProduction = process.env.NODE_ENV === 'production';

const basePath = isProduction ? '/rbxts-react-clean-ui' : '';

/** @type {import('next').NextConfig} */
const config = {
  reactStrictMode: true,

  output: 'export',
  env: {
    NEXT_PUBLIC_BASE_PATH: basePath,
    NEXT_PUBLIC_LOOM_VERSION: loomVersion,
  },

  basePath: basePath,

  images: {
    unoptimized: true,
  },
};

export default withLoomGallery(withMDX(config), {
  root: "..",       // the roblox-ts project, relative to the app dir
  assets: false,    // whether to include the assets folder in the gallery
});