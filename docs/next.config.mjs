import { createMDX } from 'fumadocs-mdx/next';
import { withLoomGallery } from "loom-dev/next";

const withMDX = createMDX();

const isProduction = process.env.NODE_ENV === 'production';

const basePath = isProduction ? '/rbxts-react-clean-ui' : '';

/** @type {import('next').NextConfig} */
const config = {
  reactStrictMode: true,

  output: 'export',
  env: {
    NEXT_PUBLIC_BASE_PATH: basePath,
  },

  basePath: basePath,

  images: {
    unoptimized: true,
  },
};

export default withLoomGallery(withMDX(config), {
  root: "..",       // the roblox-ts project, relative to the app dir
});