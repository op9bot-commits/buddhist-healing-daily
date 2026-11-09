terraform {
  required_providers {
    cursor = {
      source  = "cursor/cursor"
      version = "~> 0.1"
    }
  }
}

provider "cursor" {}

resource "cursor_platform_workflow" "monk_quotes_7am" {
  name        = "早7高僧语录"
  description = "每天北京时间 07:00 写入 Notion《Cursor 早7执行高僧语录》当日子页。"
  scope       = "user"
  enabled     = true

  prompt = file("${path.module}/../../早7高僧语录/AUTOMATION-PROMPT.md")

  git_repo   = "github.com/op9bot-commits/buddhist-healing-daily"
  git_branch = "main"

  memory_enabled         = true
  disabled_default_tools = ["open_git_pr"]

  trigger = [
    {
      cron = {
        schedule = "0 7 * * *"
      }
    }
  ]

  action = [
    {
      mcp = {
        server = "Notion"
      }
    }
  ]
}

output "automation_id" {
  value = cursor_platform_workflow.monk_quotes_7am.id
}
