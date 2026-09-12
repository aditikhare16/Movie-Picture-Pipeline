#!/bin/bash
export AWS_ACCESS_KEY_ID="<YOUR-KEY>"
export AWS_SECRET_ACCESS_KEY="<YOUR-KEY>"
export AWS_SESSION_TOKEN="<YOUR-TOKEN>"
git clone https://github.com/tfutils/tfenv.git ~/.tfenv 2>/dev/null || true
export PATH="$HOME/.tfenv/bin:$PATH"
tfenv install 1.3.9
tfenv use 1.3.9

terraform init
terraform apply -auto-approve