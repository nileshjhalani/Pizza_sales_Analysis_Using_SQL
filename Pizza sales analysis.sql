-- Q1 Retrieve the total number of orders placed.

SELECT 
    COUNT(order_id) AS total_orders
FROM
    orders;

-- Q.2 Calculate the total revenue generated from pizza sales.

SELECT 
    ROUND(SUM(pz.price * od.quantity), 2) as total_revenue
FROM
    pizzas AS pz
        JOIN
    orders_details AS od ON pz.pizza_id = od.Pizza_id;
    

-- Q.3 Identify the highest-priced pizza.

SELECT 
    pzt.name, pz.price
FROM
    pizzas AS pz
        JOIN
    pizza_types AS pzt ON pzt.pizza_type_id = pz.pizza_type_id
ORDER BY pz.price DESC
LIMIT 1;

-- Q.4 Identify the most common pizza size ordered.

SELECT 
    pz.size, COUNT(od.order_details_id) AS Total_order
FROM
    pizzas AS pz
        JOIN
    orders_details AS od ON od.Pizza_id = pz.pizza_id
GROUP BY pz.size
ORDER BY total_order DESC;

-- Q.5 List the top 5 most ordered pizza types along with their quantities.

SELECT 
    pzt.name, SUM(od.quantity) AS max_order
FROM
    pizza_types AS pzt
        JOIN
    pizzas AS pz ON pz.pizza_type_id = pzt.pizza_type_id
        JOIN
    orders_details AS od ON od.Pizza_id = pz.pizza_id
GROUP BY pzt.name
ORDER BY max_order DESC
LIMIT 5;

-- Q.6 Join the necessary tables to find the total quantity of each pizza category ordered.

SELECT 
    pzt.category, SUM(od.quantity) as total_quantity
FROM
    pizza_types AS pzt
        JOIN
    pizzas AS pz ON pz.pizza_type_id = pzt.pizza_type_id
        JOIN
    orders_details AS od ON pz.pizza_id = od.Pizza_id
GROUP BY pzt.category;

-- Q.7 Determine the distribution of orders by hour of the day.

SELECT 
    HOUR(order_time) AS hour, COUNT(order_id) AS order_count
FROM
    orders
GROUP BY hour 
order by hour;

-- Q.8 Join relevant tables to find the category-wise distribution of pizzas.

SELECT 
    category, COUNT(name) as count
FROM	
    pizza_types AS pzt
GROUP BY category; 

-- Q.9 Group the orders by date and calculate the average number of pizzas ordered per day.

SELECT 
    ROUND(AVG(quantity), 0) as Average_order
FROM
    (SELECT 
        o.order_date AS date, SUM(od.quantity) AS quantity
    FROM
        orders AS o
    JOIN orders_details AS od ON o.order_id = od.order_id
    GROUP BY date) AS order_quantity;
    
-- Q.10 Determine the top 3 most ordered pizza types based on revenue.

SELECT 
    pzt.name,
    ROUND(SUM(pz.price * od.quantity), 2) AS total_sales
FROM
    pizza_types AS pzt
        JOIN
    pizzas AS pz ON pz.pizza_type_id = pzt.pizza_type_id
        JOIN
    orders_details AS od ON pz.pizza_id = od.Pizza_id
GROUP BY pzt.name
ORDER BY total_sales DESC
LIMIT 3;


-- Q.11 Calculate the percentage contribution of each pizza type to total revenue.

SELECT 
    pzt.category,
    ROUND(SUM(pz.price * od.quantity) / (SELECT 
                    ROUND(SUM(pz.price * od.quantity), 2)
                FROM
                    pizzas AS pz
                        JOIN
                    orders_details AS od ON pz.pizza_id = od.Pizza_id) * 100,
            2) AS revenue
FROM
    pizza_types AS pzt
        JOIN
    pizzas AS pz ON pzt.pizza_type_id = pz.pizza_type_id
        JOIN
    orders_details AS od ON od.Pizza_id = pz.pizza_id
GROUP BY pzt.category;



-- Q.12 Analyze the cumulative revenue generated over time.

select date , sum(revenue)  over ( order by date) as cum_revenue from
(select o.order_date as date , sum(pz.price* od.quantity) as Revenue from orders_details as od
join pizzas as pz
on pz.pizza_id = od.pizza_id
join orders as o
on od.order_id = o.order_id
group by date) as sales;


-- Q.13 Determine the top 3 most ordered pizza types based on revenue for each pizza category.

select category, name, revenue from
(Select category , name , revenue , rank() over (partition by category order by revenue ) as  rn 
from
(select pzt.category , pzt.name , sum(pz.price*od.quantity) as revenue from pizza_types as pzt
join pizzas as pz
on pz.pizza_type_id = pzt.pizza_type_id
join orders_details as od
on od.Pizza_id = pz.pizza_id
group by pzt.category , pzt.name) as a) as b
where rn<=3;




