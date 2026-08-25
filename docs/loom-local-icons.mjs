/**
 * Dev-only gallery server that answers Loom's icon requests from the
 * pre-downloaded PNGs in `public/loom-icons/` (see `scripts/download-icons.js`)
 * before falling back to loom-dev's own live Roblox lookup.
 *
 * `withLoomGallery`'s dev path (`loom-dev/next`) always resolves
 * `rbxassetid://<id>` through a route that hits `thumbnails.roblox.com` live —
 * there is no hook to override that. So instead of using `withLoomGallery`'s
 * automatic dev-server bootstrap, `next.config.mjs` calls
 * `startLocalIconGalleryServer` below for the dev phase only: it boots the same
 * `createGalleryServer` loom-dev itself uses, then splices one extra
 * middleware in front of loom's own asset-proxy plugin. That middleware serves
 * a local PNG when one exists and calls `next()` (falling through to loom's
 * live resolution) otherwise, so an icon added since the last
 * `npm run download-icons` still shows up immediately.
 *
 * Everything else — target discovery, HMR, the gallery shell, the HTTP
 * wrapper Next's rewrites proxy to — is loom-dev's own code, unmodified.
 */
import { createServer as createHttpServer } from "node:http";
import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";
import { createGalleryServer } from "loom-dev/embed";

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const ICONS_DIR = path.join(__dirname, "public", "loom-icons");

/** `<base>__loom/asset/<id>` → local PNG when cached, else `next()`. */
function localIconMiddleware(base) {
	const assetRoute = `${base}__loom/asset/`;
	return function loomLocalIcons(req, res, next) {
		const pathname = (req.url ?? "/").split("?")[0] ?? "/";
		if (!pathname.startsWith(assetRoute)) {
			next();
			return;
		}
		const id = pathname.slice(assetRoute.length);
		if (!/^\d+$/.test(id)) {
			next();
			return;
		}
		fs.readFile(path.join(ICONS_DIR, `${id}.png`), (err, data) => {
			if (err) {
				// Not cached locally — let loom's own live-resolving proxy handle it.
				next();
				return;
			}
			res.statusCode = 200;
			res.setHeader("Content-Type", "image/png");
			res.setHeader("Cache-Control", "public, max-age=86400");
			res.end(data);
		});
	};
}

/**
 * Same shape/contract as `loom-dev/next`'s own `startGalleryServer` (an HTTP
 * wrapper around a middleware-mode gallery Vite server, for Next's rewrites to
 * proxy to) — reimplemented here only so `localIconMiddleware` can be spliced
 * to the front of the middleware stack.
 *
 * `.use()` appends; ours must run first, since loom's own asset-proxy
 * middleware always answers a matching request itself (redirect or 502) and
 * never calls `next()`. `vite.middlewares` is Vite's Connect instance —
 * `.stack` is Connect's own internal array, not a documented Vite API, but a
 * long-stable part of its shape. Moving the entry just pushed to the front is
 * defensive either way: it works regardless of how many middlewares loom
 * registered ahead of it.
 */
export async function startLocalIconGalleryServer(options) {
	const gallery = await createGalleryServer(options);

	gallery.vite.middlewares.use(localIconMiddleware(gallery.base));
	const stack = gallery.vite.middlewares.stack;
	stack.unshift(stack.pop());

	const server = createHttpServer((req, res) => {
		gallery.middleware(req, res, (err) => {
			res.statusCode = err ? 500 : 404;
			res.end(err ? "loom gallery: internal error" : "not found");
		});
	});
	await new Promise((listening, reject) => {
		server.once("error", reject);
		server.listen(options.port ?? 0, "127.0.0.1", listening);
	});
	const address = server.address();
	const port =
		typeof address === "object" && address !== null ? address.port : 0;
	return {
		port,
		origin: `http://127.0.0.1:${port}`,
		base: gallery.base,
		async close() {
			await new Promise((closed) => {
				server.close(() => closed());
			});
			await gallery.close();
		},
	};
}
