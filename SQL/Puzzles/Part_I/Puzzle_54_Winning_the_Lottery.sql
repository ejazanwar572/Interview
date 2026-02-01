-- Puzzle 54 - Winning the Lottery
--

-- You are part of an office lottery pool where you keep a table of the winning lottery numbers along with a table of each ticket’s chosen numbers. If a ticket has some but not all the winning numbers, you win $10. If a ticket has all the winning numbers, you win $100. Calculate the total winnings for today’s drawing.

-- **Winning Numbers**
/*
| Number |
|--------|
| 25     |
| 45     |
| 78     |
*/

-- **Tickets**
/*
| Ticket ID | Number |
|-----------|--------|
| AAA       | 25     |
| AAA       | 45     |
| AAA       | 78     |
| BBB       | 25     |
| BBB       | 45     |
| BBB       | 98     |
| CCC       | 67     |
| CCC       | 86     |
| CCC       | 91     |
*/

-- Here is the expected output.

/*
| Amount |
|--------|
| 110    |
*/


-- ==================================================
-- Solution for Puzzle 54
-- ==================================================

DROP TABLE IF EXISTS WinningNumbers;
DROP TABLE IF EXISTS LotteryTickets;

CREATE TABLE WinningNumbers
(
Number  INTEGER PRIMARY KEY
);

INSERT INTO WinningNumbers (Number) VALUES
(25),(45),(78);

CREATE TABLE LotteryTickets
(
TicketID  VARCHAR(3),
Number    INTEGER,
PRIMARY KEY (TicketID, Number)
);

INSERT INTO LotteryTickets (TicketID, Number) VALUES
('AAA',25),('AAA',45),('AAA',78),
('BBB',25),('BBB',45),('BBB',98),
('CCC',67),('CCC',86),('CCC',91);

WITH cte_Ticket AS
(
SELECT  TicketID,
        COUNT(*) AS MatchingNumbers
FROM    LotteryTickets a INNER JOIN
        WinningNumbers b ON a.Number = b.Number
GROUP BY TicketID
),
cte_Payout AS
(
SELECT  (CASE WHEN MatchingNumbers = (SELECT COUNT(*) FROM WinningNumbers) THEN 100 ELSE 10 END) AS Payout
FROM    cte_Ticket
)
SELECT  SUM(Payout) AS TotalPayout
FROM    cte_Payout;
