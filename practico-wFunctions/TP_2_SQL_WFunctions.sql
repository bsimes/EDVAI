-----------------------------
-- Tp Nro 2: Window Functions
-----------------------------

--1 
select c.category_name, p.product_name, p.unit_price, 
avg(p.unit_price ) over (partition by c.category_id)
from categories c 
inner join products p on p.category_id = c.category_id

--2
select o.order_id, c.customer_id, o.employee_id, o.order_date, o.required_date, 
o.shipped_date,avg(od.quantity * od.unit_price ) over (partition by c.customer_id)
from customers c 
inner join orders o on o.customer_id = c.customer_id
inner join order_details od on od.order_id = o.order_id
order by c.customer_id 

--3
select  p.product_name, c.category_name , p.quantity_per_unit, od.unit_price, od.quantity , 
c.category_name , avg(od.quantity) over (partition by c.category_id) as avgquantity
from categories c 
inner join products p on p.category_id = c.category_id
inner join order_details od on od.product_id = p.product_id
order by c.category_name, p.product_name

--4
select c.customer_id, o.order_date, min(o.order_date) over (partition by o.customer_id) as earliersorderdate
from customers c 
inner join orders o on o.customer_id  = c.customer_id
order by c.company_name, o.order_date

--5
select p.product_id, p.product_name, p.unit_price, p.category_id, 
max(p.unit_price) over (partition by c.category_id) as maxunitprice
from products p 
inner join categories c on c.category_id = p.category_id

--6 
select ROW_NUMBER() OVER (ORDER BY SUM(od.quantity) desc ) AS ranking, p.product_name, 
SUM(od.quantity) AS totalquantity
from products p 
inner join order_details od on od.product_id  = p.product_id
group by  p.product_name 
order by SUM(od.quantity ) desc

--7
select row_number() over (order by c.customer_id  asc), 
c.customer_id , c.company_name, c.contact_name, c.contact_title, c.address
from customers c 

--8
select row_number() over (order by e.birth_date desc ), 
CONCAT(e.first_name, ' ', e.last_name) AS employname, e.birth_date
from employees e

--9
select sum(od.quantity * od.unit_price) over (partition by c.customer_id) as total,
o.order_id, c.customer_id, o.employee_id, 
o.order_date, o.required_date
from customers c 
inner join orders o on o.customer_id = c.customer_id
inner join order_details od on od.order_id  = o.order_id
 
--10
select c.category_name , p.product_name, od.unit_price, od.quantity,
sum(od.quantity * od.unit_price) over (partition by c.category_name   ) as totalsales
from categories c 
inner join products p on p.category_id = c.category_id
inner join  order_details od on od.product_id = p.product_id
order by c.category_name, p.product_name asc 

--11
SELECT o.ship_country, o.order_id , o.shipped_date, o.freight,
sum(o.freight) over (order by o.ship_country)
from orders o  where o.shipped_date is not null
order by o.ship_country, o.order_id asc
 
--12
 SELECT 
  customer_id,
  company_name,
  ventas ,
  RANK() OVER (ORDER BY  ventas DESC) AS ranking
FROM (
  SELECT 
    o.customer_id, 
    c.company_name,
    SUM(od.quantity * od.unit_price) AS ventas
  FROM orders o
  INNER JOIN order_details od ON od.order_id = o.order_id
  INNER JOIN customers c ON c.customer_id = o.customer_id
  GROUP BY o.customer_id, c.company_name
) AS ventas
ORDER BY ranking;

--13
select  e.employee_id , e.last_name , e.first_name , e.hire_date, 
 rank() over (order by e.hire_date asc)
from employees e 

--14
select  p.product_id, p.product_name,p.unit_price,
rank() over (order by p.unit_price desc)
from products p 
--limit 10

--15 (with nulls ?)
select od.order_id, od.product_id , od.quantity ,
lag(od.quantity ) over(partition by od.order_id order by od.order_id, od.product_id asc) as cantidadPrevia
from order_details od 
 
--16
select o.order_id, o.order_date, o.customer_id, 
lag(o.order_date) over(partition by o.customer_id order by o.order_id)
from orders o 

--17
select p.product_id, p.product_name, p.unit_price,
lag(p.unit_price) over (order by p.product_id asc ) as "precioAnterior",
p.unit_price - (lag(p.unit_price) over (order by p.product_id asc )) as "diferenciaPrecioAnterior"
from products p 

--18
select p.product_id, p.product_name, p.unit_price,
lead(p.unit_price) over (order by p.product_id asc )  
from products p 

--19
SELECT DISTINCT
  category_name,
  totalSales,
  LEAD(totalSales) OVER (ORDER BY category_name asc) AS nextTotalSales
FROM (
  select  distinct
    c.category_name,
    SUM(od.quantity * od.unit_price) OVER (PARTITION BY c.category_name) AS totalSales
  FROM order_details od 
  INNER JOIN products p ON p.product_id = od.product_id
  INNER JOIN categories c ON c.category_id = p.category_id
) t
ORDER BY category_name asc;

  