-- =========================================
-- 1. 注文ごとの購入金額を算出
-- =========================================

SELECT
    order_id,
    SUM(payment_value) AS order_payment
FROM olist_order_payments_dataset
GROUP BY order_id;


-- =========================================
-- 2. リピート顧客を抽出
-- =========================================

SELECT
    customer_unique_id,
    COUNT(order_id) AS order_count
FROM olist_customers_dataset
INNER JOIN olist_orders_dataset
    ON olist_customers_dataset.customer_id
    = olist_orders_dataset.customer_id
GROUP BY customer_unique_id
HAVING COUNT(order_id) >= 2;


-- =========================================
-- 3. 非リピート顧客を抽出
-- =========================================

SELECT
    customer_unique_id,
    COUNT(order_id) AS order_count
FROM olist_customers_dataset
INNER JOIN olist_orders_dataset
    ON olist_customers_dataset.customer_id
    = olist_orders_dataset.customer_id
GROUP BY customer_unique_id
HAVING COUNT(order_id) = 1;


/*
分析結果

リピート顧客の1注文あたり平均購入金額：148.85 BRL
非リピート顧客の1注文あたり平均購入金額：161.82 BRL

リピート顧客は非リピート顧客と比較して、
1注文あたり平均購入金額が約8.0%低かった。
*/
