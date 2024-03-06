#!/bin/bash

# 環境変数からデータベース接続設定を取得
DB_USER="${DATABASE_USER}"
DB_PASSWORD="${DATABASE_PASSWORD}"
DB_NAME="${DATABASE_NAME}"
DB_HOST="${DATABASE_HOST}"
DB_PORT="${DATABASE_PORT}"

# SQLクエリを実行
# 注意: -a オプションはすべての出力を表示するために使用されます。必要に応じて削除または変更してください。
PGPASSWORD=$DB_PASSWORD psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -a -f /scripts/update_moving_averages.sql
