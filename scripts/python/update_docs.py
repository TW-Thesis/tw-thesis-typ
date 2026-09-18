"""Fetch each school's thesis format regulation into docs/.

    uv run update_docs.py              # all schools
    uv run update_docs.py ntu nccu     # only these
    uv run update_docs.py --dry-run

Needs LibreOffice (`soffice`) on PATH for .doc/.odt sources.
Run it on a schedule, e.g. cron: 0 6 * * 1 cd scripts/python && uv run update_docs.py
"""

import argparse
import hashlib
import io
import json
import re
import shutil
import subprocess
import sys
import tempfile
import warnings
import zipfile
from datetime import datetime, timezone, timedelta
from pathlib import Path
from urllib.parse import urljoin

import olefile
import requests
from bs4 import BeautifulSoup
from pypdf import PdfReader, PdfWriter

ROOT = Path(__file__).resolve().parents[2]
SOURCES = ROOT / "scripts" / "sources.json"
TAIPEI = timezone(timedelta(hours=8))
UA = {"User-Agent": "Mozilla/5.0 (tw-thesis-typ docs updater)"}
KEYWORDS = re.compile(r"通過|修正|修訂|訂定|核定|公布")


def get(url):
    try:
        r = requests.get(url, headers=UA, timeout=60)
    except requests.exceptions.SSLError:
        # several campus sites serve incomplete certificate chains
        warnings.filterwarnings("ignore")
        r = requests.get(url, headers=UA, timeout=60, verify=False)
    r.raise_for_status()
    return r


def resolve(spec):
    if "url" in spec:
        return spec["url"]
    soup = BeautifulSoup(get(spec["page"]).text, "html.parser")
    href = re.compile(spec.get("href", "."))
    for a in soup.find_all("a", href=True):
        if not href.search(a["href"]):
            continue
        if "row" in spec:
            tr = a.find_parent("tr")
            ok = tr is not None and re.search(spec["row"], tr.get_text(" "))
        else:
            ok = re.search(spec["match"], a.get_text(" ") + a.get("title", ""))
        if ok:
            return urljoin(spec["page"], a["href"])
    raise LookupError(f"no link on {spec['page']}")


def kind(data):
    if data[:4] == b"%PDF":
        return "pdf"
    if data[:8] == b"\xd0\xcf\x11\xe0\xa1\xb1\x1a\xe1":
        return "doc"
    if data[:2] == b"PK":
        names = zipfile.ZipFile(io.BytesIO(data)).namelist()
        return "odt" if "content.xml" in names else "docx"
    raise ValueError("not a pdf/doc/odt/docx file")


def to_pdf(data, ext, tmp):
    if ext == "pdf":
        return data
    src = tmp / f"src.{ext}"
    src.write_bytes(data)
    subprocess.run(
        ["soffice", "--headless", "--convert-to", "pdf", "--outdir", str(tmp), str(src)],
        check=True,
        capture_output=True,
    )
    return (tmp / "src.pdf").read_bytes()


def merge(pdfs):
    if len(pdfs) == 1:
        return pdfs[0]
    w = PdfWriter()
    for p in pdfs:
        w.append(PdfReader(io.BytesIO(p)))
    out = io.BytesIO()
    w.write(out)
    return out.getvalue()


def roc(y, m, d):
    return f"{y:03d}{m:02d}{d:02d}"


def date_from_text(pdf):
    text = "".join((p.extract_text() or "") for p in PdfReader(io.BytesIO(pdf)).pages[:3])
    text = text[:4000]
    found = []
    # e.g. 1050127 alone on a line, as a page header
    for m in re.finditer(r"(?m)^\s*(1\d{2})(0[1-9]|1[0-2])([0-3]\d)\s*$", text):
        found.append(tuple(map(int, m.groups())))
    dated = r"(\d{2,3})\s*[.．/]\s*(\d{1,2})\s*[.．/]\s*(\d{1,2})|(\d{2,3})\s*年\s*(\d{1,2})\s*月\s*(?:(\d{1,2})\s*日)?"
    for m in re.finditer(dated, text):
        if not KEYWORDS.search(text[m.end() : m.end() + 40]):
            continue
        g = m.groups()
        y, mo, d = (g[0], g[1], g[2]) if g[0] else (g[3], g[4], g[5] or 0)
        found.append((int(y), int(mo), int(d)))
    found = [f for f in found if 80 <= f[0] <= datetime.now().year - 1910 and 1 <= f[1] <= 12]
    if not found:
        raise LookupError("no dated revision line found")
    return roc(*max(found))


def date_from_url(urls):
    for u in urls:
        m = re.search(r"(20\d{2})(\d{2})(\d{2})\d{6,}", u)
        if m:
            y, mo, d = map(int, m.groups())
            return roc(y - 1911, mo, d)
    raise LookupError("no yyyymmdd timestamp in url")


