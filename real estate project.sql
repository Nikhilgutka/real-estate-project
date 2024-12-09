SELECT * FROM realestate.data2020;
show columns from data2020;
SELECT 
    `Town`, 
    AVG(`Sales Ratio`) AS `Average Sales Ratio`
FROM 
    realestate.data2015
GROUP BY 
    `Town`
HAVING 
    `Average Sales Ratio` > (SELECT AVG(`Sales Ratio`) + 3 * STDDEV(`Sales Ratio`) FROM realestate.data2015)
    OR
    `Average Sales Ratio` < (SELECT AVG(`Sales Ratio`) - 3 * STDDEV(`Sales Ratio`) FROM realestate.data2015);
show columns from data2020;
SELECT '2015' AS Year, SUM(`Sale Amount`) AS Total_Sales, AVG(`Sale Amount`) AS Average_Sales FROM data2015
UNION ALL
SELECT '2016', SUM(`Sale Amount`), AVG(`Sale Amount`) FROM data2016
UNION ALL
SELECT '2017', SUM(`Sale Amount`), AVG(`Sale Amount`) from data2017
UNION ALL
SELECT '2018', SUM(`Sale Amount`), AVG(`Sale Amount`) FROM data2018
UNION ALL
SELECT '2019', SUM(`Sale Amount`), AVG(`Sale Amount`) FROM data2019
UNION ALL
SELECT '2020', SUM(`Sale Amount`), AVG(`Sale Amount`) FROM data2020;

