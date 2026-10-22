#!/usr/bin/env bash
# Create or update Cursor Automation "早7高僧语录" via Terraform (needs CURSOR_TOKEN).
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT/infra/monk-quotes-automation"

if [[ -z "${CURSOR_TOKEN:-}" ]]; then
  echo "CURSOR_TOKEN is not set. Add a Cursor API key to the Cloud Agent environment secrets, then re-run."
  exit 1
fi

if ! command -v terraform >/dev/null 2>&1; then
  echo "Installing terraform..."
  TF_VER="1.10.5"
  curl -fsSL "https://releases.hashicorp.com/terraform/${TF_VER}/terraform_${TF_VER}_linux_amd64.zip" -o /tmp/terraform.zip
  unzip -qo /tmp/terraform.zip -d /tmp
  export PATH="/tmp:$PATH"
fi

terraform init -input=false
terraform apply -auto-approve -input=false
echo "Done. automation_id=$(terraform output -raw automation_id)"
