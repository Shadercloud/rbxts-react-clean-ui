import { createMDX } from 'fumadocs-mdx/next';
import {
  withLoomGallery,
  resolveGalleryBases,
  resolveLoomNextOptions,
  loomDevRewrites,
  mergeRewrites,
  PHASE_DEVELOPMENT_SERVER,
} from "loom-dev/next";
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

const loomOptions = {
  root: "..",       // the roblox-ts project, relative to the app dir
  assets: false,    // production build: baked by scripts/inject-icons.js's postbuild step instead
};

const withMDXConfig = withMDX(config);

// Dev-mode gallery server, booted lazily and memoized across next.config.mjs's
// repeated evaluations (Next calls the function config more than once) —
// mirrors the memoization `withLoomGallery` itself does internally.
let localIconGalleryServer;
function ensureLocalIconGalleryServer(publicBase) {
  if (!localIconGalleryServer) {
    localIconGalleryServer = (async () => {
      const { startLocalIconGalleryServer } = await import("./loom-local-icons.mjs");
      const { root } = resolveLoomNextOptions(loomOptions);
      return startLocalIconGalleryServer({ root, targets: true, base: publicBase });
    })().catch((err) => {
      // Only memoize a successful boot, so a transient failure is retried on
      // the next rewrites() call instead of replayed forever.
      localIconGalleryServer = undefined;
      throw err;
    });
  }
  return localIconGalleryServer;
}

/**
 * `withLoomGallery`'s dev path always resolves `rbxassetid://` images through
 * a live Roblox lookup with no override hook (see `docs/loom-local-icons.mjs`
 * for the full explanation). So dev mode is wired up by hand here instead,
 * reusing the same public `loom-dev/next` pieces `withLoomGallery` itself
 * composes, just with a gallery server that checks `public/loom-icons/`
 * first. The production build is untouched — it still goes through
 * `withLoomGallery` exactly as before.
 */
export default async function nextConfig(phase, context) {
  if (phase !== PHASE_DEVELOPMENT_SERVER) {
    return withLoomGallery(withMDXConfig, loomOptions)(phase, context);
  }

  const resolved =
    typeof withMDXConfig === "function"
      ? await withMDXConfig(phase, context)
      : withMDXConfig;
  const bases = resolveGalleryBases(resolved.basePath, loomOptions.base);
  const userRewrites = resolved.rewrites;

  return {
    ...resolved,
    async rewrites() {
      const user = await userRewrites?.();
      try {
        const { origin } = await ensureLocalIconGalleryServer(bases.publicBase);
        return mergeRewrites(user, { beforeFiles: loomDevRewrites(bases, origin) });
      } catch (err) {
        console.error("loom: local-icon gallery dev server failed to start —", err);
        return mergeRewrites(user, {});
      }
    },
  };
}