def meta_date(data, ext):
    if ext == "pdf":
        raw = PdfReader(io.BytesIO(data)).metadata or {}
        s = str(raw.get("/ModDate") or raw.get("/CreationDate") or "")
        m = re.match(r"D:(\d{14})(?:([+-])(\d{2})'?(\d{2}))?", s)
        if not m:
            return None
        t = datetime.strptime(m.group(1), "%Y%m%d%H%M%S")
        if m.group(2):
            sign = 1 if m.group(2) == "+" else -1
            tz = timezone(sign * timedelta(hours=int(m.group(3)), minutes=int(m.group(4))))
            t = t.replace(tzinfo=tz)
        else:
            t = t.replace(tzinfo=TAIPEI)
        return t.astimezone(TAIPEI)
    if ext == "doc":
        t = olefile.OleFileIO(io.BytesIO(data)).get_metadata().last_saved_time
        return t and t.replace(tzinfo=timezone.utc).astimezone(TAIPEI)
    z = zipfile.ZipFile(io.BytesIO(data))
    xml, tag = ("meta.xml", "dc:date") if ext == "odt" else ("docProps/core.xml", "dcterms:modified")
    m = re.search(rf"<{tag}[^>]*>([^<]+)</{tag}>", z.read(xml).decode())
    if not m:
        return None
    t = datetime.fromisoformat(m.group(1).replace("Z", "+00:00"))
    return (t if t.tzinfo else t.replace(tzinfo=timezone.utc)).astimezone(TAIPEI)


def date_from_meta(files):
    dates = [d for d in (meta_date(data, ext) for data, ext in files) if d]
    if not dates:
        raise LookupError("no modification date in file metadata")
    t = max(dates)
    return roc(t.year - 1911, t.month, t.day)


def update(school, cfg, lock, dry):
    urls = [resolve(f) for f in school["files"]]
    raws = [get(u).content for u in urls]
    digest = hashlib.sha256(b"".join(raws)).hexdigest()
    out = ROOT / cfg["output"]
    prefix = cfg["pattern"].split("{roc}")[0].format(name=school["name"])
    existing = sorted(out.glob(prefix + "*.pdf"))
    entry = lock.get(school["code"], {})
    if entry.get("sha256") == digest and existing:
        return "unchanged", existing[-1].name

    files = [(data, kind(data)) for data in raws]
    with tempfile.TemporaryDirectory() as t:
        pdf = merge([to_pdf(data, ext, Path(t)) for data, ext in files])
    strategy = school["date"]
    if strategy == "text":
        stamp = date_from_text(pdf)
    elif strategy == "url":
        stamp = date_from_url(urls)
    else:
        stamp = date_from_meta(files)
    name = cfg["pattern"].format(name=school["name"], roc=stamp)

    if [p.name for p in existing] == [name] and not entry:
        # first run over a hand-collected file: adopt it, keep its bytes
        status = "adopted"
    else:
        status = "updated" if existing else "added"
        if not dry:
            for p in existing:
                p.unlink()
            (out / name).write_bytes(pdf)
    if not dry:
        lock[school["code"]] = {"file": name, "sha256": digest, "urls": urls}
    return status, name


BAR_WIDTH = 24

LABELS = {
    "unchanged": "未變更 unchanged",
    "added": "新增 added",
    "updated": "已更新 updated",
    "adopted": "沿用既有 adopted",
    "error": "錯誤 error",
}

GREEN = "\033[32m"
YELLOW = "\033[33m"
RED = "\033[31m"
GRAY = "\033[90m"
RESET = "\033[0m"


def draw_bar(i, total, short):
    filled = i * BAR_WIDTH // total
    bar = GREEN + "█" * filled + GRAY + "░" * (BAR_WIDTH - filled) + RESET
    sys.stderr.write(f"\r{bar} {i}/{total} {short:<6}")
    sys.stderr.flush()


def main():
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument("codes", nargs="*", help="school codes, default all")
    ap.add_argument("--dry-run", action="store_true", help="report without writing")
    args = ap.parse_args()

    cfg = json.loads(SOURCES.read_text())
    lock_path = ROOT / cfg["lock"]
    lock = json.loads(lock_path.read_text()) if lock_path.exists() else {}
    if shutil.which("soffice") is None:
        print("warning: soffice not found; .doc/.odt sources will fail", file=sys.stderr)

    schools = [s for s in cfg["schools"] if not args.codes or s["code"] in args.codes]
    total = len(schools)
    live = sys.stderr.isatty()  # a log file doesn't want \r control codes
    results = []
    failed = 0

    for i, school in enumerate(schools, 1):
        if live:
            draw_bar(i, total, school.get("short", school["code"]))
        try:
            status, name = update(school, cfg, lock, args.dry_run)
            results.append((school["code"], status, name))
        except Exception as e:
            failed += 1
            results.append((school["code"], "error", str(e)))

    if live:
        sys.stderr.write("\r" + " " * (BAR_WIDTH + 20) + "\r")
        sys.stderr.flush()

    for code, status, name in results:
        if status == "unchanged":
            continue
        stream = sys.stderr if status == "error" else sys.stdout
        color = (RED if status == "error" else YELLOW) if stream.isatty() else ""
        reset = RESET if color else ""
        print(f"{code:6} {color}{LABELS[status]}{reset}  {name}", file=stream)

    unchanged = sum(1 for _, status, _ in results if status == "unchanged")
    changed = total - unchanged - failed
    color = sys.stdout.isatty()
    changed_s = f"{GREEN}已變更 {changed}{RESET}" if color and changed else f"已變更 {changed}"
    failed_s = f"{RED}錯誤 {failed}{RESET}" if color and failed else f"錯誤 {failed}"
    print(f"共檢查 {total} 校，{changed_s}，{failed_s}")

    if not args.dry_run:
        lock_path.write_text(json.dumps(dict(sorted(lock.items())), ensure_ascii=False, indent=2) + "\n")
    sys.exit(1 if failed else 0)


if __name__ == "__main__":
    main()
