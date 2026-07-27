#!/usr/bin/env python3
"""Generate daily report and write to 日报/YYYY-MM-DD.md (Asia/Shanghai)."""

from __future__ import annotations

import json
import os
import sys
import urllib.error
import urllib.request
from datetime import datetime, timedelta, timezone
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
TEMPLATE = ROOT / "模板.md"
REPORT_DIR = ROOT / "日报"


def today_shanghai() -> str:
    tz = timezone(timedelta(hours=8))
    return datetime.now(tz).strftime("%Y-%m-%d")


def latest_sample() -> str:
    files = sorted(REPORT_DIR.glob("*.md"), reverse=True)
    for path in files:
        if path.name != f"{today_shanghai()}.md":
            return path.read_text(encoding="utf-8")[:12000]
    return ""


def call_llm(prompt: str) -> str:
    api_key = os.environ.get("OPENAI_API_KEY", "").strip()
    base_url = os.environ.get("OPENAI_BASE_URL", "https://api.openai.com/v1").rstrip("/")
    model = os.environ.get("OPENAI_MODEL", "agnes-2.0-flash")

    if not api_key:
        raise SystemExit("OPENAI_API_KEY is not set")

    body = json.dumps(
        {
            "model": model,
            "messages": [
                {
                    "role": "system",
                    "content": "你是专业行业情报写手。只输出 Markdown 正文，不要代码块包裹，不要前言后记。",
                },
                {"role": "user", "content": prompt},
            ],
            "temperature": 0.4,
        },
        ensure_ascii=False,
    ).encode("utf-8")

    req = urllib.request.Request(
        f"{base_url}/chat/completions",
        data=body,
        headers={
            "Authorization": f"Bearer {api_key}",
            "Content-Type": "application/json",
        },
        method="POST",
    )

    try:
        with urllib.request.urlopen(req, timeout=300) as resp:
            data = json.loads(resp.read().decode("utf-8"))
    except urllib.error.HTTPError as exc:
        detail = exc.read().decode("utf-8", errors="replace")
        raise SystemExit(f"LLM API error {exc.code}: {detail}") from exc

    choice = data.get("choices", [{}])[0]
    message = choice.get("message") or {}
    content = message.get("content")
    if not content:
        raise SystemExit(f"LLM returned empty content: {json.dumps(data, ensure_ascii=False)[:2000]}")
    content = content.strip()
    if content.startswith("```"):
        lines = content.splitlines()
        if lines[0].startswith("```"):
            lines = lines[1:]
        if lines and lines[-1].strip() == "```":
            lines = lines[:-1]
        content = "\n".join(lines).strip()
    return content


def build_prompt(date_str: str) -> str:
    template = TEMPLATE.read_text(encoding="utf-8")
    sample = latest_sample()
    sample_block = f"\n\n最近一期样例（对齐文风，勿照抄）：\n{sample}" if sample else ""
    return (
        f"请撰写 {date_str} 的完整日报。\n"
        f"严格按下面模板结构与赛道要求执行，章节不可省略：\n\n{template}"
        f"{sample_block}"
    )


def main() -> None:
    date_str = today_shanghai()
    REPORT_DIR.mkdir(parents=True, exist_ok=True)
    out = REPORT_DIR / f"{date_str}.md"

    print(f"Generating report for {date_str} -> {out}")
    report = call_llm(build_prompt(date_str))
    if f"{date_str}" not in report[:200]:
        report = f"# 赛博韩信日报｜佛教情感疗愈赛道｜{date_str}\n\n{report}"

    out.write_text(report + "\n", encoding="utf-8")
    print(f"Wrote {out} ({out.stat().st_size} bytes)")


if __name__ == "__main__":
    main()
