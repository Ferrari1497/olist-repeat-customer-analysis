-- =========================================
-- 1. 注文ごとの購入点数を算出
-- =========================================

WITH items_by_order AS (
    SELECT
        order_id,
        COUNT(order_item_id) AS item_count
    FROM olist_order_items_dataset
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
        INNER JOIN olist_orders_dataset ON olist_customers_dataset.customer_id = olist_orders_dataset.customer_id
    GROUP BY olist_customers_dataset.customer_unique_id
),

-- =========================================
-- 3. 注文ごとの購入点数に顧客情報を付与
-- =========================================

order_items_customer AS (
    SELECT
        olist_orders_dataset.order_id,
        olist_customers_dataset.customer_unique_id,
        items_by_order.item_count
    FROM olist_orders_dataset
        INNER JOIN olist_customers_dataset ON olist_orders_dataset.customer_id　= olist_customers_dataset.customer_id
        INNER JOIN items_by_order ON olist_orders_dataset.order_id　= items_by_order.order_id
)

-- =========================================
-- 4. 1注文あたり平均購入金額を算出
--    リピート顧客：order_count >= 2
--    非リピート顧客：order_count = 1
-- =========================================

SELECT
    AVG(order_items_customer.item_count) AS avg_items_per_order
FROM order_items_customer
    INNER JOIN customer_order_count ON order_items_customer.customer_unique_id = customer_order_count.customer_unique_id
WHERE customer_order_count.order_count >= 2;


/*
分析結果

リピート顧客の1注文あたり平均購入点数：1.21点
非リピート顧客の1注文あたり平均購入点数：1.14点

リピート顧客の方が0.07点多かったが、
大きな差は確認されなかった。
*/
