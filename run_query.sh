#!/bin/bash

# データベース操作開始をログに記録
echo "Starting database operation..."

# 環境変数からデータベース接続設定を取得
DB_USER="${DATABASE_USER}"
DB_PASSWORD="${DATABASE_PASSWORD}"
DB_NAME="${DATABASE_NAME}"
DB_HOST="${DATABASE_HOST}"
DB_PORT="${DATABASE_PORT}"

# SQLクエリを実行し、結果をログに記録
PGPASSWORD=$DB_PASSWORD psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -a -f /scripts/update_moving_averages.sql

# データベース操作完了をログに記録
echo "Database operation completed."

# Slackに送信するメッセージ
SLACK_MESSAGE="移動平均計算完了"

# Slack APIトークンとチャンネルID（環境変数から取得）
SLACK_TOKEN="${SLACK_API_TOKEN}"
SLACK_CHANNEL="${SLACK_CHANNEL_ID}"

# Slackにメッセージを送信
curl -X POST "https://slack.com/api/chat.postMessage" \
    -H "Authorization: Bearer ${SLACK_TOKEN}" \
    -H 'Content-type: application/json' \
    --data "{
        \"channel\": \"${SLACK_CHANNEL}\",
        \"text\": \"${SLACK_MESSAGE}\"
    }"

