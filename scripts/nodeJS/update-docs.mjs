// Fetch each school's thesis format regulation into docs/.
//
//   node update-docs.mjs              # all schools
//   node update-docs.mjs ntu nccu     # only these
//   node update-docs.mjs --dry-run
//
// Needs LibreOffice (`soffice`) on PATH for .doc/.odt sources.
// Run it on a schedule, e.g. cron: 0 6 * * 1 cd scripts/nodeJS && node update-docs.mjs

import { createHash } from "node:crypto";
import { execFileSync } from "node:child_process";
import { mkdtempSync, readFileSync, readdirSync, rmSync, unlinkSync, writeFileSync, existsSync } from "node:fs";
import { tmpdir } from "node:os";
import { dirname, join, resolve as resolvePath } from "node:path";
import { fileURLToPath } from "node:url";

import CFB from "cfb";
import * as cheerio from "cheerio";
import JSZip from "jszip";
import { PDFDocument } from "pdf-lib";
import { getDocument } from "pdfjs-dist/legacy/build/pdf.mjs";
import { Agent, fetch } from "undici";

const ROOT = resolvePath(dirname(fileURLToPath(import.meta.url)), "../..");
const SOURCES = join(ROOT, "scripts", "sources.json");
const UA = { "User-Agent": "Mozilla/5.0 (tw-thesis-typ docs updater)" };
const KEYWORDS = /通過|修正|修訂|訂定|核定|公布/;
const insecure = new Agent({ connect: { rejectUnauthorized: false } });

async function get(url) {
  let r;
  try {
    r = await fetch(url, { headers: UA });
  } catch (e) {
    // several campus sites serve incomplete certificate chains
    if (!/certificate|CERT|SELF_SIGNED|verify/i.test(String(e.cause?.code ?? e.cause ?? e))) throw e;
    r = await fetch(url, { headers: UA, dispatcher: insecure });
  }
  if (!r.ok) throw new Error(`${r.status} ${url}`);
  return r;
}

async function resolve(spec) {
  if (spec.url) return spec.url;
  const $ = cheerio.load(await (await get(spec.page)).text());
  const href = new RegExp(spec.href ?? ".");
  for (const a of $("a[href]").toArray()) {
    const h = $(a).attr("href");
    if (!href.test(h)) continue;
    const ok = spec.row
      ? new RegExp(spec.row).test($(a).closest("tr").text())
      : new RegExp(spec.match).test($(a).text() + ($(a).attr("title") ?? ""));
    if (ok) return new URL(h, spec.page).href;
  }
  throw new Error(`no link on ${spec.page}`);
}

async function kind(data) {
  if (data.subarray(0, 4).toString("latin1") === "%PDF") return "pdf";
  if (data.subarray(0, 8).equals(Buffer.from("d0cf11e0a1b11ae1", "hex"))) return "doc";
  if (data.subarray(0, 2).toString("latin1") === "PK") {
    const zip = await JSZip.loadAsync(data);
    return zip.file("content.xml") ? "odt" : "docx";
  }
  throw new Error("not a pdf/doc/odt/docx file");
}

function toPdf(data, ext, tmp) {
  if (ext === "pdf") return data;
  const src = join(tmp, `src.${ext}`);
  writeFileSync(src, data);
  execFileSync("soffice", ["--headless", "--convert-to", "pdf", "--outdir", tmp, src], { stdio: "ignore" });
  return readFileSync(join(tmp, "src.pdf"));
}

async function merge(pdfs) {
  if (pdfs.length === 1) return pdfs[0];
  const out = await PDFDocument.create();
  for (const p of pdfs) {
    const doc = await PDFDocument.load(p, { ignoreEncryption: true });
    for (const page of await out.copyPages(doc, doc.getPageIndices())) out.addPage(page);
  }
  return Buffer.from(await out.save());
}

const roc = (y, m, d) => `${String(y).padStart(3, "0")}${String(m).padStart(2, "0")}${String(d).padStart(2, "0")}`;
const cmp = (a, b) => a[0] - b[0] || a[1] - b[1] || a[2] - b[2];

