# HackerRank SQL Solutions Summary

Extracted from: [CuriosityLeonardo/All-Hackerrank-SQL-Solutions](https://github.com/CuriosityLeonardo/All-Hackerrank-SQL-Solutions)

### African Cities
```sql
SELECT
      c.NAME
FROM  CITY c
JOIN  COUNTRY co ON co.Code = c.CountryCode
WHERE CONTINENT = 'Africa'
```

### Average Population
```sql
SELECT 
        FLOOR(AVG(POPULATION))
FROM    CITY
```

### Average Population of Each Continent
```sql
SELECT
       CONTINENT,
       AVG(c.POPULATION)
FROM   CITY c
JOIN   Country co ON co.Code = c.CountryCode
GROUP BY CONTINENT
```

### Employee Names
```sql
SELECT
        name
FROM    Employee
ORDER BY name
```

### Employee Salaries
```sql
SELECT
      name
FROM  Employee
WHERE salary > 2000
AND months < 10
;
```

### Higher Than 75 Marks
```sql
SELECT
       Name
FROM   Students
WHERE Marks > 75
ORDER BY RIGHT(Name,3),
ID asc
```

### Japan Population
```sql
SELECT
      SUM(POPULATION)
FROM  CITY
WHERE COUNTRYCODE LIKE 'JPN'
```

### Population Census
```sql
SELECT
      SUM(c.POPULATION)
FROM  CITY c
JOIN  COUNTRY co ON co.Code = c.CountryCode
WHERE co.CONTINENT = 'Asia'
```

### Population Density Difference
```sql
SELECT
      MAX(POPULATION) - MIN(POPULATION)
FROM  CITY
```

### Print Prime Numbers
```sql
# Solution in MSSQL

CREATE TABLE Prime_Numbers (number INT);

DECLARE @nr INT;
DECLARE @divider INT;
DECLARE @prime BIT;

SELECT @nr = 1;


WHILE @nr <= 1000
    BEGIN
    SELECT @divider = @nr - 1;
    SELECT @prime = 1;
    -- Prime Number test
    WHILE @divider > 1
        BEGIN
        IF @nr % @divider = 0
            SELECT @prime = 0;
        SELECT @divider = @divider - 1         
        END
    IF @prime = 1 AND @nr <> 1
        INSERT INTO Prime_Numbers (number) VALUES (@nr);
    
    SELECT @nr = @nr + 1
    END

SELECT STRING_AGG(number,'&') FROM Prime_Numbers;
```

### Revising Aggregations - Averages
```sql
SELECT
      AVG(POPULATION)
FROM  CITY 
WHERE DISTRICT LIKE 'California'
```

### Revising Aggregations - The Count Function
```sql
SELECT
        COUNT(Name) as Count_City
FROM    CITY
WHERE   POPULATION > 100000
```

### Revising Aggregations - The Sum Function
```sql
SELECT
      SUM(POPULATION)
FROM  CITY
WHERE DISTRICT LIKE 'California'
```

### Symmetric Pairs
```sql
# Solution in MSSQL

WITH enumerate as (

SELECT
        X,
        Y,
        ROW_NUMBER() OVER(ORDER BY X,Y) as rn
FROM    Functions f

)
 
SELECT
        DISTINCT
        e.X,
        e.Y
FROM    enumerate e
-- first condition: X1 = Y2
JOIN    enumerate e2 ON e.X = e2.Y 
-- second condition: X2 = Y1
AND e2.X = e.Y
AND e.rn <> e2.rn
WHERE e.X <= e.Y
ORDER BY X,Y
```

### The Blunder
```sql
# Solution in MSSQL

WITH avg as (

SELECT 
        AVG(CAST(SALARY as DECIMAL(10,2))) as Salary, 
        AVG(CAST(REPLACE(SALARY,'0','') as DECIMAL(10,2))) as Salary_no_zeros 
FROM EMPLOYEES
    
)

SELECT CEILING(Salary - Salary_no_zeros) FROM avg;
```

### The PADS
```sql
SELECT
        Name + '(' + LEFT(Occupation,1) + ')' as Name_Profession
FROM    OCCUPATIONS
ORDER BY Name
;
SELECT
      'There are a total of ' + CAST(COUNT(Occupation) as VARCHAR(4)) + ' ' + LOWER(Occupation) + 's.' as Count
FROM OCCUPATIONS
GROUP BY Occupation
ORDER BY COUNT(Occupation), Occupation
;
```

### Top Earners
```sql
SELECT TOP(1)
      months * salary,
      COUNT(months * salary)
FROM  Employee
GROUP BY months * salary
ORDER BY months * salary desc
```

### Type of Triangle
```sql
SELECT
      CASE
          -- 3 same sides
          WHEN A = B AND B = C THEN 'Equilateral'
          -- 2 same sides, also check for being a triangle!
          WHEN (A = B OR B = C OR A = C) 
          AND A + B > C
          THEN 'Isosceles'
          -- chekc only for triangle
          WHEN A + B > C THEN 'Scalene'
          -- everything else not a triangle
          ELSE 'Not A Triangle'
      END AS 'Triangle'    
      --,A,B,C
FROM  TRIANGLES
```

### Weather Observation Station 10
```sql
SELECT 
        DISTINCT City
FROM    STATION
WHERE 
CITY NOT LIKE '%a'
AND CITY NOT LIKE '%e'
AND CITY NOT LIKE '%i'
AND CITY NOT LIKE '%o'
AND CITY NOT LIKE '%u'
```

### Weather Observation Station 11
```sql
SELECT 
      DISTINCT CITY
FROM  STATION
WHERE 

-- do not start with vowels
(
CITY NOT LIKE 'a%'
AND CITY NOT LIKE 'e%'
AND CITY NOT LIKE 'i%'
AND CITY NOT LIKE 'o%'
AND CITY NOT LIKE 'u%'
)
OR
-- do not end with vowels
(
CITY NOT LIKE '%a'
AND CITY NOT LIKE '%e'
AND CITY NOT LIKE '%i'
AND CITY NOT LIKE '%o'
AND CITY NOT LIKE '%u'
)
```

### Weather Observation Station 12
```sql
SELECT
      DISTINCT CITY
FROM  STATION

WHERE 
-- do not start with vowels
(
CITY NOT LIKE 'a%'
AND CITY NOT LIKE 'e%'
AND CITY NOT LIKE 'i%'
AND CITY NOT LIKE 'o%'
AND CITY NOT LIKE 'u%'
)
AND
-- do not end with vowels
(
CITY NOT LIKE '%a'
AND CITY NOT LIKE '%e'
AND CITY NOT LIKE '%i'
AND CITY NOT LIKE '%o'
AND CITY NOT LIKE '%u'
)
```

### Weather Observation Station 13
```sql
SELECT
      CAST(SUM(LAT_N) as DECIMAL(10,4)) as SUM
FROM  STATION
WHERE LAT_N > 38.788 AND LAT_N < 137.2345
```

### Weather Observation Station 14
```sql
SELECT
      CAST(MAX(LAT_N) as DECIMAL(10,4)) as SUM
FROM  STATION
WHERE LAT_N < 137.2345
```

### Weather Observation Station 15
```sql
WITH LAT_N_Largest as (

SELECT
      MAX(LAT_N) as MAXLAT_N
FROM  STATION
WHERE LAT_N < 137.2345
    
)

SELECT
       CAST(LONG_W as DECIMAL(10,4)) as LONG_W
FROM   STATION s
JOIN   LAT_N_Largest l ON l.MAXLAT_N = s.LAT_N
;
```

### Weather Observation Station 16
```sql
SELECT
      CAST(MIN(LAT_N) as DECIMAL(10,4)) as Minimum
FROM  STATION
WHERE LAT_N > 38.778
```

### Weather Observation Station 17
```sql
WITH small as (

SELECT
      MIN(LAT_N) as smallest
FROM  STATION
WHERE LAT_N > 38.778
)

SELECT
      CAST(LONG_W as DECIMAL(10,4)) as LONG_W
FROM  STATION st
JOIN  small s ON s.smallest = st.LAT_N
```

### Weather Observation Station 18
```sql
SELECT 
      CAST(abs(MAX(LAT_N) - MIN(LAT_N)) + abs(MAX(LONG_W) - MIN(LONG_W))
           as DECIMAL(10,4)) AS Manhattan_Distance
FROM  STATION
```

### Weather Observation Station 19
```sql
SELECT
      CAST(SQRT(SQUARE(MAX(LAT_N) - MIN(LAT_N)) + SQUARE(MAX(LONG_W) - MIN(LONG_W)))
           AS DECIMAL(10,4)) AS Euclidean_Distance
FROM  STATION
```

### Weather Observation Station 2
```sql
SELECT
      CAST(CAST(SUM(LAT_N) as DECIMAL(10,2)) as VARCHAR) + ' ' + CAST(CAST(SUM(LONG_W) as DECIMAL(10,2)) as VARCHAR)
FROM  STATION
;
```

### Weather Observation Station 7
```sql
SELECT
        DISTINCT CITY
FROM    STATION
WHERE   CITY LIKE '%a'
OR CITY LIKE '%e'
OR CITY LIKE '%i'
OR CITY LIKE '%o'
OR CITY LIKE '%u'
```

### Weather Observation Station 8
```sql
SELECT
      DISTINCT CITY
FROM  STATION
WHERE 

-- starting with a vowel
(CITY LIKE 'a%' 
OR CITY LIKE 'e%'
OR CITY LIKE 'i%'
OR CITY LIKE 'o%'
OR CITY LIKE 'u%')
AND
-- ending with a vowel
(CITY LIKE '%a' 
OR CITY LIKE '%e'
OR CITY LIKE '%i'
OR CITY LIKE '%o'
OR CITY LIKE '%u')
```

### Weather Observation Station 9
```sql
SELECT 
      DISTINCT CITY
FROM  STATION
WHERE 
(
CITY NOT LIKE 'a%'
AND CITY NOT LIKE 'e%'
AND CITY NOT LIKE 'i%'
AND CITY NOT LIKE 'o%'
AND CITY NOT LIKE 'u%'
)
```

