# 佛教情感疗愈日报

每天北京时间 **08:00** 由 Cursor Automation 自动检索并写入 `日报/YYYY-MM-DD.md`。

在 Cursor 中打开本仓库即可阅读。

## 目录

- `日报/`：按日期存放的日报正文
- `模板.md`：写作结构与检索口径（Automation 按此执行）
- `AUTOMATION-PROMPT.md`：Automation 指令全文（复制到 Cursor Automations → Instructions）
- `automation.prefill.json`：正确的定时任务配置草稿（Trigger = cron `0 8 * * *`，Repo = 本仓库）

## 定时任务（Cursor Automations）

| 配置项 | 正确值 |
|--------|--------|
| 名称 | 佛教情感疗愈日报 |
| 触发 | **Schedule** · 每天 **08:00 GMT+8**（cron `0 8 * * *`） |
| 仓库 | `op9bot-commits/buddhist-healing-daily` · `main` |
| 指令 | 见 `AUTOMATION-PROMPT.md`（**必须含「直接 push 到 main」**） |

**常见故障**

| 现象 | 原因 | 处理 |
|------|------|------|
| Run History 里 TRIGGER 是 `Pull Request` | 触发器配错 | Settings → Trigger 改为 Schedule 08:00 |
| 8 点跑了但 `main` 没新文件 | Agent 建了 Draft PR 未合并 | 已加 GitHub Actions 自动合并 `cursor/*` PR |
| 08:30 收到 Actions 失败邮件 | 当天 `main` 仍无日报 | 到 Automations → Run History 看报错 |

## GitHub Actions 兜底

| Workflow | 作用 |
|----------|------|
| `auto-merge-cursor-pr.yml` | Cursor Agent 若仍建 `cursor/*` PR，自动 ready + merge 到 `main` |
| `verify-daily-report.yml` | 每天 08:30 检查 `main` 是否有当日日报，缺失则失败告警 |

## 更新 Automation 指令

若 Cursor 里还是旧版指令，请把 `AUTOMATION-PROMPT.md` 全文粘贴到 Automations → Instructions 并保存。

查看运行记录：Cursor 左侧 **Automations** → 选中本任务 → **Run History**。
