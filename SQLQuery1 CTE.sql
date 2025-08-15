WITH CTE_Total_Sales AS
(
SELECT
	CustomerID,
	SUM(Sales) AS Totalsales
FROM Sales.Orders
GROUP BY CustomerID
)

, CTE_Last_Order AS
(
SELECT
	CustomerID,
	MAX(OrderDate ) AS lastorder
FROM Sales.Orders
GROUP BY CustomerID
)

, CTE_Customer_Rank AS
(
SELECT
CustomerID,
TotalSales,
RANK () OVER(ORDER BY TotalSales DESC) AS CustomerRank
FROM CTE_Total_Sales 
)
, CTE_Customer_Segments AS
(
SELECT
CustomerID,
CASE WHEN TotalSales > 100 THEN 'High'
	 WHEN TotalSales > 50 THEN 'Medium'
	 ELSE 'LOW'
END CustomerSegments
FROM CTE_Total_Sales
)
SELECT
c.CustomerID,
c.FirstName,
c.LastName,
cts.TotalSales,
clo.lastorder,
ccr.CustomerRank,
ccs.CustomerSegments
FROM Sales.Customers c
LEFT JOIN CTE_Total_Sales cts
ON cts.CustomerID = c.CustomerID
LEFT JOIN CTE_Last_Order clo
ON clo.CustomerID = c.CustomerID 
LEFT JOIN CTE_Customer_Rank ccr
ON ccr.CustomerID = c.CustomerID
LEFT JOIN CTE_Customer_Segments ccs
ON ccs.CustomerID = c.CustomerID
