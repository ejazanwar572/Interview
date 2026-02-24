USE practice_sql_db;

### Practice Area

SELECT * FROM Candidates;

### DDL Commands

-------------------------------------------------------------------------
-- PRACTICE AREA: Medium Window Function Questions
-------------------------------------------------------------------------
/*
1. Rank Customers by Credit Limit (within Gender):
- Rank customers based on their credit_limit (highest first).
- Partition by gender.
- Show full_name, gender, credit_limit, and rank_val.
*/

SELECT
    candidate_id,
    skill,
    proficiency,
    rank() OVER (
        PARTITION BY
            skill
        ORDER BY proficiency DESC
    ) as rank_val
FROM candidates

/*
2. Running Total of Credit Limits:
- Calculate a running total of credit_limit ordered by join_date.
- Show full_name, join_date, credit_limit, and running_total.
*/

SELECT
    full_name,
    join_date,
    ROUND(credit_limit, 0) as credit_limit,
    ROUND(
        sum(credit_limit) over (
            order by join_date
        ),
        0
    ) as running_total
FROM customers

/*
3. Previous Customer's Credit Limit (Lag):
- For each customer, find the previous customer's credit_limit (ordered by join_date).
- Calculate the difference between current and previous credit_limit.
- Show full_name, join_date, current_credit, prev_credit, diff.
*/

SELECT

/*
4. Moving Average of Credit Limit (Rows Frame):
- Calculate the average credit_limit for the current customer and the 2 preceding customers (based on join_date order).
- Show full_name, join_date, credit_limit, moving_avg_credit.
*/

/*
Your Solution here
*/

/*
5. Next Customer's Join Date (Lead):
- Find the date when the *next* customer joins (ordered by join_date).
- Calculate the days difference between current and next join date.
- Show full_name, join_date, next_join_date, days_until_next.
*/

/*
Your Solution here
*/

-- Write your queries below this block:

-------------------------------------------------------------------------
-- DDL Commands (Do not edit below)
-------------------------------------------------------------------------
-- Clean up existing tables

DROP TABLE IF EXISTS customer_relationships;

DROP TABLE IF EXISTS customers;

-- Create customers table with more variety
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    full_name VARCHAR(255) NOT NULL,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    email_address VARCHAR(255),
    age INT,
    gender ENUM('M', 'F', 'Other'),
    join_date DATE,
    credit_limit DECIMAL(10, 2),
    is_active BOOLEAN DEFAULT TRUE
);

-- Insert larger dataset into customers (40 rows)
INSERT INTO
    customers (
        customer_id,
        full_name,
        first_name,
        last_name,
        email_address,
        age,
        gender,
        join_date,
        credit_limit,
        is_active
    )