SELECT '2015' AS Year, AVG(`Assessed Value`) AS Avg_Assessed_Value FROM data2015 WHERE `Property Type` = 'Nan'
UNION ALL
SELECT '2016', AVG(`Assessed Value`) FROM data2016 WHERE `Property Type` = 'Nan'
UNION ALL
SELECT '2017', AVG(`Assessed Value`) FROM data2017 WHERE `Property Type` = 'Nan'
UNION ALL
SELECT '2018', AVG(`Assessed Value`) FROM data2018 WHERE `Property Type` = 'Nan'
UNION ALL
SELECT '2019', AVG(`Assessed Value`) FROM data2019 WHERE `Property Type` = 'Nan'
UNION ALL
SELECT '2020', AVG(`Assessed Value`) FROM data2020 WHERE `Property Type` = 'Nan';
SELECT '2015' AS Year, AVG(`Assessed Value`) AS Avg_Assessed_Value FROM data2015 WHERE `Property Type` = 'Single Family'
UNION ALL
SELECT '2016', AVG(`Assessed Value`) FROM data2016 WHERE `Property Type` = 'Single Family'
UNION ALL
SELECT '2017', AVG(`Assessed Value`) FROM data2017 WHERE `Property Type` = 'Single Family'
UNION ALL
SELECT '2018', AVG(`Assessed Value`) FROM data2018 WHERE `Property Type` = 'Single Family'
UNION ALL
SELECT '2019', AVG(`Assessed Value`) FROM data2019 WHERE `Property Type` = 'Single Family'
UNION ALL
SELECT '2020', AVG(`Assessed Value`) FROM data2020 WHERE `Property Type` = 'Single Family';
WITH Top_Towns AS (
    SELECT `Town` 
    FROM (
        SELECT `Town`, AVG(`Assessed Value`) AS Avg_Assessed_Value 
        FROM data2020 
        GROUP BY `Town` 
        ORDER BY Avg_Assessed_Value DESC 
        LIMIT 5
    ) AS Top_Towns
)
SELECT '2020' AS Year, `Town`, AVG(`Sales Ratio`) AS Avg_Sales_Ratio FROM data2020 WHERE `Town` IN (SELECT `Town` FROM Top_Towns) GROUP BY `Town`
UNION ALL
SELECT '2019', `Town`, AVG(`Sales Ratio`) FROM data2019 WHERE `Town` IN (SELECT `Town` FROM Top_Towns) GROUP BY `Town`
UNION ALL
SELECT '2018', `Town`, AVG(`Sales Ratio`) FROM data2018 WHERE `Town` IN (SELECT `Town` FROM Top_Towns) GROUP BY `Town`
UNION ALL
SELECT '2017', `Town`, AVG(`Sales Ratio`) FROM data2017 WHERE `Town` IN (SELECT `Town` FROM Top_Towns) GROUP BY `Town`
UNION ALL
SELECT '2016', `Town`, AVG(`Sales Ratio`) FROM data2016 WHERE `Town` IN (SELECT `Town` FROM Top_Towns) GROUP BY `Town`
UNION ALL
SELECT '2015', `Town`, AVG(`Sales Ratio`) FROM data2015 WHERE `Town` IN (SELECT `Town` FROM Top_Towns) GROUP BY `Town`;
WITH Yearly_Sales AS (
    SELECT '2015' AS Year, Town, SUM(`Sale Amount`) AS Total_Sales 
    FROM data2015 
    GROUP BY Town
    UNION ALL
    SELECT '2020', Town, SUM(`Sale Amount`) 
    FROM data2020 
    GROUP BY Town
),
Sales_Comparison AS (
    SELECT 
        r1.Town,
        r1.Total_Sales AS Sales_2015,
        r2.Total_Sales AS Sales_2020,
        (r2.Total_Sales - r1.Total_Sales) / r1.Total_Sales AS Sales_Increase
    FROM Yearly_Sales r1
    JOIN Yearly_Sales r2 ON r1.Town = r2.Town AND r1.Year = '2015' AND r2.Year = '2020'
)
SELECT Town, Sales_2015, Sales_2020, Sales_Increase
FROM Sales_Comparison
ORDER BY Sales_Increase DESC
limit 5;
SELECT '2015' AS Year, Town, COUNT(*) AS Total_Listed 
FROM data2015 GROUP BY Town
UNION ALL
SELECT '2016', Town, COUNT(*) FROM data2016 GROUP BY Town
UNION ALL
SELECT '2017', Town, COUNT(*) FROM data2017 GROUP BY Town
UNION ALL
SELECT '2018', Town, COUNT(*) FROM data2018 GROUP BY Town
UNION ALL
SELECT '2019', Town, COUNT(*) FROM data2019 GROUP BY Town
UNION ALL
SELECT '2020', Town, COUNT(*) FROM data2020 GROUP BY Town;
WITH Yearly_Listing AS (
    SELECT '2015' AS Year, Town, COUNT(*) AS Total_Listed FROM data2015 GROUP BY Town
    UNION ALL
    SELECT '2016', Town, COUNT(*) FROM data2016 GROUP BY Town
    UNION ALL
    SELECT '2017', Town, COUNT(*) FROM data2017 GROUP BY Town
    UNION ALL
    SELECT '2018', Town, COUNT(*) FROM data2018 GROUP BY Town
    UNION ALL
    SELECT '2019', Town, COUNT(*) FROM data2019 GROUP BY Town
    UNION ALL
    SELECT '2020', Town, COUNT(*) FROM data2020 GROUP BY Town
),
Ranked_Listing AS (
    SELECT 
        Year, 
        Town, 
        Total_Listed,
        RANK() OVER (PARTITION BY Year ORDER BY Total_Listed DESC) AS top
    FROM Yearly_Listing
)
SELECT Year, Town, Total_Listed
FROM Ranked_Listing
WHERE top <= 5
ORDER BY Year, top;
SELECT '2015' AS Year, `Property_Type`, AVG(`Sales_Ratio`) AS Avg_Sales_Ratio 
FROM data2015 GROUP BY `Property_Type`
UNION ALL
SELECT '2016', `Property_Type`, AVG(`Sales_Ratio`) FROM data2016 GROUP BY `Property_Type`
UNION ALL
SELECT '2017', `Property_Type`, AVG(`Sales_Ratio`) FROM data2017 GROUP BY `Property_Type`
UNION ALL
SELECT '2018', `Property_Type`, AVG(`Sales_Ratio`) FROM data2018 GROUP BY `Property_Type`
UNION ALL
SELECT '2019', `Property_Type`, AVG(`Sales_Ratio`) FROM data2019 GROUP BY `Property_Type`
UNION ALL
SELECT '2020', `Property_Type`, AVG(`Sales_Ratio`) FROM data2020 GROUP BY `Property_Type`;
WITH Yearly_Property_Type_Sales AS (
    SELECT '2015' AS Year, `Property Type`, COUNT(*) AS Total_Sold 
    FROM data2015 GROUP BY `Property Type`
    UNION ALL
    SELECT '2016', `Property Type`, COUNT(*) FROM data2016 GROUP BY `Property Type`
    UNION ALL
    SELECT '2017', `Property Type`, COUNT(*) FROM data2017 GROUP BY `Property Type`
    UNION ALL
    SELECT '2018', `Property Type`, COUNT(*) FROM data2018 GROUP BY `Property Type`
    UNION ALL
    SELECT '2019', `Property Type`, COUNT(*) FROM data2019 GROUP BY `Property Type`
    UNION ALL
    SELECT '2020', `Property Type`, COUNT(*) FROM data2020 GROUP BY `Property Type`
),
Ranked_Property_Type_Sales AS (
    SELECT 
        Year, 
        `Property Type`, 
        Total_Sold,
        RANK() OVER (PARTITION BY Year ORDER BY Total_Sold DESC) AS top
    FROM Yearly_Property_Type_Sales
)
SELECT Year, `Property Type`, Total_Sold
FROM Ranked_Property_Type_Sales
WHERE top = 1
ORDER BY Year;
SELECT Year, Town, `Sales Ratio`
FROM (
    SELECT '2015' AS Year, Town, `Sales Ratio`, AVG(`Sales Ratio`) OVER () AS Avg_Sales_Ratio, STDDEV(`Sales Ratio`) OVER () AS StdDev_Sales_Ratio 
    FROM data2015
    UNION ALL
    SELECT '2020', Town, `Sales Ratio`, AVG(`Sales Ratio`) OVER (), STDDEV(`Sales Ratio`) OVER () 
    FROM data2020
) AS Combined
WHERE ABS(`Sales Ratio` - Avg_Sales_Ratio) > 2 * StdDev_Sales_Ratio;
SELECT 
    Town, 
    POWER(
        (SUM(CASE WHEN List_Year = 2020 THEN Sale_Amount ELSE 0 END) / 
         NULLIF(SUM(CASE WHEN List_Year = 2015 THEN Sale_Amount ELSE 0 END), 0)), 
        1.0 / 5
    ) - 1 AS CAGR
