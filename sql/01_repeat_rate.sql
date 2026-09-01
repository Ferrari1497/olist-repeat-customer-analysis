-- リピート顧客数を算出
SELECT COUNT(*)
FROM (
    SELECT
        olist_customers_dataset.customer_unique_id,
        COUNT(olist_orders_dataset.customer_id)
    FROM olist_orders_dataset
    INNER JOIN olist_customers_dataset
        ON olist_orders_dataset.customer_id
        = olist_customers_dataset.customer_id
    GROUP BY olist_customers_dataset.customer_unique_id
    HAVING COUNT(olist_orders_dataset.customer_id) >= 2
) AS repeat_customers;


-- 全顧客数を算出
SELECT COUNT(DISTINCT customer_unique_id) AS total_customers
FROM olist_customers_dataset;
