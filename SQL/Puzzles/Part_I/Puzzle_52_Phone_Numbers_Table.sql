-- Puzzle 52 - Phone Numbers Table
--

-- You are creating a table that customer agents will use to enter customer phone numbers.

-- Create a table with the columns `Customer ID` and `Phone Number`, where the `Phone Number` column must be formatted as (999)-999-9999.

-- Agents will enter phone numbers into this table via a form, and it is imperative that phone numbers are formatted correctly when inputted. Create a table that meets these requirements.

-- Here are a few sample records.

/*
| Customer ID |  Phone Number  |
|-------------|----------------|
| 1001        | (555)-555-5555 |
| 2002        | (555)-555-5555 |
| 3003        | (555)-555-5555 |
*/


-- ==================================================
-- Solution for Puzzle 52
-- ==================================================

DROP TABLE IF EXISTS CustomerInfo;

CREATE TABLE CustomerInfo
(
CustomerID   INTEGER PRIMARY KEY,
PhoneNumber  VARCHAR(14) NOT NULL,
CONSTRAINT ckPhoneNumber CHECK (LENGTH(PhoneNumber) = 14
                            AND SUBSTRING(PhoneNumber,1,1)= '('
                            AND SUBSTRING(PhoneNumber,5,1)= ')'
                            AND SUBSTRING(PhoneNumber,6,1)= '-'
                            AND SUBSTRING(PhoneNumber,10,1)= '-')
);

INSERT INTO CustomerInfo (CustomerID, PhoneNumber) VALUES
(1001,'(555)-555-5555'),(2002,'(555)-555-5555'), (3003,'(555)-555-5555');

SELECT  CustomerID, PhoneNumber
FROM    CustomerInfo;
