-- Puzzle 46 - Negative Account Balances
--

-- How many different SQL statements can you write to determine all accounts whose balance has never been positive?

/*
| Account ID | Balance |
|------------|---------|
| 1001       | 234.45  |
| 1001       | -23.12  |
| 2002       | -93.01  |
| 2002       | -120.19 |
| 3003       | 186.76  |
| 3003       | 90.23   |
| 3003       | 10.11   |
*/

-- Here is the expected output.

/*
| Account ID |
|------------|
| 2002       |
*/

-- - `Account ID` `2002` would appear in the result set, as this account has never had a positive balance.
-- - There are a multitude of ways to write this statement. Can you think of them all?


-- ==================================================
-- Solution for Puzzle 46
-- ==================================================

DROP TABLE IF EXISTS AccountBalances;

CREATE TABLE AccountBalances
(
AccountID  INTEGER,
Balance    MONEY,
PRIMARY KEY (AccountID, Balance)
);

INSERT INTO AccountBalances (AccountID, Balance) VALUES
(1001,234.45),(1001,-23.12),(2002,-93.01),(2002,-120.19),
(3003,186.76), (3003,90.23), (3003,10.11);

--Solution 1
--SET Operators
SELECT DISTINCT AccountID FROM AccountBalances WHERE Balance < 0
EXCEPT
SELECT DISTINCT AccountID FROM AccountBalances WHERE Balance > 0;

--Solution 2
--MAX
SELECT  AccountID
FROM    AccountBalances
GROUP BY AccountID
HAVING  MAX(Balance) < 0;

--Solution 3
--NOT IN
SELECT  DISTINCT AccountID
FROM    AccountBalances
WHERE   AccountID NOT IN (SELECT AccountID FROM AccountBalances WHERE Balance > 0);

--Solution 4
--NOT EXISTS with Correlated Subquery
SELECT  DISTINCT AccountID
FROM    AccountBalances a
WHERE   NOT EXISTS (SELECT AccountID FROM AccountBalances b WHERE Balance > 0 AND a.AccountID = b.AccountID);

--Solution 5
--LEFT OUTER JOIN
SELECT  DISTINCT a.AccountID
FROM    AccountBalances a LEFT OUTER JOIN
        AccountBalances b ON a.AccountID = b.AccountID AND b.Balance > 0
WHERE   b.AccountID IS NULL;
