# 佛教情感疗愈日报

每天 **08:00** 自动出报，文件在 `日报/YYYY-MM-DD.md`。

## 你怎么用

打开这个仓库 → 看 `日报/` 文件夹。**完事。**

## 背后怎么跑（不用你管）

1. **Cursor Automation**（你若还开着）写完会建 PR → GitHub 自动 merge 到 `main`
2. **GitHub Actions 兜底**：若 8 点 `main` 上还没有当天文件，自动补生成并 push

手动补跑：GitHub → Actions → **Daily Push** → Run workflow
