-- LAB 2 – ADVANCED QUERIES

-- PART 2: STOCK MARKET DATA ANALYSIS

-- Step 1: Create the stocks table in PostgreSQL
CREATE TABLE IF NOT EXISTS stocks (
    date DATE,                     -- Date of stock price
    stock_symbol VARCHAR(10),      -- Unique ID for the stock (e.g., AAPL, IBM)
    closing_price DECIMAL(10, 4),  -- Closing price in dollars with 4 decimal precision
    volume BIGINT                  -- Volume of shares traded
);

-- Step 2: Load data from the CSV file into the stocks table
-- Adjust the path to where your CSV file is located on your system.
COPY stocks (date, stock_symbol, closing_price, volume)
FROM 'C:/Program Files/PostgreSQL/17/Stocks_2019.csv'  -- Update this path as necessary
WITH (FORMAT csv, HEADER true);

-- Step 3: Create a view for the 5-day moving average
CREATE OR REPLACE VIEW moving_average AS
SELECT 
    date,
    stock_symbol,
    closing_price,
    -- Calculate the 5-day moving average for each stock
    AVG(closing_price) OVER (PARTITION BY stock_symbol ORDER BY date ROWS BETWEEN 4 PRECEDING AND CURRENT ROW) AS moving_avg
FROM stocks;

-- Step 4: Minimum and maximum prices for each stock in 2019
SELECT 
    stock_symbol,
    MIN(closing_price) AS min_price,
    MAX(closing_price) AS max_price
FROM stocks
WHERE date BETWEEN '2019-01-01' AND '2019-12-31'
GROUP BY stock_symbol;

-- Step 5: Stock that gained the most in 2019
SELECT 
    stock_symbol,
    ((MAX(closing_price) - MIN(closing_price)) / MIN(closing_price)) * 100 AS percentage_gain
FROM stocks
WHERE date BETWEEN '2019-01-01' AND '2019-12-31'
GROUP BY stock_symbol
ORDER BY percentage_gain DESC
LIMIT 1;

-- Step 6: Daily gain/loss for each stock
SELECT 
    date,
    stock_symbol,
    CASE 
        WHEN closing_price > LAG(closing_price) OVER (PARTITION BY stock_symbol ORDER BY date) THEN 1
        WHEN closing_price < LAG(closing_price) OVER (PARTITION BY stock_symbol ORDER BY date) THEN 0
        ELSE NULL
    END AS gain
FROM stocks
ORDER BY date, stock_symbol;

-- Step 7: Count of days Apple closed with gain
SELECT 
    COUNT(*) AS days_with_gain
FROM (
    SELECT 
        date,
        closing_price,
        CASE 
            WHEN closing_price > LAG(closing_price) OVER (ORDER BY date) THEN 1
            ELSE 0
        END AS gain
    FROM stocks
    WHERE stock_symbol = 'AAPL'
) AS apple_gains
WHERE gain = 1;

-- Step 8: Monthly gain for each stock
WITH monthly_prices AS (
    SELECT 
        stock_symbol,
        DATE_TRUNC('month', date) AS month,
        FIRST_VALUE(closing_price) OVER (PARTITION BY stock_symbol, DATE_TRUNC('month', date) ORDER BY date) AS first_price,
        LAST_VALUE(closing_price) OVER (PARTITION BY stock_symbol, DATE_TRUNC('month', date) ORDER BY date 
            ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS last_price
    FROM stocks
    WHERE date BETWEEN '2019-01-01' AND '2019-12-31'
)
SELECT 
    stock_symbol,
    month,
    ((last_price - first_price) / first_price) * 100 AS monthly_gain
FROM monthly_prices
GROUP BY stock_symbol, month, first_price, last_price  -- Included first_price and last_price to avoid ambiguity
ORDER BY month, stock_symbol;  -- Optional ordering for readability