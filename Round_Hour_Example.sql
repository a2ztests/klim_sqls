select  
d.Station_Id, cast(d.[Date] as date) date, 
datepart(month, d.[Date]) month, 
datepart(year, d.[Date]) year, 
concat(datepart(month, d.[Date]), '-',datepart(year, d.[Date])),  
--cast(d.[Time] as time) time, datepart(time, d.[Time]) time_1,
datepart(hour, d.[Time]) hour, datepart(minute, d.[Time]) minute,
case when datepart(minute, d.[Time]) <30 then 
concat(datepart(hour, d.[Date]), ':00')
else concat(datepart(hour, d.[Date]), ':30')
end calc_minutes


from dbo.tbl_Monitor_Stations_Data_1 d
--where cast(d.[Date] as date)  <  '01/01/2000'

where 
cast(d.[Date] as date)  = '01/01/2000'
and cast(d.[Time] as time)  between '01:30:00' and '03:30:00'
