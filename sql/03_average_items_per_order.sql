-- =========================================
-- 1. 注文ごとの購入点数を算出
-- =========================================

SELECT
    order_id,
    COUNT(order_item_id) AS item_count
FROM olist_order_items_dataset
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

リピート顧客の1注文あたり平均購入点数：1.21点
非リピート顧客の1注文あたり平均購入点数：1.14点

リピート顧客の方が0.07点多かったが、
大きな差は確認されなかった。
*/
