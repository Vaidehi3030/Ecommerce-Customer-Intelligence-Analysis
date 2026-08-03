SELECT * FROM ecommerce_data;

-----------------------------
#BASIC BUSINESS KPI ANALYSIS:
-----------------------------

#TOTAL REVENUE
-- BUSINESS PROBLEM:
-- Calculate overall platform revenue
SELECT 
	SUM(payment_value) AS total_revenue
FROM ecommerce_data;
#TR = 20579664.00
-- INSIGHT:
-- The platform generated strong overall revenue, indicating healthy transaction activity across the marketplace.

-- BUSINESS RECOMMENDATION:
-- Continue focusing on customer acquisition and retention strategies to sustain revenue growth.


#MONTHLY REVENUE TREND
-- BUSINESS PROBLEM:
-- Analyze monthly revenue trends over time
SELECT 
	DATE_TRUNC('month',order_purchase_timestamp) AS month,
	SUM(payment_value) AS revenue
FROM ecommerce_data
GROUP BY month
ORDER BY month;
-- INSIGHT:
-- Revenue showed monthly fluctuations, helping identify seasonal demand patterns and business growth periods.

-- BUSINESS RECOMMENDATION:
-- Use high-performing months for aggressive promotional campaigns and prepare inventory before seasonal demand spikes.


#REVENUE BY STATE
-- BUSINESS PROBLEM:
-- Identify top-performing states based on revenue contribution
SELECT
	customer_state,
	SUM(payment_value) AS revenue
FROM ecommerce_data
GROUP BY customer_state
ORDER BY revenue DESC;
-- INSIGHT:
-- States like SP and RJ contributed significantly higher revenue compared to other regions.

-- BUSINESS RECOMMENDATION:
-- Increase logistics efficiency, targeted marketing, and seller expansion in high-performing states.


------------------
#BUSINESS QUERIES:
------------------

#TOP PRODUCT CATEGORIES
-- BUSINESS PROBLEM:
-- Identify product categories generating highest revenue
SELECT 
    product_category_name,
    SUM(payment_value) AS revenue
FROM ecommerce_data
GROUP BY product_category_name
ORDER BY revenue DESC
LIMIT 10;
-- INSIGHT:
-- A few product categories contributed disproportionately to total revenue, indicating strong customer demand in those segments.

-- BUSINESS RECOMMENDATION:
-- Prioritize inventory management, promotions, and seller onboarding for top-performing categories.


#DELIVERY DELAY ANALYSIS
-- BUSINESS PROBLEM:
-- Analyze average delivery delays across states
SELECT 
    customer_state,
    AVG(delivery_delay_days) AS avg_delay
FROM ecommerce_data
GROUP BY customer_state
ORDER BY avg_delay DESC;
-- INSIGHT:
-- Certain states experienced significantly higher delivery delays, indicating logistics inefficiencies in specific regions.

-- BUSINESS RECOMMENDATION:
-- Optimize shipping routes and improve warehouse distribution in high-delay regions.


#CUSTOMER SATISFACTION VS DELIVERY DELAY
-- BUSINESS PROBLEM:
-- Analyze relationship between customer ratings and delivery delays
SELECT 
    review_score,
    AVG(delivery_delay_days) AS avg_delay
FROM ecommerce_data
GROUP BY review_score
ORDER BY review_score;
-- INSIGHT:
-- Lower review scores were associated with higher delivery delays, showing logistics performance directly impacts customer satisfaction.

-- BUSINESS RECOMMENDATION:
-- Reduce delayed deliveries to improve customer experience and maintain positive marketplace ratings.


#SELLER PERFORMANCE
-- BUSINESS PROBLEM:
-- Evaluate seller performance using orders, revenue, and ratings
SELECT 
    seller_id,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(payment_value) AS revenue,
    AVG(review_score) AS avg_rating
FROM ecommerce_data
GROUP BY seller_id
ORDER BY revenue DESC
LIMIT 20;
-- INSIGHT:
-- Some sellers generated high revenue while also maintaining strong customer ratings, indicating efficient operational performance.

-- BUSINESS RECOMMENDATION:
-- Promote high-performing sellers and provide operational support to low-rated sellers.


#PAYMENT METHOD ANALYSIS
-- BUSINESS PROBLEM:
-- Analyze customer payment preferences
SELECT 
    payment_type,
    SUM(payment_value) AS revenue
