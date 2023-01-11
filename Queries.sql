use northwind;
SELECT * FROM customers;
SELECT * FROM orders;
SELECT * FROM order_details;
SELECT * FROM employees;

-- 1. Calculate average Unit Price for each CustomerId.
SELECT 
o.CustomerID, od.unitprice, AVG(od.UnitPrice) OVER (PARTITION BY o.CustomerID) AS avg_price 
FROM orders o INNER JOIN order_details od 
ON o.orderID=od.orderID ;

-- 2. Calculate average Unit Price for each group of CustomerId AND EmployeeId.
SELECT 
o.CustomerID, od.unitprice, o.EmployeeID ,AVG(od.UnitPrice) OVER (PARTITION BY o.CustomerID, o.EmployeeID) AS avg_price 
FROM orders o INNER JOIN order_details od 
ON o.orderID=od.orderID ;

-- 3. Rank Unit Price in DESCending order for each CustomerId.
SELECT o.CustomerID, od.unitprice,
RANK() OVER (PARTITION BY CustomerID order BY od.unitprice DESC) AS ranking 
FROM orders o INNER JOIN order_details od 
ON o.orderID=od.orderID ;

-- 4. How can you pull the previous order date’s Quantity for each ProductId.
SELECT od.ProductId, o.orderDate, od.Quantity, 
LAG(o.orderDate) OVER (PARTITION BY od.ProductId order BY o.orderDate) AS prev_date,
LAG(od.Quantity) OVER (PARTITION BY od.ProductId order BY o.orderDate) AS prev_qty
FROM orders o INNER JOIN order_details od ON o.orderID=od.orderID ;

-- 5. How can you pull the following order date’s Quantity for each ProductId.
SELECT od.ProductId, o.orderDate, od.Quantity, 
LEAD(o.orderDate) OVER (PARTITION BY od.ProductId  order BY o.orderDate) AS foll_date,
LEAD(od.Quantity) OVER (PARTITION BY od.ProductId  order BY o.orderDate) AS foll_qty
FROM orders o INNER JOIN order_details od ON o.orderID=od.orderID ;

-- 6. Pull out the very first Quantity ever ordered for each ProductId.
SELECT od.ProductId, o.orderDate,
first_value(od.Quantity) OVER (PARTITION BY od.ProductId order BY o.orderID) AS first_qty
FROM orders o INNER JOIN order_details od ON o.orderID=od.orderID group BY od.ProductID;

-- 7. Calculate a cumulative moving average UnitPrice for each CustomerId.
SELECT o.CustomerID, od.unitprice, AVG(od.UnitPrice)
OVER (PARTITION BY o.CustomerID rows between unbounded preceding and current row) AS cum_avg_price 
FROM orders o INNER JOIN order_details od ON o.orderID=od.orderID ;


