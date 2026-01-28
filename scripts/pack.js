#!/usr/bin/env node

const fs = require("fs");
const path = require("path");
const { execSync } = require("child_process");

const OUTPUT_DIR = path.join(__dirname, "dist");
const PROJECT_ROOT = path.join(__dirname, "..");
const MODS_DIR = path.join(PROJECT_ROOT, "mods-unpacked");

function getModFolders() {
  return fs.readdirSync(MODS_DIR).filter((name) => {
    const fullPath = path.join(MODS_DIR, name);
    return fs.statSync(fullPath).isDirectory() && !name.startsWith(".");
  });
}

function packMod(modFolder) {
  const manifestPath = path.join(MODS_DIR, modFolder, "manifest.json");
  const manifest = JSON.parse(fs.readFileSync(manifestPath, "utf8"));
  const zipName = `${manifest.namespace}-${manifest.name}.zip`;

  if (!fs.existsSync(OUTPUT_DIR)) {
    fs.mkdirSync(OUTPUT_DIR, { recursive: true });
  }

  const zipPath = path.join(OUTPUT_DIR, zipName);
  if (fs.existsSync(zipPath)) fs.unlinkSync(zipPath);

  // 从项目根目录打包，保持 mods-unpacked/ModName 结构，并排除 .DS_Store
  execSync(`zip -r "${zipPath}" "mods-unpacked/${modFolder}" -x "*.DS_Store"`, {
    cwd: PROJECT_ROOT,
  });

  console.log(`✓ ${modFolder}`);
}

const mods = process.argv.slice(2);
(mods.length ? mods : getModFolders()).forEach(packMod);