FROM (
    SELECT Town, List_Year, Sale_Amount FROM data2015
    UNION ALL
    SELECT Town, List_Year, Sale_Amount FROM data2016
    UNION ALL
    SELECT Town, List_Year, Sale_Amount FROM data2017
    UNION ALL
    SELECT Town, List_Year, Sale_Amount FROM data2018
    UNION ALL
    SELECT Town, List_Year, Sale_Amount FROM data2019
    UNION ALL
    SELECT Town, List_Year, Sale_Amount FROM data2020
) AS realestate
GROUP BY Town;
SELECT 
    Town, 
    SUM(Sale_Amount) AS Total_Sales
FROM (
    SELECT Town, Sale_Amount FROM data2015
    UNION ALL
    SELECT Town, Sale_Amount FROM data2016
    UNION ALL
    SELECT Town, Sale_Amount FROM data2017
    UNION ALL
    SELECT Town, Sale_Amount FROM data2018
    UNION ALL
    SELECT Town, Sale_Amount FROM data2019
    UNION ALL
    SELECT Town, Sale_Amount FROM data2020
) AS realestate
GROUP BY Town
ORDER BY Total_Sales DESC;
SELECT 
    Town, 
    AVG(Sale_Amount) AS Average_Sale_Amount, 
    ((SUM(CASE WHEN List_Year = 2020 THEN Sale_Amount ELSE 0 END) / 
     NULLIF(SUM(CASE WHEN List_Year = 2019 THEN Sale_Amount ELSE 0 END), 0)) - 1) AS Growth_Rate_2019_2020,
    SUM(CASE WHEN List_Year = 2020 THEN Sale_Amount ELSE 0 END) * 
    ((SUM(CASE WHEN List_Year = 2020 THEN Sale_Amount ELSE 0 END) / 
      NULLIF(SUM(CASE WHEN List_Year = 2019 THEN Sale_Amount ELSE 0 END), 0)) - 1) 
    AS Predicted_Sale_Amount_2021
