-- =========================================
-- 0. 既存の一時テーブルを削除
-- =========================================

DROP TABLE IF EXISTS order_items_customer;
DROP TABLE IF EXISTS customer_order_count;
DROP TABLE IF EXISTS items_by_order;


-- =========================================
-- 1. 注文ごとの購入点数を一時テーブルに保存
-- =========================================

CREATE TEMP TABLE items_by_order AS
SELECT
    order_id,
    COUNT(order_item_id) AS item_count
FROM olist_order_items_dataset
GROUP BY order_id;


-- =========================================
-- 2. 顧客ごとの注文回数を一時テーブルに保存
-- =========================================

CREATE TEMP TABLE customer_order_count AS
SELECT
    customer_unique_id,
    COUNT(order_id) AS order_count
FROM olist_customers_dataset
INNER JOIN olist_orders_dataset
    ON olist_customers_dataset.customer_id
    = olist_orders_dataset.customer_id
GROUP BY customer_unique_id;


-- =========================================
-- 3. 注文ごとの購入点数に顧客情報を付与
-- =========================================

CREATE TEMP TABLE order_items_customer AS
SELECT
    olist_orders_dataset.order_id,
    olist_customers_dataset.customer_unique_id,
    items_by_order.item_count
FROM olist_orders_dataset
INNER JOIN olist_customers_dataset
    ON olist_orders_dataset.customer_id
    = olist_customers_dataset.customer_id
INNER JOIN items_by_order
    ON olist_orders_dataset.order_id
    = items_by_order.order_id;


-- =========================================
-- 4. リピート顧客の1注文あたり平均購入点数
-- =========================================

SELECT
    AVG(item_count) AS avg_items_per_order
FROM order_items_customer
INNER JOIN customer_order_count
    ON order_items_customer.customer_unique_id
    = customer_order_count.customer_unique_id
WHERE order_count >= 2;


-- =========================================
-- 5. 非リピート顧客の1注文あたり平均購入点数
-- =========================================

SELECT
    AVG(item_count) AS avg_items_per_order
FROM order_items_customer
INNER JOIN customer_order_count
    ON order_items_customer.customer_unique_id
    = customer_order_count.customer_unique_id
WHERE order_count = 1;


/*
分析結果

リピート顧客の1注文あたり平均購入点数：1.21点
非リピート顧客の1注文あたり平均購入点数：1.14点

リピート顧客の方が0.07点多かったが、
大きな差は確認されなかった。
*/
