CREATE TABLE stock_prices (
    price_id SERIAL PRIMARY KEY,
    stock_symbol VARCHAR(255) NOT NULL,
    market VARCHAR(255) NOT NULL,
    date DATE NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    volume BIGINT NOT NULL
);


CREATE TABLE stock_moving_averages (
    id SERIAL PRIMARY KEY,
    stock_symbol VARCHAR(10) NOT NULL,
    date DATE NOT NULL,
    moving_average_50 NUMERIC(10, 2),
    moving_average_150 NUMERIC(10, 2),
    moving_average_200 NUMERIC(10, 2),
    UNIQUE (stock_symbol, date)
);
