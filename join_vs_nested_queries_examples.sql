USE join_vs_nested_queries;

INSERT INTO customers (CustomerID, Name, Country) VALUES
(1, 'Alice', 'USA'),
(2, 'Bob', 'UK'),
(3, 'Charlie', 'USA');

INSERT INTO orders (OrderID, CustomerID, Amount) VALUES
(101, 1, 300),
(102, 2, 150),
(103, 1, 250);

SELECT * FROM customers;
SELECT * FROM orders;

select c.Name, o.OrderId, o.amount
from customers c
join orders o
on c.CustomerID=o.CustomerID;

-- Example 2: Get customers who placed at least one order
-- nested query 
select c.Name
from Customers c
where c.CustomerID in (select o.CustomerID from Orders o);

-- joined query 

select distinct c.Name
from Customers c
join orders o on c.CustomerId = o.CustomerId;

-- Example 3: Get customers with no orders
select name
from customers
where CustomerId not in (select CustomerId from orders);

-- we can query records on the right, even if 
-- the foreign key does not appear at all for
-- the corresponding record like o.CustomerId
-- but only for left join 
select c.name
from Customers c
left join Orders o
on c.CustomerId=o.CustomerId
where o.CustomerId is null;
-- without the left join it will not work at all
select c.name
from Customers c
join Orders o
on c.CustomerId=o.CustomerId
where o.CustomerId is null;

-- EXISTS vs JOIN

-- Goal 1: Find customers who have placed at least one order

select c.Name
from Customers c
where exists (
	select 1
    from Orders o
    where o.CustomerID = c.CustomerID
);

select distinct c.Name
from Customers c
join Orders o 
on c.CustomerID=o.CustomerID;

-- ✅ Goal 2: Find customers who have NO orders
-- Using NOT EXISTS (Recommended)
select c.name
from customers c
where not exists (
	select 1
    from Orders o
	where o.CustomerId = c.CustomerId
);

-- Using LEFT JOIN
select c.name
from Customers c
left join orders o
on c.CustomerID  = o.CustomerID
where o.CustomerID is null;

-- Goal 3: Check customers who spent more than 200
SELECT c.Name
FROM customers c
WHERE EXISTS (
    SELECT 1
    FROM orders o
    WHERE o.CustomerID = c.CustomerID
      AND o.Amount > 200
);

-- Using JOIN
select distinct c.name
from customers c
join orders o
on c.CustomerId=o.CustomerId
where o.Amount > 200;

-- 4.EXISTS vs IN 

select name 
from Customers
where CustomerID in (select CustomerID from Orders);

SELECT Name
FROM Customers c
WHERE EXISTS (
    SELECT 1 FROM Orders o
    WHERE o.CustomerID = c.CustomerID
);

-- 5.EXISTS vs JOIN 

-- using join
select distinct c.Name
from Customers c 
join orders o
on c.CustomerID = o.CustomerID;

-- using exists
select c.name
from Customers c
where exists (
	select 1
    from Orders o
    where o.CustomerID=c.CustomerID
);