VALUES (
        1,
        'Friends For Hire',
        NULL,
        NULL,
        'joe.trib@f4hire.com',
        NULL,
        'Other',
        '2020-01-15',
        50000.00,
        TRUE
    ),
    (
        2,
        'Rachel Green',
        'Rachel',
        'Green',
        'rachel.green@gmail.com',
        32,
        'F',
        '2021-03-10',
        15000.00,
        TRUE
    ),
    (
        3,
        'Monica Geller',
        'Monica',
        'Geller',
        'gellerm@gmail.com',
        34,
        'F',
        '2020-06-25',
        20000.50,
        TRUE
    ),
    (
        4,
        'Ross Geller',
        'Ross',
        'Geller',
        'ross.geller@nyu.edu',
        36,
        'M',
        '2019-11-05',
        18000.00,
        FALSE
    ),
    (
        5,
        'Joey Tribbiani',
        'Joey',
        'Tribbiani',
        'joe.tribbiani@gmail.com',
        33,
        'M',
        '2021-08-12',
        5000.00,
        TRUE
    ),
    (
        6,
        'Chandler Bing',
        'Chandler',
        'Bing',
        'c.bing@gmail.com',
        35,
        'M',
        '2020-02-14',
        25000.00,
        TRUE
    ),
    (
        7,
        'Phoebe Buffay',
        'Phoebe',
        'Buffay',
        'phoebe@smellycat.com',
        34,
        'F',
        '2021-01-01',
        8000.00,
        TRUE
    ),
    (
        8,
        'Fractal Factory',
        NULL,
        NULL,
        'billiam@fractal-factory.co.uk',
        NULL,
        'Other',
        '2018-05-20',
        100000.00,
        TRUE
    ),
    (
        9,
        'William Bloggs',
        'William',
        'Bloggs',
        NULL,
        45,
        'M',
        '2019-09-30',
        12000.00,
        FALSE
    ),
    (
        10,
        'Joe Bloggs',
        'Joe',
        'Bloggs',
        NULL,
        28,
        'M',
        '2022-04-18',
        6000.00,
        TRUE
    ),
    (
        11,
        'Some Company',
        NULL,
        NULL,
        'admin@somecompany.com',
        NULL,
        'Other',
        '2020-12-12',
        75000.00,
        TRUE
    ),
    (
        12,
        'Penny Lane',
        'Penny',
        'Lane',
        'pink.lotus@gmail.com',
        29,
        'F',
        '2021-11-22',
        11000.00,
        TRUE
    ),
    (
        13,
        'Leeroy Smythe',
        'Leeroy',
        'Smythe',
        'lee.the.boss@gmail.com',
        52,
        'M',
        '2017-07-07',
        45000.00,
        TRUE
    ),
    (
        14,
        'Alice Wonderland',
        'Alice',
        'Wonderland',
        'alice@wonder.land',
        25,
        'F',
        '2022-02-02',
        9500.00,
        TRUE
    ),
    (
        15,
        'Bob Builder',
        'Bob',
        'Builder',
        'bob@buildit.com',
        40,
        'M',
        '2020-05-05',
        15000.00,
        TRUE
    ),
    (
        16,
        'Charlie Chaplin',
        'Charlie',
        'Chaplin',
        'charlie@silent.movie',
        55,
        'M',
        '2018-12-25',
        30000.00,
        FALSE
    ),
    (
        17,
        'Diana Prince',
        'Diana',
        'Prince',
        'wonder.woman@jl.org',
        30,
        'F',
        '2021-06-01',
        50000.00,
        TRUE
    ),
    (
        18,
        'Evan Almighty',
        'Evan',
        'Baxter',
        'evan@ark.com',
        42,
        'M',
        '2019-04-01',
        20000.00,
        TRUE
    ),
    (
        19,
        'Frank Castle',
        'Frank',
        'Castle',
        'punisher@marvel.com',
        38,
        'M',
        '2020-10-31',
        10000.00,
        FALSE
    ),
    (
        20,
        'Grace Hopper',
        'Grace',
        'Hopper',
        'grace@navy.mil',
        60,
        'F',
        '2017-01-01',
        85000.00,
        TRUE
    ),
    (
        21,
        'Harry Potter',
        'Harry',
        'Potter',
        'harry@hogwarts.edu',
        22,
        'M',
        '2022-09-01',
        500.00,
        TRUE
    ),
    (
        22,
        'Iris West',
        'Iris',
        'West',
        'iris@centralcity.news',
        28,
        'F',
        '2021-08-15',
        12500.00,
        TRUE
    ),
    (
        23,
        'Jack Sparrow',
        'Jack',
        'Sparrow',
        'jack@blackpearl.sea',
        35,
        'M',
        '2019-03-15',
        2000.00,
        FALSE
    ),
    (
        24,
        'Katherine Johnson',
        'Katherine',
        'Johnson',
        'katherine@nasa.gov',
        58,
        'F',
        '2018-02-20',
        70000.00,
        TRUE
    ),
    (
        25,
        'Luke Skywalker',
        'Luke',
        'Skywalker',
        'luke@jedi.org',
        30,
        'M',
        '2020-05-04',
        5000.00,
        TRUE
    ),
    (
        26,
        'Mary Poppins',
        'Mary',
        'Poppins',
        'mary@poppins.com',
        38,
        'F',
        '2019-12-10',
        18000.00,
        TRUE
    ),
    (
        27,
        'Nancy Drew',
        'Nancy',
        'Drew',
        'nancy@detective.com',
        24,
        'F',
        '2022-01-20',
        8000.00,
        TRUE
    ),
    (
        28,
        'Oscar Wilde',
        'Oscar',
        'Wilde',
        'oscar@literature.co.uk',
        44,
        'M',
        '2018-11-30',
        25000.00,
        FALSE
    ),
    (
        29,
        'Peter Parker',
        'Peter',
        'Parker',
        'spidey@queens.ny',
        21,
        'M',
        '2022-06-10',
        1000.00,
        TRUE
    ),
    (
        30,
        'Quinn Fabray',
        'Quinn',
        'Fabray',
        'quinn@mckinley.edu',
        26,
        'F',
        '2021-09-05',
        11000.00,
        TRUE
    ),
    (
        31,
        'Robert Stark',
        'Robert',
        'Stark',
        'robb@winterfell.com',
        29,
        'M',
        '2020-03-03',
        40000.00,
        FALSE
    ),
    (
        32,
        'Sarah Connor',
        'Sarah',
        'Connor',
        'sarah@resistance.org',
        39,
        'F',
        '2019-08-29',
        15000.00,
        TRUE
    ),
    (
        33,
        'Tony Stark',
        'Tony',
        'Stark',
        'tony@stark.com',
        45,
        'M',
        '2016-05-02',
        1000000.00,
        TRUE
    ),
    (
        34,
        'Ursula LeGuin',
        'Ursula',
        'LeGuin',
        'ursula@earthsea.com',
        65,
        'F',
        '2017-04-22',
        55000.00,
        FALSE
    ),
    (
        35,
        'Victor Von Doom',
        'Victor',
        'Von Doom',
        'doom@latveria.gov',
        50,
        'M',
        '2018-07-20',
        500000.00,
        TRUE
    ),
    (
        36,
        'Wanda Maximoff',
        'Wanda',
        'Maximoff',
        'wanda@westview.nj',
        29,
        'F',
        '2021-02-28',
        22000.00,
        TRUE
    ),
    (
        37,
        'Xena Warrior',
        'Xena',
        'Warrior',
        'xena@amphipolis.gr',
        32,
        'F',
        '2019-09-04',
        14000.00,
        TRUE
    ),
    (
        38,
        'Yoda',
        'Yoda',
        NULL,
        'yoda@dagobah.sys',
        900,
        'M',
        '2015-01-01',
        0.00,
        FALSE
    ),
    (
        39,
        'Zelda Hyrule',
        'Zelda',
        'Hyrule',
        'zelda@hyrule.gov',
        23,
        'F',
        '2022-03-03',
        60000.00,
        TRUE
    ),
    (
        40,
        'Arthur Curry',
        'Arthur',
        'Curry',
        'arthur@atlantis.sea',
        36,
        'M',
        '2020-12-25',
        90000.00,
        TRUE
    );

