#!/usr/bin/env bash
# 本番サーバーで実行する更新の手順
set -euo pipefail

# SSH から呼ばれたときに uv が見つかるようにする
export PATH="$HOME/.local/bin:$PATH"

echo "==> アプリのフォルダーに移動します"
cd /var/www/marche-app

echo "==> 最新のコードを取得します (git pull --ff-only origin main)"
git pull --ff-only origin main

echo "==> 依存パッケージを同期します (uv sync --frozen --no-dev)"
uv sync --frozen --no-dev

echo "==> データベースのマイグレーションを適用します (flask db upgrade)"
uv run --frozen --no-dev flask db upgrade

echo "==> アプリを再起動します (systemctl restart marche-app)"
sudo -n systemctl restart marche-app

echo "==> 2 秒待って、起動したか確かめます"
sleep 2
systemctl is-active marche-app

echo "==> 更新が完了しました"
