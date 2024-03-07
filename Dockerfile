FROM postgres:latest

# スクリプトとSQLクエリをイメージにコピー
COPY run_query.sh /scripts/
COPY update_moving_averages.sql /scripts/

# 実行権限を付与
RUN chmod +x /scripts/run_query.sh && apt-get update && apt-get install -y curl

# スクリプトを実行
CMD ["/scripts/run_query.sh"]
