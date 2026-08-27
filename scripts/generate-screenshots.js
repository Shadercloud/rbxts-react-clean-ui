"use strict";

const fs = require("node:fs");
const path = require("node:path");
const { spawnSync } = require("node:child_process");

const REPO_ROOT = path.join(__dirname, "..");
const DOCS_CONTENT_DIR = path.join(REPO_ROOT, "docs", "content");
const SCREENSHOTS_DIR = path.join(REPO_ROOT, "docs", "public", "images", "screenshots");
const SCREENSHOT_ATTR_PATTERN = /screenshot="([^"]+\.tsx)"/g;

function walkMdxFiles(dir) {
	const results = [];
	for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
		const fullPath = path.join(dir, entry.name);
		if (entry.isDirectory()) {
			results.push(...walkMdxFiles(fullPath));
		} else if (entry.isFile() && entry.name.endsWith(".mdx")) {
			results.push(fullPath);
		}
	}
	return results;
}

function quoteArg(arg) {
	return `"${String(arg).replace(/"/g, '\\"')}"`;
}

function resolveBinPath() {
	const binName = process.platform === "win32" ? "react-screenshot-plugin.cmd" : "react-screenshot-plugin";
	return path.join(REPO_ROOT, "node_modules", ".bin", binName);
}

function parseCliArgs(argv) {
	let force = false;
	const filters = [];
	for (const arg of argv) {
		if (arg === "--force") {
			force = true;
		} else {
			filters.push(arg);
		}
	}
	return { force, filters };
}

function isFresh(sourcePath, outputPath) {
	if (!fs.existsSync(outputPath)) return false;
	const sourceMtime = fs.statSync(sourcePath).mtimeMs;
	const outputMtime = fs.statSync(outputPath).mtimeMs;
	return outputMtime > sourceMtime;
}

function main() {
	const { force, filters } = parseCliArgs(process.argv.slice(2));
	const binPath = resolveBinPath();

	const mdxFiles = walkMdxFiles(DOCS_CONTENT_DIR);

	let captured = 0;
	let skipped = 0;
	let failed = 0;
	const updatedFiles = [];
	const failures = [];

	for (const mdxFile of mdxFiles) {
		const original = fs.readFileSync(mdxFile, "utf8");
		const matches = [...original.matchAll(SCREENSHOT_ATTR_PATTERN)];
		if (matches.length === 0) continue;

		let content = original;

		for (const match of matches) {
			const tsxRelativePath = match[1];

			if (filters.length > 0 && !filters.some((filter) => tsxRelativePath.includes(filter))) {
				continue;
			}

			const sourcePath = path.resolve(REPO_ROOT, tsxRelativePath);
			const parentDir = path.basename(path.dirname(sourcePath));
			const baseName = path.basename(sourcePath, ".tsx");
			const outputPath = path.join(SCREENSHOTS_DIR, parentDir, `${baseName}.png`);
			const docsRelativeOutputPath = `/images/screenshots/${parentDir}/${baseName}.png`;

			if (!fs.existsSync(sourcePath)) {
				console.error(`Failed: source fixture not found for '${tsxRelativePath}' (referenced in ${mdxFile})`);
				failed += 1;
				failures.push(tsxRelativePath);
				continue;
			}

			if (!force && isFresh(sourcePath, outputPath)) {
				console.log(`Skipped (up to date): ${tsxRelativePath}`);
				skipped += 1;
			} else {
				console.log(`Capturing: ${tsxRelativePath} -> ${path.relative(REPO_ROOT, outputPath)}`);
				const captureArgs = [
					tsxRelativePath,
					"--output",
					path.relative(REPO_ROOT, outputPath),
					"--props",
					JSON.stringify({ screenshot: true }),
				];
				const result = spawnSync(quoteArg(binPath) + " " + captureArgs.map(quoteArg).join(" "), {
					cwd: REPO_ROOT,
					stdio: "inherit",
					shell: true,
				});

				if (result.status !== 0 || result.error) {
					console.error(`Failed: capture of '${tsxRelativePath}' did not succeed`);
					failed += 1;
					failures.push(tsxRelativePath);
					continue;
				}

				captured += 1;
			}

			content = content.split(`screenshot="${tsxRelativePath}"`).join(`screenshot="${docsRelativeOutputPath}"`);
		}

		if (content !== original) {
			fs.writeFileSync(mdxFile, content);
			updatedFiles.push(path.relative(REPO_ROOT, mdxFile));
		}
	}

	console.log("");
	console.log(`Summary: ${captured} captured, ${skipped} skipped, ${failed} failed`);
	if (updatedFiles.length > 0) {
		console.log("Updated .mdx files:");
		for (const file of updatedFiles) {
			console.log(`  - ${file}`);
		}
	}

	if (failed > 0) {
		console.error("");
		console.error(`Failed fixtures: ${failures.join(", ")}`);
		process.exit(1);
	}
}

main();
