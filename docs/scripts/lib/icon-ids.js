"use strict";

const fs = require("node:fs");
const path = require("node:path");

const THEME_DIR = path.join(__dirname, "..", "..", "..", "src", "Theme");
const DEFAULT_ICON_SET_PATH = path.join(THEME_DIR, "icons.default.ts");
const THEME_FILE_PATHS = [
	path.join(THEME_DIR, "themes", "default.theme.ts"),
	path.join(THEME_DIR, "themes", "dark.theme.ts"),
	path.join(THEME_DIR, "themes", "sandstone.theme.ts"),
];

const ICON_ID_PATTERN = /:\s*(\d{6,})\s*,/g;
const ICONS_BLOCK_PATTERN = /icons:\s*\{([\s\S]*?)\}/g;

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

function extractIdsFromThemeFile(filePath) {
	const text = fs.readFileSync(filePath, "utf8");
	const matches = [...text.matchAll(ICONS_BLOCK_PATTERN)];

	if (matches.length !== 1) {
		throw new Error(
			`Expected exactly one 'icons: { ... }' block in '${filePath}', found ${matches.length}. ` +
				"Update the extraction logic in docs/scripts/lib/icon-ids.js to match the new shape.",
		);
	}

	return extractIds(matches[0][1], ICON_ID_PATTERN);
}

function getRequiredIconIds() {
	const ids = new Set();

	for (const id of extractIdsFromIconSetFile(DEFAULT_ICON_SET_PATH)) {
		ids.add(id);
	}

	for (const themeFilePath of THEME_FILE_PATHS) {
		for (const id of extractIdsFromThemeFile(themeFilePath)) {
			ids.add(id);
		}
	}

	return ids;
}

module.exports = {
	getRequiredIconIds,
	DEFAULT_ICON_SET_PATH,
	THEME_FILE_PATHS,
};
