DECLARE
@Type_Id int = 1,
@DateBegin date = '20000610',
@DateEnd date = '20010131';

WITH Table_of_period as
(
  SELECT * FROM [TestDoc].[dbo].[Contracs] where [TypeId] = @Type_Id and
  ([DateFrom] between @DateBegin and @DateEnd
  OR [DateTo] between @DateBegin and @DateEnd
  OR [DateFrom] < @DateBegin and [DateTo] > @DateBegin) group by [Id],[TypeId],[ClientId],[DateFrom], [DateTo]
),

start_time_period (start_date2,rn,ClientId) as
(
  SELECT
	DateFrom, row_number() over (PARTITION BY ClientId order by DateFrom), ClientId
  FROM Table_of_period t WHERE /* t.iD 	NOT IN */
  not exists(select 1 /*Id*/ from Table_of_period  where t.ClientId = ClientId and t.DateFrom > DateFrom and t.DateFrom <= DateTo)
  group by
  DateFrom,ClientId
),

end_time_period (end_date, rn, ClientId) as
(
 select
  DateTo, row_number() over (PARTITION BY ClientId order by DateTo), ClientId
  from Table_of_period t where /* t.iD 	NOT IN */
  not exists(select 1/*Id*/ from Table_of_period where t.ClientId = ClientId and t.DateTo >= DateFrom and t.DateTo < DateTo)
  group by
  DateTo,ClientId
)


select start_time_period.ClientId, CASE WHEN start_time_period.start_date2 < @DateBegin THEN @DateBegin ELSE start_date2 END AS First_date, 
		    CASE WHEN end_time_period.end_date > @DateEnd THEN @DateEnd ELSE end_date END AS Last_date
from
 start_time_period join
 end_time_period on start_time_period.rn = end_time_period.rn and start_time_period.ClientId = end_time_period.ClientId;