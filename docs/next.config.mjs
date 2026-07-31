import { createMDX } from 'fumadocs-mdx/next';

const withMDX = createMDX();

const isProduction = process.env.NODE_ENV === 'production';

/** @type {import('next').NextConfig} */
const config = {
  reactStrictMode: true,

  output: 'export',

  basePath: isProduction ? '/rbxts-react-clean-ui' : '',

  images: {
    unoptimized: true,
  },
};

// export default withMDX(config);

import { withLoomGallery } from "loom-dev/next";
export default withLoomGallery(withMDX(config), {
  root: "..",       // the roblox-ts project, relative to the app dir
});