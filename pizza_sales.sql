USE pizzahut;

-- Retrieve the total number of orders placed.
SELECT count(order_id) as total_orders from ORDERS;

-- Calculate the total revenue generated from pizza sales.
SELECT 
    ROUND(SUM(od.quantity * p.price), 2) AS total_revenue
FROM
    order_detailss AS od
        JOIN
    pizzas AS p ON p.pizza_id = od.pizza_id;

-- Identify the highest-priced pizza. 
SELECT 
    pt.name, p.price
FROM
    pizza_types AS pt
        JOIN
    pizzas AS p ON pt.pizza_type_id = p.pizza_type_id
ORDER BY price DESC
LIMIT 1;   

-- Identify the most common pizza size ordered.
SELECT 
    p.size, COUNT(od.order_details_id) AS count_orders
FROM
    pizzas AS p
        JOIN
    order_detailss AS od ON p.pizza_id = od.pizza_id
GROUP BY p.size
ORDER BY count_orders DESC
LIMIT 1;

-- List the top 5 most ordered pizza types along with their quantities.
SELECT 
    pt.name, SUM(od.quantity) AS quantity
FROM
    pizza_types AS pt
        JOIN
    pizzas AS p ON pt.pizza_type_id = p.pizza_type_id
        JOIN
    order_detailss AS od ON od.pizza_id = p.pizza_id
GROUP BY pt.name , quantity
ORDER BY quantity DESC
LIMIT 5;

-- Join the necessary tables to find the total quantity of each pizza category ordered.
SELECT 
    pt.category, SUM(od.quantity) AS Quantity
FROM
    pizza_types AS pt
        JOIN
    pizzas AS p ON pt.pizza_type_id = p.pizza_type_id
        JOIN
    order_detailss AS od ON od.pizza_id = p.pizza_id
GROUP BY pt.category
ORDER BY quantity DESC;

-- Determine the distribution of orders by hour of the day.
SELECT 
    HOUR(time) AS HOURS, COUNT(order_id) AS total_order
FROM
    orders
GROUP BY HOURS
ORDER BY hours DESC;

--  find the category-wise distribution of pizzas.
SELECT 
    CATEGORY, COUNT(name) AS name_count
FROM
    pizza_types
GROUP BY category
ORDER BY name_count DESC;

-- Group the orders by date and calculate the average number of pizzas ordered per day.
Select avg(quantity) as avg_of_orders
from 
(select o.date ,sum(od.Quantity)as quantity 
from orders as o join order_detailss as od
on o.order_id= od.order_id
group by o.date) as orders;

-- Determine the top 3 most ordered pizza types based on revenue.
SELECT 
    pt.name, SUM(od.quantity * p.price) AS revenue
FROM
    pizza_types AS pt
        JOIN
    pizzas AS p ON pt.pizza_type_id = p.pizza_type_id
        JOIN
    order_detailss AS od ON od.pizza_id = p.pizza_id
GROUP BY pt.name
ORDER BY revenue DESC
LIMIT 3;

select  pt.category ,round( (sum(od.quantity* p.price) / (SELECT 
    ROUND(SUM(od.quantity * p.price), 2) AS total_revenue
FROM
    order_detailss AS od
        JOIN
    pizzas AS p ON p.pizza_id = od.pizza_id))*100 ,2)as revenue
from pizza_types as pt join pizzas as p
on pt.pizza_type_id=p.pizza_type_id 
join order_detailss as od
on od.pizza_id = p.pizza_id
group by pt.category
order by revenue desc;

-- Analyze the cumulative revenue generated over time.
SELECT date ,sum(revenue) over (order by date) as cumu_revenue
from
(select  o.date , sum(od.quantity* p.price)as revenue
from orders as o join order_detailss as od
on o.order_id=od.order_id
join pizzas as p
on od.pizza_id = p.pizza_id
group by o.date) as sales;


-- Determine the top 3 most ordered pizza types based on revenue for each pizza category.
select category,name , revenue 
from 
(select category , name ,revenue ,
rank() over (partition by category order by revenue desc) as rn 
from 
(select  pt.category ,pt.name, sum(od.quantity* p.price)as revenue
from pizza_types as pt join pizzas as p
on pt.pizza_type_id=p.pizza_type_id
join order_detailss as od
on od.pizza_id = p.pizza_id
group by 1,2) as a ) as b
where rn <=3;












 