FROM (
    SELECT Town, List_Year, Sale_Amount FROM data2015
    UNION ALL
    SELECT Town, List_Year, Sale_Amount FROM data2016
    UNION ALL
    SELECT Town, List_Year, Sale_Amount FROM data2017
    UNION ALL
    SELECT Town, List_Year, Sale_Amount FROM data2018
    UNION ALL
    SELECT Town, List_Year, Sale_Amount FROM data2019
    UNION ALL
    SELECT Town, List_Year, Sale_Amount FROM data2020
) AS realestate
GROUP BY Town;
SELECT 
    Town, 
    AVG(Sales_Ratio) AS Avg_Sales_Ratio,
    ((SUM(CASE WHEN List_Year = 2020 THEN Sales_Ratio ELSE 0 END) / 
     NULLIF(SUM(CASE WHEN List_Year = 2019 THEN Sales_Ratio ELSE 0 END), 0)) - 1) AS Sales_Ratio_Growth_2019_2020,
    SUM(CASE WHEN List_Year = 2020 THEN Sales_Ratio ELSE 0 END) * 
    ((SUM(CASE WHEN List_Year = 2020 THEN Sales_Ratio ELSE 0 END) / 
      NULLIF(SUM(CASE WHEN List_Year = 2019 THEN Sales_Ratio ELSE 0 END), 0)) - 1) 
    AS Predicted_Sales_Ratio_2021
FROM (
    SELECT Town, List_Year, Sales_Ratio FROM data2015
    UNION ALL
    SELECT Town, List_Year, Sales_Ratio FROM data2016
    UNION ALL
    SELECT Town, List_Year, Sales_Ratio FROM data2017
    UNION ALL
    SELECT Town, List_Year, Sales_Ratio FROM data2018
    UNION ALL
    SELECT Town, List_Year, Sales_Ratio FROM data2019
    UNION ALL
    SELECT Town, List_Year, Sales_Ratio FROM data2020
) AS realestate
GROUP BY Town;
SELECT 
    t.Town,
    SUM(CASE WHEN r.List_Year = 2020 THEN r.Sale_Amount ELSE 0 END) AS Total_Sales_2020,
    SUM(CASE WHEN r.List_Year = 2019 THEN r.Sale_Amount ELSE 0 END) AS Total_Sales_2019,
    ((SUM(CASE WHEN r.List_Year = 2020 THEN r.Sale_Amount ELSE 0 END) / 
     NULLIF(SUM(CASE WHEN r.List_Year = 2019 THEN r.Sale_Amount ELSE 0 END), 0)) - 1) AS Growth_Rate_2019_2020,
    SUM(CASE WHEN r.List_Year = 2020 THEN r.Sale_Amount ELSE 0 END) * 
    ((SUM(CASE WHEN r.List_Year = 2020 THEN r.Sale_Amount ELSE 0 END) / 
      NULLIF(SUM(CASE WHEN r.List_Year = 2019 THEN r.Sale_Amount ELSE 0 END), 0)) - 1) AS Predicted_Sales_2021
FROM (
    SELECT Town FROM data2015
    UNION ALL
    SELECT Town FROM data2016
    UNION ALL
    SELECT Town FROM data2017
    UNION ALL
    SELECT Town FROM data2018
    UNION ALL
    SELECT Town FROM data2019
    UNION ALL
    SELECT Town FROM data2020
) AS t
JOIN data2015 r ON t.Town = r.Town
JOIN data2016 r2 ON t.Town = r2.Town
JOIN data2017 r3 ON t.Town = r3.Town
JOIN data2018 r4 ON t.Town = r4.Town
JOIN data2019 r5 ON t.Town = r5.Town
JOIN data2020 r6 ON t.Town = r6.Town
GROUP BY t.Town;
SELECT 
    t.Town, 
    AVG(r.Sales_Ratio) AS Avg_Sales_Ratio