FROM ecommerce_data
GROUP BY payment_type
ORDER BY revenue DESC;
-- INSIGHT:
-- Credit cards contributed the highest revenue share, showing strong customer preference for digital card payments.

-- BUSINESS RECOMMENDATION:
-- Introduce payment-related offers and partnerships for the most preferred payment methods.


#REPEAT CUSTOMERS
-- BUSINESS PROBLEM:
-- Identify customers with multiple purchases
SELECT 
    customer_unique_id,
    COUNT(DISTINCT order_id) AS total_orders
FROM ecommerce_data
GROUP BY customer_unique_id
HAVING COUNT(DISTINCT order_id) > 1;
-- INSIGHT:
-- A portion of customers placed repeat orders, indicating opportunities for customer retention and loyalty programs.

-- BUSINESS RECOMMENDATION:
-- Implement personalized recommendations and loyalty incentives to increase repeat purchases.


----------------------
#ADVANCED SQL QUERIES:
----------------------

#SELLER RANKING
-- BUSINESS PROBLEM:
-- Rank sellers based on revenue contribution
SELECT 
    seller_id,
    SUM(payment_value) AS revenue,
    RANK() OVER (
        ORDER BY SUM(payment_value) DESC
    ) AS seller_rank
FROM ecommerce_data
GROUP BY seller_id;
-- INSIGHT:
-- Revenue contribution was concentrated among a small group of top-performing sellers.

-- BUSINESS RECOMMENDATION:
-- Strengthen partnerships with top sellers while helping smaller sellers improve marketplace performance.


#RUNNING REVENUE
-- BUSINESS PROBLEM:
-- Analyze cumulative revenue growth over time
SELECT 
    DATE_TRUNC('month', order_purchase_timestamp) AS month,
    SUM(payment_value) AS monthly_revenue,
    SUM(SUM(payment_value)) OVER (
        ORDER BY DATE_TRUNC('month', order_purchase_timestamp)
    ) AS running_revenue
FROM ecommerce_data
GROUP BY month
ORDER BY month;
-- INSIGHT:
-- Running revenue showed consistent cumulative business growth across months.

-- BUSINESS RECOMMENDATION:
-- Use long-term growth trends for forecasting and strategic planning.


#PREVIOUS MONTH REVENUE
-- BUSINESS PROBLEM:
-- Compare current month revenue with previous month performance 
WITH monthly_sales AS (
    SELECT 
        DATE_TRUNC('month', order_purchase_timestamp) AS month,
        SUM(payment_value) AS revenue
    FROM ecommerce_data
    GROUP BY month
)
SELECT 
    month,
    revenue,
    LAG(revenue) OVER (
        ORDER BY month
    ) AS previous_month_revenue
FROM monthly_sales;
-- INSIGHT:
-- Revenue varied month-over-month, helping identify growth periods and slower business cycles.

-- BUSINESS RECOMMENDATION:
-- Investigate factors affecting revenue dips and strengthen campaigns during low-performing periods.


#TOP CUSTOMERS
-- BUSINESS PROBLEM:
-- Identify highest-spending customers
SELECT 
    customer_unique_id,
    SUM(payment_value) AS total_spent,
    DENSE_RANK() OVER (
        ORDER BY SUM(payment_value) DESC
    ) AS customer_rank
FROM ecommerce_data
GROUP BY customer_unique_id;
-- INSIGHT:
-- A small percentage of customers contributed significantly higher spending compared to average customers.

-- BUSINESS RECOMMENDATION:
-- Develop VIP customer retention programs and personalized marketing campaigns for high-value customers.


#DELIVERY PERFORMANCE RANKING
-- BUSINESS PROBLEM:
-- Rank states based on average delivery delays
SELECT 
    customer_state,
    AVG(delivery_delay_days) AS avg_delay,
    RANK() OVER (
        ORDER BY AVG(delivery_delay_days) DESC
    ) AS delay_rank
FROM ecommerce_data
GROUP BY customer_state;
-- INSIGHT:
-- Certain states consistently ranked poorly in delivery performance, highlighting operational bottlenecks.

-- BUSINESS RECOMMENDATION:
-- Improve courier partnerships and logistics infrastructure in poorly performing regions.
