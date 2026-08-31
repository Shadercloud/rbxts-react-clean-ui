"use strict";

const fs = require("node:fs");
const path = require("node:path");

const { getRequiredIconIds } = require("./lib/icon-ids");

const OUTPUT_DIR = path.join(__dirname, "..", "public", "loom-icons");
const MANIFEST_PATH = path.join(OUTPUT_DIR, "manifest.json");

const THUMBNAIL_BATCH_SIZE = 100;
const THUMBNAIL_SIZE = "420x420";
const DOWNLOAD_CONCURRENCY = 8;
const MAX_ATTEMPTS = 3;
const ASSET_DELIVERY_URL = "https://assetdelivery.roblox.com/v1/asset/?id=";

function parseCliArgs(argv) {
	let force = false;
	for (const arg of argv) {
		if (arg === "--force") {
			force = true;
		}
	}
	return { force };
}

function chunk(items, size) {
	const chunks = [];
	for (let i = 0; i < items.length; i += size) {
		chunks.push(items.slice(i, i + size));
	}
	return chunks;
}

async function sleep(ms) {
	return new Promise((resolve) => setTimeout(resolve, ms));
}

async function withRetries(task, attempts) {
	let lastError;
	for (let attempt = 1; attempt <= attempts; attempt++) {
		try {
			return await task();
		} catch (error) {
			lastError = error;
			if (attempt < attempts) {
				await sleep(250 * attempt);
			}
		}
	}
	throw lastError;
}

async function resolveImageUrls(ids) {
	const resolved = new Map();
	const failures = [];

	for (const batch of chunk(ids, THUMBNAIL_BATCH_SIZE)) {
		const url = `https://thumbnails.roblox.com/v1/assets?assetIds=${batch.join(",")}&size=${THUMBNAIL_SIZE}&format=Png&isCircular=false`;

		try {
			const payload = await withRetries(async () => {
				const response = await fetch(url);
				if (!response.ok) {
					throw new Error(`HTTP ${response.status} ${response.statusText}`);
				}
				return response.json();
			}, MAX_ATTEMPTS);

			const seen = new Set();
			for (const entry of payload.data ?? []) {
				const id = String(entry.targetId);
				seen.add(id);
				if (entry.state === "Completed" && entry.imageUrl) {
					resolved.set(id, entry.imageUrl);
				} else {
					failures.push({ id, reason: `thumbnail state '${entry.state}'` });
				}
			}

			for (const id of batch) {
				if (!seen.has(id)) {
					failures.push({ id, reason: "missing from thumbnails API response" });
				}
			}
		} catch (error) {
			for (const id of batch) {
				failures.push({ id, reason: `thumbnail request failed: ${error.message}` });
			}
		}
	}

	return { resolved, failures };
}

async function downloadImage(id, imageUrl, outputPath) {
	await withRetries(async () => {
		const response = await fetch(imageUrl);
		if (!response.ok) {
			throw new Error(`HTTP ${response.status} ${response.statusText}`);
		}
		const buffer = Buffer.from(await response.arrayBuffer());
		fs.writeFileSync(outputPath, buffer);
	}, MAX_ATTEMPTS);
}

// When `ROBLOSECURITY` is set, the true original file (not a downscaled
// thumbnail) can be fetched directly for any asset id the authenticated
// account has access to (e.g. one it uploaded). A successful response is raw
// binary; an inaccessible/missing asset comes back as a JSON error body
// (401/403/404) — that's treated as "fall back to the thumbnail API for this
// id", not a hard failure, so one inaccessible asset doesn't break the run.
// Returns `null` on any non-image response; never throws for that case
// (network errors still throw, and are handled by the caller).
async function fetchFullResolutionAsset(id, cookie) {
	const response = await fetch(`${ASSET_DELIVERY_URL}${id}`, {
		headers: { Cookie: `.ROBLOSECURITY=${cookie}` },
	});
	const contentType = response.headers.get("content-type") ?? "";
	if (!response.ok || !contentType.startsWith("image/")) {
		return null;
	}
	return Buffer.from(await response.arrayBuffer());
}

