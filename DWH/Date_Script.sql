
DECLARE @StartDate DATE = '2016-01-01';
DECLARE @EndDate DATE = '2018-12-31';

WHILE @StartDate <= @EndDate
BEGIN
    INSERT INTO [dbo].[DimDate] (
        [DateKey],
        [Date],
        [FullDate],
        [DayOfMonth],
        [DayName],
        [DayOfWeek],
        [DayOfYear],
        [WeekOfYear],
        [Month],
        [MonthName],
        [Quarter],
        [QuarterName],
        [Year],
        [IsWeekend]
    )
    SELECT
        -- The date key in YYYYMMDD format
        CONVERT(INT, CONVERT(VARCHAR(8), @StartDate, 112)),
        -- The full date
        @StartDate,
        -- The date in DD-MM-YYYY format
        FORMAT(@StartDate, 'dd-MM-yyyy'),
        -- Day of the month
        DAY(@StartDate),
        -- Day name in English
        DATENAME(weekday, @StartDate),
        -- Day of the week number (1=Sunday, 2=Monday, ...)
        DATEPART(weekday, @StartDate),
        -- Day of the year number
        DATENAME(dayofyear, @StartDate),
        -- Week of the year number
        DATEPART(wk, @StartDate),
        -- Month number
        MONTH(@StartDate),
        -- Month name in English
        DATENAME(month, @StartDate),
        -- Quarter number
        DATEPART(qq, @StartDate),
        -- Quarter name
        CASE
            WHEN DATEPART(qq, @StartDate) = 1 THEN 'Q1'
            WHEN DATEPART(qq, @StartDate) = 2 THEN 'Q2'
            WHEN DATEPART(qq, @StartDate) = 3 THEN 'Q3'
            ELSE 'Q4'
        END,
        -- Year
        YEAR(@StartDate),
        -- Weekend check (Saturday or Sunday)
        CASE
            WHEN DATENAME(weekday, @StartDate) IN ('Saturday', 'Sunday') THEN 1
            ELSE 0
        END;

    -- Move to the next day
    SET @StartDate = DATEADD(day, 1, @StartDate);
END;

select * from DimDate