async function dateFromText(pdf) {
  const doc = await getDocument({ data: new Uint8Array(pdf), verbosity: 0 }).promise;
  let text = "";
  for (let i = 1; i <= Math.min(3, doc.numPages); i++) {
    const content = await (await doc.getPage(i)).getTextContent();
    text += content.items.map((it) => it.str + (it.hasEOL ? "\n" : "")).join("") + "\n";
  }
  text = text.slice(0, 4000);
  const found = [];
  // e.g. 1050127 alone on a line, as a page header
  for (const m of text.matchAll(/^\s*(1\d{2})(0[1-9]|1[0-2])([0-3]\d)\s*$/gm)) found.push(m.slice(1, 4).map(Number));
  const dated = /(\d{2,3})\s*[.．/]\s*(\d{1,2})\s*[.．/]\s*(\d{1,2})|(\d{2,3})\s*年\s*(\d{1,2})\s*月\s*(?:(\d{1,2})\s*日)?/g;
  for (const m of text.matchAll(dated)) {
    if (!KEYWORDS.test(text.slice(m.index + m[0].length, m.index + m[0].length + 40))) continue;
    const [y, mo, d] = m[1] ? [m[1], m[2], m[3]] : [m[4], m[5], m[6] ?? 0];
    found.push([Number(y), Number(mo), Number(d)]);
  }
  const maxYear = new Date().getFullYear() - 1910;
  const valid = found.filter(([y, m]) => y >= 80 && y <= maxYear && m >= 1 && m <= 12);
  if (!valid.length) throw new Error("no dated revision line found");
  return roc(...valid.sort(cmp).at(-1));
}

function dateFromUrl(urls) {
  for (const u of urls) {
    const m = u.match(/(20\d{2})(\d{2})(\d{2})\d{6,}/);
    if (m) return roc(Number(m[1]) - 1911, Number(m[2]), Number(m[3]));
  }
  throw new Error("no yyyymmdd timestamp in url");
}

// FILETIME property 13 (last saved) from the OLE SummaryInformation stream
function docSaved(data) {
  const entry = CFB.find(CFB.read(data, { type: "buffer" }), "SummaryInformation");
  if (!entry) return null;
  const b = Buffer.from(entry.content);
  const sec = b.readUInt32LE(44);
  const count = b.readUInt32LE(sec + 4);
  for (let i = 0; i < count; i++) {
    const id = b.readUInt32LE(sec + 8 + i * 8);
    const off = sec + b.readUInt32LE(sec + 12 + i * 8);
    if (id === 13 && b.readUInt32LE(off) === 0x40) {
      const ticks = b.readUInt32LE(off + 8) * 2 ** 32 + b.readUInt32LE(off + 4);
      return new Date(ticks / 1e4 - 11644473600000);
    }
  }
  return null;
}

async function metaDate(data, ext) {
  if (ext === "pdf") {
    const doc = await PDFDocument.load(data, { ignoreEncryption: true, updateMetadata: false });
    return doc.getModificationDate() ?? doc.getCreationDate() ?? null;
  }
  if (ext === "doc") return docSaved(data);
  const zip = await JSZip.loadAsync(data);
  const [file, tag] = ext === "odt" ? ["meta.xml", "dc:date"] : ["docProps/core.xml", "dcterms:modified"];
  const m = (await zip.file(file)?.async("string"))?.match(new RegExp(`<${tag}[^>]*>([^<]+)</${tag}>`));
  if (!m) return null;
  return new Date(/Z|[+-]\d\d:?\d\d$/.test(m[1]) ? m[1] : m[1] + "Z");
}

async function dateFromMeta(files) {
  const dates = (await Promise.all(files.map(([data, ext]) => metaDate(data, ext)))).filter(Boolean);
  if (!dates.length) throw new Error("no modification date in file metadata");
  const latest = new Date(Math.max(...dates));
  const [y, m, d] = new Intl.DateTimeFormat("en-CA", { timeZone: "Asia/Taipei" }).format(latest).split("-").map(Number);
  return roc(y - 1911, m, d);
}

