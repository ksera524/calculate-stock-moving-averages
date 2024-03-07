WITH current_prices AS (
    SELECT
        stock_symbol,
        MAX(date) AS latest_date
    FROM
        stock_prices
    GROUP BY
        stock_symbol
),
ranked_prices AS (
    SELECT
        p.stock_symbol,
        cp.latest_date,
        p.date,
        p.price,
        AVG(p.price) OVER (PARTITION BY p.stock_symbol ORDER BY p.date ROWS BETWEEN 49 PRECEDING AND CURRENT ROW) AS moving_average_50,
        AVG(p.price) OVER (PARTITION BY p.stock_symbol ORDER BY p.date ROWS BETWEEN 149 PRECEDING AND CURRENT ROW) AS moving_average_150,
        AVG(p.price) OVER (PARTITION BY p.stock_symbol ORDER BY p.date ROWS BETWEEN 199 PRECEDING AND CURRENT ROW) AS moving_average_200
    FROM
        stock_prices p
    INNER JOIN
        current_prices cp ON p.stock_symbol = cp.stock_symbol AND p.date = cp.latest_date
)
INSERT INTO stock_moving_averages (stock_symbol, date, moving_average_50, moving_average_150, moving_average_200)
SELECT
    stock_symbol,
    latest_date AS date,
    CASE WHEN COUNT(price) OVER (PARTITION BY stock_symbol ORDER BY date ROWS BETWEEN 49 PRECEDING AND CURRENT ROW) >= 50 THEN moving_average_50 ELSE NULL END,
    CASE WHEN COUNT(price) OVER (PARTITION BY stock_symbol ORDER BY date ROWS BETWEEN 149 PRECEDING AND CURRENT ROW) >= 150 THEN moving_average_150 ELSE NULL END,
    CASE WHEN COUNT(price) OVER (PARTITION BY stock_symbol ORDER BY date ROWS BETWEEN 199 PRECEDING AND CURRENT ROW) >= 200 THEN moving_average_200 ELSE NULL END
FROM
    ranked_prices
ON CONFLICT (stock_symbol, date)
DO NOTHING;  -- 既に存在するレコードの場合は何もしない