-- Create customer_relationships table with more variety
CREATE TABLE customer_relationships (
    parent_customer_id INT,
    child_customer_id INT,
    relationship_type VARCHAR(255) NOT NULL,
    start_date DATE,
    is_active BOOLEAN DEFAULT TRUE,
    PRIMARY KEY (
        parent_customer_id,
        child_customer_id
    ),
    FOREIGN KEY (parent_customer_id) REFERENCES customers (customer_id),
    FOREIGN KEY (child_customer_id) REFERENCES customers (customer_id)
);

-- Insert relationships
INSERT INTO
    customer_relationships (
        parent_customer_id,
        child_customer_id,
        relationship_type,
        start_date,
        is_active
    )
VALUES (
        1,
        2,
        'Director',
        '2020-02-01',
        TRUE
    ),
    (
        1,
        3,
        'Shareholder',
        '2020-02-01',
        TRUE
    ),
    (
        1,
        4,
        'Shareholder',
        '2020-02-15',
        FALSE
    ),
    (
        1,
        5,
        'Director',
        '2020-03-01',
        TRUE
    ),
    (
        1,
        6,
        'Director',
        '2020-03-05',
        TRUE
    ),
    (
        1,
        7,
        'Director',
        '2020-04-01',
        TRUE
    ),
    (
        8,
        9,
        'Director',
        '2018-06-01',
        TRUE
    ),
    (
        8,
        10,
        'Director',
        '2018-06-15',
        TRUE
    ),
    (
        11,
        12,
        'Director',
        '2020-12-20',
        TRUE
    ),
    (
        11,
        13,
        'Director',
        '2021-01-10',
        TRUE
    ),
    (
        8,
        1,
        'Partner',
        '2021-05-01',
        TRUE
    ),
    (
        11,
        8,
        'Vendor',
        '2019-11-01',
        FALSE
    ),
    (
        33,
        29,
        'Mentor',
        '2022-07-01',
        TRUE
    ),
    (
        33,
        19,
        'Adversary',
        '2020-11-01',
        TRUE
    ),
    (
        17,
        40,
        'Ally',
        '2021-08-01',
        TRUE
    ),
    (
        20,
        24,
        'Colleague',
        '2017-05-01',
        TRUE
    ),
    (
        1,
        14,
        'Customer',
        '2022-03-01',
        TRUE
    ),
    (
        1,
        15,
        'Contractor',
        '2020-06-01',
        TRUE
    ),
    (
        35,
        16,
        'Investor',
        '2019-01-01',
        TRUE
    ),
    (
        22,
        21,
        'Friend',
        '2022-10-01',
        TRUE
    );