async function update(school, cfg, lock, dry) {
  const urls = await Promise.all(school.files.map(resolve));
  const raws = await Promise.all(urls.map(async (u) => Buffer.from(await (await get(u)).arrayBuffer())));
  const digest = createHash("sha256").update(Buffer.concat(raws)).digest("hex");
  const out = join(ROOT, cfg.output);
  const prefix = cfg.pattern.split("{roc}")[0].replace("{name}", school.name);
  const existing = readdirSync(out).filter((f) => f.startsWith(prefix) && f.endsWith(".pdf")).sort();
  const entry = lock[school.code] ?? {};
  if (entry.sha256 === digest && existing.length) return ["unchanged", existing.at(-1)];

  const files = await Promise.all(raws.map(async (data) => [data, await kind(data)]));
  const tmp = mkdtempSync(join(tmpdir(), "tw-thesis-"));
  let pdf;
  try {
    pdf = await merge(files.map(([data, ext]) => toPdf(data, ext, tmp)));
  } finally {
    rmSync(tmp, { recursive: true, force: true });
  }
  const stamp =
    school.date === "text" ? await dateFromText(pdf) : school.date === "url" ? dateFromUrl(urls) : await dateFromMeta(files);
  const name = cfg.pattern.replace("{name}", school.name).replace("{roc}", stamp);

  let status;
  if (existing.length === 1 && existing[0] === name && !lock[school.code]) {
    // first run over a hand-collected file: adopt it, keep its bytes
    status = "adopted";
  } else {
    status = existing.length ? "updated" : "added";
    if (!dry) {
      for (const f of existing) unlinkSync(join(out, f));
      writeFileSync(join(out, name), pdf);
    }
  }
  if (!dry) lock[school.code] = { file: name, sha256: digest, urls };
  return [status, name];
}

const BAR_WIDTH = 24;
const LABELS = {
  unchanged: "未變更 unchanged",
  added: "新增 added",
  updated: "已更新 updated",
  adopted: "沿用既有 adopted",
  error: "錯誤 error",
};
const GREEN = "\x1b[32m";
const YELLOW = "\x1b[33m";
const RED = "\x1b[31m";
const GRAY = "\x1b[90m";
const RESET = "\x1b[0m";

function drawBar(i, total, short) {
  const filled = Math.floor((i * BAR_WIDTH) / total);
  const bar = GREEN + "█".repeat(filled) + GRAY + "░".repeat(BAR_WIDTH - filled) + RESET;
  process.stderr.write(`\r${bar} ${i}/${total} ${short.padEnd(6)}`);
}

async function main() {
  const args = process.argv.slice(2);
  const dry = args.includes("--dry-run");
  const codes = args.filter((a) => !a.startsWith("--"));
  const cfg = JSON.parse(readFileSync(SOURCES, "utf8"));
  const lockPath = join(ROOT, cfg.lock);
  const lock = existsSync(lockPath) ? JSON.parse(readFileSync(lockPath, "utf8")) : {};

  const schools = cfg.schools.filter((s) => !codes.length || codes.includes(s.code));
  const live = process.stderr.isTTY; // a log file doesn't want \r control codes
  const results = [];
  let failed = 0;

  for (const [idx, school] of schools.entries()) {
    if (live) drawBar(idx + 1, schools.length, school.short ?? school.code);
    try {
      const [status, name] = await update(school, cfg, lock, dry);
      results.push([school.code, status, name]);
    } catch (e) {
      failed++;
      results.push([school.code, "error", e.message]);
    }
  }
  if (live) process.stderr.write("\r" + " ".repeat(BAR_WIDTH + 20) + "\r");

  for (const [code, status, name] of results) {
    if (status === "unchanged") continue;
    const stream = status === "error" ? process.stderr : process.stdout;
    const color = stream.isTTY ? (status === "error" ? RED : YELLOW) : "";
    const reset = color ? RESET : "";
    stream.write(`${code.padEnd(6)} ${color}${LABELS[status]}${reset}  ${name}\n`);
  }

  const unchanged = results.filter(([, status]) => status === "unchanged").length;
  const changed = schools.length - unchanged - failed;
  const color = process.stdout.isTTY;
  const changedS = color && changed ? `${GREEN}已變更 ${changed}${RESET}` : `已變更 ${changed}`;
  const failedS = color && failed ? `${RED}錯誤 ${failed}${RESET}` : `錯誤 ${failed}`;
  console.log(`共檢查 ${schools.length} 校，${changedS}，${failedS}`);

  if (!dry) {
    const sorted = Object.fromEntries(Object.entries(lock).sort(([a], [b]) => a.localeCompare(b)));
    writeFileSync(lockPath, JSON.stringify(sorted, null, 2) + "\n");
  }
  process.exitCode = failed ? 1 : 0;
}

await main();