FROM (
    SELECT Town FROM data2015
    UNION ALL
    SELECT Town FROM data2016
    UNION ALL
    SELECT Town FROM data2017
    UNION ALL
    SELECT Town FROM data2018
    UNION ALL
    SELECT Town FROM data2019
    UNION ALL
    SELECT Town FROM data2020
) AS t
JOIN data2015 r ON t.Town = r.Town
JOIN data2016 r2 ON t.Town = r2.Town
JOIN data2017 r3 ON t.Town = r3.Town
JOIN data2018 r4 ON t.Town = r4.Town
JOIN data2019 r5 ON t.Town = r5.Town
JOIN data2020 r6 ON t.Town = r6.Town
GROUP BY t.Town
ORDER BY Avg_Sales_Ratio DESC
LIMIT 1;
SELECT 
    '2015' AS Year,
    MIN(Sale_Amount) AS Min_Sale_Amount,
    MAX(Sale_Amount) AS Max_Sale_Amount
FROM data2015
UNION ALL
SELECT 
    '2016',
    MIN(Sale_Amount),
    MAX(Sale_Amount)
FROM data2016
UNION ALL
SELECT 
    '2017',
    MIN(Sale_Amount),
    MAX(Sale_Amount)
FROM data2017
UNION ALL
SELECT 
    '2018',
    MIN(Sale_Amount),
    MAX(Sale_Amount)
FROM data2018
UNION ALL
SELECT 
    '2019',
    MIN(Sale_Amount),
    MAX(Sale_Amount)
FROM data2019
UNION ALL
SELECT 
    '2020',
    MIN(Sale_Amount),
    MAX(Sale_Amount)
FROM data2020;
SELECT 
    Property_Type,
    MIN(Assessed_Value) AS Min_Assessed_Value,
    MAX(Assessed_Value) AS Max_Assessed_Value
FROM data2020
GROUP BY Property_Type;
SELECT 
    Town,
    MIN(Sale_Amount) AS Min_Sale_Amount,
    MAX(Sale_Amount) AS Max_Sale_Amount
FROM (
    SELECT Town, Sale_Amount FROM data2015
    UNION ALL
    SELECT Town, Sale_Amount FROM data2016
    UNION ALL
    SELECT Town, Sale_Amount FROM data2017
    UNION ALL
    SELECT Town, Sale_Amount FROM data2018
    UNION ALL
    SELECT Town, Sale_Amount FROM data2019
    UNION ALL
    SELECT Town, Sale_Amount FROM data2020
) AS combined_data
GROUP BY Town;
SELECT 
    '2015' AS Year,
    Address,
    Property_Type,
    Sales_Ratio
FROM data2015
WHERE Sales_Ratio = (SELECT MAX(Sales_Ratio) FROM data2015)
UNION ALL
SELECT 
    '2016',
    Address,
    Property_Type,
    Sales_Ratio
FROM data2016
WHERE Sales_Ratio = (SELECT MAX(Sales_Ratio) FROM data2016)
UNION ALL
SELECT 
    '2017',
    Address,
    Property_Type,
    Sales_Ratio
FROM data2017
WHERE Sales_Ratio = (SELECT MAX(Sales_Ratio) FROM data2017)
UNION ALL
SELECT 
    '2018',
    Address,
    Property_Type,
    Sales_Ratio
FROM data2018
WHERE Sales_Ratio = (SELECT MAX(Sales_Ratio) FROM data2018)
UNION ALL
SELECT 
    '2019',
    Address,
    Property_Type,
    Sales_Ratio
FROM data2019
WHERE Sales_Ratio = (SELECT MAX(Sales_Ratio) FROM data2019)
UNION ALL
SELECT 
    '2020',
    Address,
    Property_Type,
    Sales_Ratio
FROM data2020
WHERE Sales_Ratio = (SELECT MAX(Sales_Ratio) FROM data2020);
SELECT 
    Property_Type,
    MIN(Years_until_sold) AS Min_Years_Until_Sold,
    MAX(Years_until_sold) AS Max_Years_Until_Sold
FROM data2020
GROUP BY Property_Type;



















