-- =========================================
-- 1. 全顧客数を算出
-- =========================================

SELECT
    COUNT(DISTINCT customer_unique_id)
FROM olist_customers_dataset;


-- =========================================
-- 2. リピート顧客数を算出
-- =========================================

SELECT
	COUNT(*)
FROM(
	SELECT
		olist_customers_dataset.customer_unique_id
	FROM olist_customers_dataset
		INNER JOIN olist_orders_dataset ON olist_customers_dataset.customer_id=olist_orders_dataset.customer_id
	GROUP BY olist_customers_dataset.customer_unique_id
	HAVING COUNT(olist_orders_dataset.order_id)>=2
) AS repeat_customer_data;


/*
分析結果

全顧客数：96,096人
リピート顧客数：2,997人
リピート率：3.12%

全顧客のうち、リピート顧客の割合は3.12%にとどまった。
*/
