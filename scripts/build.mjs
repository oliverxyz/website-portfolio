#!/usr/bin/env node
// Builds site/ into dist/ and fills in the values that must stay out of git.
//
//   PHONE            phone as displayed, for example "+00 000 000 000"
//   CV_PDF           path to the CV PDF, defaults to the ignored local copy
//   GOATCOUNTER_CODE GoatCounter site code, analytics stay off without it
//
// With --release a missing phone or PDF fails the build, so CI can never
// publish the placeholder.
import { cpSync, existsSync, readFileSync, rmSync, writeFileSync } from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";

const root = join(dirname(fileURLToPath(import.meta.url)), "..");
const dist = join(root, "dist");
const release = process.argv.includes("--release");

const fail = (message) => {
  console.error(`build: ${message}`);
  process.exit(1);
};

const phone = process.env.PHONE?.trim() || "";
const cvPdf = process.env.CV_PDF || join(root, "Maksim_Kirillov_CV_terminal.pdf");
const goatcounter = process.env.GOATCOUNTER_CODE?.trim() || "";

if (phone && !/^\+[0-9 ]{7,20}$/.test(phone)) fail("PHONE must look like +00 000 000 000");
if (goatcounter && !/^[a-z0-9-]+$/.test(goatcounter)) fail("GOATCOUNTER_CODE has unexpected characters");
if (release && !phone) fail("PHONE is required with --release");
if (release && !existsSync(cvPdf)) fail(`CV PDF not found: ${cvPdf}`);

rmSync(dist, { recursive: true, force: true });
cpSync(join(root, "site"), dist, { recursive: true });

const digits = phone.replace(/\D/g, "");
const analytics = goatcounter
  ? `<script data-goatcounter="https://${goatcounter}.goatcounter.com/count" async src="https://gc.zgo.at/count.js"></script>`
  : "";

const indexPath = join(dist, "index.html");
const html = readFileSync(indexPath, "utf8")
  .replaceAll("__PHONE_DISPLAY__", phone || "PHONE NOT SET (local build)")
  .replaceAll("__PHONE_TEL__", digits ? `+${digits}` : "+0")
  .replaceAll("__PHONE_WHATSAPP__", digits || "0")
  .replace("<!-- __ANALYTICS__ -->", analytics);
if (html.includes("__PHONE_")) fail("a phone placeholder was left in index.html");
writeFileSync(indexPath, html);

if (existsSync(cvPdf)) {
  cpSync(cvPdf, join(dist, "Maksim_Kirillov_CV.pdf"));
} else {
  console.warn("build: no CV PDF, the download link will not work in this build");
}

console.log(`build: dist/ ready (${release ? "release" : "local"}, phone ${phone ? "set" : "placeholder"}, analytics ${goatcounter ? "on" : "off"})`);
