Declare @MaxDate Date = (Select Max(date) from Covid_19)

--FOR MONTHLY
DECLARE @startprevmonth Date;
SET @startprevmonth = DATEFROMPARTS(YEAR(@maxdate), MONTH(@maxdate) - 1, 1);
DECLARE @endprevmonth DATE   = EOMONTH(@MaxDate, -1);

--FOR 15 DAYS
DECLARE @start15 Date = DATEADD(DAY, -15, @MaxDate)

SELECT @StartPrevMonth AS StartPrevMonth, @EndPrevMonth AS EndPrevMonth;

--FOR MONTH 
SELECT SUM(positive_increase) AS total, state
FROM Covid_19
WHERE date >= @startprevmonth
  AND date <= @endprevmonth
  group by state order by state;

With currenttotal AS
(
	Select sum(total) as curtotal, state
	from Covid_19
	where date = @MaxDate
	group by state
)

select sum(ct.curtotal) - sum(c.total) as total, c.state
from Covid_19 as c join currenttotal as ct
on c.state = ct.state
where date = @endprevmonth
group by c.state
order by c.state;

With currentrecovered AS
(
	Select sum(recovered) as currecovered, state
	from Covid_19
	where date = @MaxDate
	group by state
)

select sum(cr.currecovered) - sum(c.recovered) as recovered, c.state
from Covid_19 as c join currentrecovered as cr
on c.state = cr.state
where date = @endprevmonth
group by c.state
order by c.state;