-- =========================================
-- 1. 注文ごとの購入金額を算出
-- =========================================

WITH payment_by_order AS (
    SELECT
        order_id,
        SUM(payment_value) AS order_payment
    FROM olist_order_payments_dataset
    GROUP BY order_id
),

-- =========================================
-- 2. 顧客ごとの注文回数を算出
-- =========================================

customer_order_count AS (
    SELECT
        olist_customers_dataset.customer_unique_id,
        COUNT(olist_orders_dataset.order_id) AS order_count
    FROM olist_customers_dataset
    INNER JOIN olist_orders_dataset
        ON olist_customers_dataset.customer_id
        = olist_orders_dataset.customer_id
    GROUP BY olist_customers_dataset.customer_unique_id
),

-- =========================================
-- 3. 注文ごとの購入金額に顧客情報を付与
-- =========================================

order_payment_customer AS (
    SELECT
        olist_orders_dataset.order_id,
        olist_customers_dataset.customer_unique_id,
        payment_by_order.order_payment
    FROM olist_orders_dataset
    INNER JOIN olist_customers_dataset
        ON olist_orders_dataset.customer_id
        = olist_customers_dataset.customer_id
    INNER JOIN payment_by_order
        ON olist_orders_dataset.order_id
        = payment_by_order.order_id
)

-- =========================================
-- 4. リピート顧客の1注文あたり平均購入金額を算出
-- =========================================

SELECT
    AVG(order_payment_customer.order_payment) AS avg_order_value
FROM order_payment_customer
INNER JOIN customer_order_count
    ON order_payment_customer.customer_unique_id
    = customer_order_count.customer_unique_id
WHERE customer_order_count.order_count >= 2;


-- =========================================
-- 5. 非リピート顧客の1注文あたり平均購入金額
-- =========================================

SELECT
    AVG(order_payment_customer.order_payment) AS avg_order_value
FROM order_payment_customer
INNER JOIN customer_order_count
    ON order_payment_customer.customer_unique_id
    = customer_order_count.customer_unique_id
WHERE customer_order_count.order_count = 1;


/*
分析結果

リピート顧客の1注文あたり平均購入金額：148.85 BRL
非リピート顧客の1注文あたり平均購入金額：161.82 BRL

リピート顧客は非リピート顧客と比較して、
1注文あたり平均購入金額が約8.0%低かった。
*/
