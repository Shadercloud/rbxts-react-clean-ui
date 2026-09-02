// Extracts the vendored @shadercloud/loom-runtime tarball into vendor/loom-runtime
// so package.json's "@loom-dev/runtime" and "@loom-dev/renderer" overrides can
// both point `file:` at that one extracted directory. npm symlinks directory
// `file:` deps, so both package names end up resolving to the exact same real
// path on disk — one loaded module, one shared instance registry — instead of
// two independent copies of the runtime with two separate WeakMaps (the cause
// of "getEventSignal: value is not a LoomInstance").
//
// Must run BEFORE `npm ci`/`npm install`, not as a "preinstall" lifecycle
// script: npm reads the override targets' package.json while building its
// dependency tree, ahead of running any of the root package's own lifecycle
// scripts — a preinstall hook here was observed to run too late, leaving the
// vendored package's own dependencies (the @fontsource-* font packages)
// unresolved.
const { execFileSync } = require("node:child_process");
const fs = require("node:fs");
const path = require("node:path");

const vendorDir = path.join(__dirname, "..", "vendor");
const tarballName = "loom-runtime-0.11.0-shadercloud.2.tgz";
const targetName = "loom-runtime";

if (fs.existsSync(path.join(vendorDir, targetName, "package.json"))) process.exit(0);

fs.rmSync(path.join(vendorDir, targetName), { recursive: true, force: true });
fs.mkdirSync(path.join(vendorDir, targetName), { recursive: true });
// Relative paths only: an absolute `C:\...` path reads as a `host:path` remote
// spec to tar on Windows, so a "cwd: vendorDir" + bare filenames sidesteps that
// rather than fighting it with --force-local (which this tar build rejects).
execFileSync(
	"tar",
	["xf", tarballName, "--strip-components=1", "-C", targetName],
	{ cwd: vendorDir, stdio: "inherit" },
);
