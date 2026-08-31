"use strict";

const fs = require("node:fs");
const path = require("node:path");

const THEME_DIR = path.join(__dirname, "..", "..", "..", "src", "Theme");
const THEMES_DIR = path.join(THEME_DIR, "themes");
const DEFAULT_ICON_SET_PATH = path.join(THEME_DIR, "icons.default.ts");

const ICON_ID_PATTERN = /:\s*(\d{6,})\s*,/g;
const ICONS_BLOCK_PATTERN = /icons:\s*\{([\s\S]*?)\}/g;
const BACKGROUND_IMAGE_BLOCK_PATTERN = /backgroundImage:\s*\{([\s\S]*?)\}/g;
const BACKGROUND_IMAGE_ID_PATTERN = /image:\s*(\d{6,})/g;

function extractIds(text, pattern) {
	const ids = [];
	for (const match of text.matchAll(pattern)) {
		ids.push(match[1]);
	}
	return ids;
}

function extractIdsFromIconSetFile(filePath) {
	const text = fs.readFileSync(filePath, "utf8");
	return extractIds(text, ICON_ID_PATTERN);
}

// Every `*.theme.ts` file under src/Theme/themes/ is scanned automatically so
// a new theme file doesn't require remembering to register it here.
function getThemeFilePaths() {
	return fs
		.readdirSync(THEMES_DIR)
		.filter((fileName) => fileName.endsWith(".theme.ts"))
		.sort()
		.map((fileName) => path.join(THEMES_DIR, fileName));
}

// A theme's `icons: { ... }` block (if any) maps semantic icon names to
// numeric asset ids, e.g. `icons: { close: 123456, ... }`.
function extractIconBlockIds(filePath, text) {
	const matches = [...text.matchAll(ICONS_BLOCK_PATTERN)];

	if (matches.length > 1) {
		throw new Error(
			`Expected at most one 'icons: { ... }' block in '${filePath}', found ${matches.length}. ` +
				"Update the extraction logic in docs/scripts/lib/icon-ids.js to match the new shape.",
		);
	}

	if (matches.length === 0) {
		return [];
	}

	return extractIds(matches[0][1], ICON_ID_PATTERN);
}

// Some themes (e.g. wooden.theme.ts) reference image assets directly via
// `backgroundImage: { image: 123456, ... }` instead of (or in addition to)
// an `icons: { ... }` block.
function extractBackgroundImageIds(text) {
	const ids = [];
	for (const blockMatch of text.matchAll(BACKGROUND_IMAGE_BLOCK_PATTERN)) {
		ids.push(...extractIds(blockMatch[1], BACKGROUND_IMAGE_ID_PATTERN));
	}
	return ids;
}

function extractIdsFromThemeFile(filePath) {
	const text = fs.readFileSync(filePath, "utf8");
	return [...extractIconBlockIds(filePath, text), ...extractBackgroundImageIds(text)];
}

function getRequiredIconIds() {
	const ids = new Set();

	for (const id of extractIdsFromIconSetFile(DEFAULT_ICON_SET_PATH)) {
		ids.add(id);
	}

	for (const themeFilePath of getThemeFilePaths()) {
		for (const id of extractIdsFromThemeFile(themeFilePath)) {
			ids.add(id);
		}
	}

	return ids;
}

module.exports = {
	getRequiredIconIds,
	DEFAULT_ICON_SET_PATH,
	getThemeFilePaths,
};