async function runWithConcurrency(items, concurrency, worker) {
	let cursor = 0;

	async function next() {
		while (cursor < items.length) {
			const index = cursor;
			cursor += 1;
			await worker(items[index], index);
		}
	}

	const workers = [];
	for (let i = 0; i < Math.min(concurrency, items.length); i++) {
		workers.push(next());
	}
	await Promise.all(workers);
}

async function main() {
	const { force } = parseCliArgs(process.argv.slice(2));
	const cookie = process.env.ROBLOSECURITY;

	fs.mkdirSync(OUTPUT_DIR, { recursive: true });

	const requiredIds = [...getRequiredIconIds()].sort();

	const failures = [];
	let skipped = 0;
	let downloaded = 0;
	let downloadedFullRes = 0;

	const idsToDownload = [];
	for (const id of requiredIds) {
		const outputPath = path.join(OUTPUT_DIR, `${id}.png`);
		if (!force && fs.existsSync(outputPath)) {
			skipped += 1;
			continue;
		}
		idsToDownload.push(id);
	}

	// With an authenticated session, prefer the true original file over a
	// downscaled thumbnail for every id the account can access. Anything left
	// unresolved here (no cookie, or the account lacks access to that id)
	// falls through to the existing thumbnail-API path below unchanged.
	let remainingIds = idsToDownload;
	if (cookie && idsToDownload.length > 0) {
		console.log(`Attempting full-resolution download for ${idsToDownload.length} icon(s) (authenticated)...`);
		remainingIds = [];

		await runWithConcurrency(idsToDownload, DOWNLOAD_CONCURRENCY, async (id) => {
			const outputPath = path.join(OUTPUT_DIR, `${id}.png`);
			try {
				const buffer = await fetchFullResolutionAsset(id, cookie);
				if (buffer) {
					fs.writeFileSync(outputPath, buffer);
					downloaded += 1;
					downloadedFullRes += 1;
					return;
				}
			} catch {
				// Network/transport error — fall back to the thumbnail path below.
			}
			remainingIds.push(id);
		});

		if (remainingIds.length > 0) {
			console.log(`Falling back to thumbnails for ${remainingIds.length} icon(s) not available full-resolution...`);
		}
	}

	if (remainingIds.length > 0) {
		console.log(`Resolving thumbnail URLs for ${remainingIds.length} icon(s)...`);
		const { resolved, failures: resolveFailures } = await resolveImageUrls(remainingIds);
		failures.push(...resolveFailures);

		const downloadable = remainingIds.filter((id) => resolved.has(id));
		console.log(`Downloading ${downloadable.length} icon(s) with concurrency ${DOWNLOAD_CONCURRENCY}...`);

		await runWithConcurrency(downloadable, DOWNLOAD_CONCURRENCY, async (id) => {
			const imageUrl = resolved.get(id);
			const outputPath = path.join(OUTPUT_DIR, `${id}.png`);
			try {
				await downloadImage(id, imageUrl, outputPath);
				downloaded += 1;
			} catch (error) {
				failures.push({ id, reason: `download failed: ${error.message}` });
			}
		});
	}

	const manifest = {};
	let present = 0;
	for (const id of requiredIds) {
		const outputPath = path.join(OUTPUT_DIR, `${id}.png`);
		if (fs.existsSync(outputPath)) {
			manifest[id] = `${id}.png`;
			present += 1;
		}
	}
	fs.writeFileSync(MANIFEST_PATH, JSON.stringify(manifest, null, "\t") + "\n");

	console.log("");
	console.log(
		`Summary: ${requiredIds.length} required, ${skipped} skipped (already cached), ${downloaded} downloaded ` +
			`(${downloadedFullRes} full-res, ${downloaded - downloadedFullRes} thumbnail), ${failures.length} failed, ${present} present in manifest`,
	);

	if (failures.length > 0) {
		console.error("");
		console.error("Failed icon ids:");
		for (const failure of failures) {
			console.error(`  - ${failure.id}: ${failure.reason}`);
		}
		process.exitCode = 1;
	}
}

main().catch((error) => {
	console.error("Unexpected error while downloading icons:");
	console.error(error);
	process.exit(1);
});
