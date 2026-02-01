-- Puzzle 3 - Fiscal Year Table Constraints
--

-- For each standard fiscal year, a record exists for each employee stating their current pay rate for that year.  

-- Can you determine all the constraints that can be applied to this table to ensure it contains only correct information? Assume that no pay raises are given mid-year. There are quite a few of them, so think carefully.  

CREATE TABLE EmployeePayRecord
(
    EmployeeID  INTEGER,
    FiscalYear  INTEGER,
    StartDate   DATE,
    EndDate     DATE,
    PayRate     MONEY
);


-- Solution
-- Solution for Puzzle 3: Fiscal Year Table Constraints
ALTER TABLE EmployeePayRecord
ADD CONSTRAINT PK_EmployeePayRecord PRIMARY KEY (EmployeeID, FiscalYear);

ALTER TABLE EmployeePayRecord
ADD CONSTRAINT CK_Dates CHECK (EndDate >= StartDate);

ALTER TABLE EmployeePayRecord
ADD CONSTRAINT CK_PayRate CHECK (PayRate > 0);


-- ==================================================
-- Solution for Puzzle 3
-- ==================================================

DROP TABLE IF EXISTS EmployeePayRecords;

CREATE TABLE EmployeePayRecords
(
EmployeeID  INTEGER,
FiscalYear  INTEGER,
StartDate   DATE,
EndDate     DATE,
PayRate     MONEY
);

--NOT NULL
ALTER TABLE EmployeePayRecords ALTER COLUMN EmployeeID INTEGER NOT NULL;
ALTER TABLE EmployeePayRecords ALTER COLUMN FiscalYear INTEGER NOT NULL;
ALTER TABLE EmployeePayRecords ALTER COLUMN StartDate DATE NOT NULL;
ALTER TABLE EmployeePayRecords ALTER COLUMN EndDate DATE NOT NULL;
ALTER TABLE EmployeePayRecords ALTER COLUMN PayRate MONEY NOT NULL;
--PRIMARY KEY
ALTER TABLE EmployeePayRecords ADD CONSTRAINT PK_FiscalYearCalendar
                                    PRIMARY KEY (EmployeeID,FiscalYear);
--CHECK CONSTRAINTS
ALTER TABLE EmployeePayRecords ADD CONSTRAINT Check_Year_StartDate
                                    CHECK (FiscalYear = DATEPART(YYYY,StartDate));
ALTER TABLE EmployeePayRecords ADD CONSTRAINT Check_Month_StartDate 
                                    CHECK (DATEPART(MM,StartDate) = 01);
ALTER TABLE EmployeePayRecords ADD CONSTRAINT Check_Day_StartDate 
                                    CHECK (DATEPART(DD,StartDate) = 01);
ALTER TABLE EmployeePayRecords ADD CONSTRAINT Check_Year_EndDate
                                    CHECK (FiscalYear = DATEPART(YYYY,EndDate));
ALTER TABLE EmployeePayRecords ADD CONSTRAINT Check_Month_EndDate 
                                    CHECK (DATEPART(MM,EndDate) = 12);
ALTER TABLE EmployeePayRecords ADD CONSTRAINT Check_Day_EndDate 
                                    CHECK (DATEPART(DD,EndDate) = 31);
ALTER TABLE EmployeePayRecords ADD CONSTRAINT Check_Payrate
                                    CHECK (PayRate > 0);
