"use strict";

const fs = require("node:fs");
const path = require("node:path");

const { getRequiredIconIds } = require("./lib/icon-ids");

const ICONS_DIR = path.join(__dirname, "..", "public", "loom-icons");
const MANIFEST_SOURCE_PATH = path.join(ICONS_DIR, "manifest.json");
const LOOM_PREVIEW_OUT_DIR = path.join(__dirname, "..", "out", "loom-preview");
const LOOM_ASSET_OUT_DIR = path.join(LOOM_PREVIEW_OUT_DIR, "__loom", "asset");
const MANIFEST_OUT_PATH = path.join(LOOM_PREVIEW_OUT_DIR, "__loom", "assets.json");

function main() {
	if (!fs.existsSync(LOOM_PREVIEW_OUT_DIR)) {
		console.warn(
			`inject-icons: '${path.relative(process.cwd(), LOOM_PREVIEW_OUT_DIR)}' does not exist, nothing to inject into. Skipping.`,
		);
		return;
	}

	if (!fs.existsSync(MANIFEST_SOURCE_PATH)) {
		console.warn(
			`inject-icons: no icon manifest found at '${path.relative(process.cwd(), MANIFEST_SOURCE_PATH)}'. ` +
				"Run 'npm run download-icons' to fetch icon thumbnails for the Loom preview. Skipping icon injection.",
		);
		return;
	}

	const manifest = JSON.parse(fs.readFileSync(MANIFEST_SOURCE_PATH, "utf8"));

	fs.mkdirSync(LOOM_ASSET_OUT_DIR, { recursive: true });

	const outputManifest = {};
	let copied = 0;

	for (const [id, filename] of Object.entries(manifest)) {
		const sourcePath = path.join(ICONS_DIR, filename);
		if (!fs.existsSync(sourcePath)) {
			console.warn(`inject-icons: manifest entry '${id}' -> '${filename}' has no file on disk, skipping.`);
			continue;
		}

		const destPath = path.join(LOOM_ASSET_OUT_DIR, filename);
		fs.copyFileSync(sourcePath, destPath);
		outputManifest[id] = `__loom/asset/${filename}`;
		copied += 1;
	}

	fs.writeFileSync(MANIFEST_OUT_PATH, JSON.stringify(outputManifest));
	console.log(`inject-icons: injected ${copied} icon(s) into the Loom preview build output.`);

	const requiredIds = getRequiredIconIds();
	const missingIds = [...requiredIds].filter((id) => !(id in manifest));
	if (missingIds.length > 0) {
		console.warn(
			`inject-icons: ${missingIds.length} icon id(s) are used but not present in the downloaded manifest. ` +
				"They won't show in the Loom preview until 'npm run download-icons' is re-run. Missing ids: " +
				missingIds.join(", "),
		);
	}
}

main();
