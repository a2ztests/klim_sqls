
select sql_pnimi.patient_id, sql_pnimi.monitor_station_id
, sql_pnimi.distance
from (
select p.case_no as patient_id, dist.place_symbol as monitor_station_id
, min(dist.place_city_distance) as distance
,ROW_NUMBER() over (partition by p.case_no order by min(dist.place_city_distance) asc ) AS Row_Num
--,ROW_NUMBER() over (partition by src.case_no, demog.Age_Range_Desc, demog.Gender_Desc order by min(nei.Distance) asc ) AS Row_Num
from brookdale_manipulated_for_klimodo p
join tbl_monitor_station_city_distances dist
on p.patient_location=dist.city_desc


group by p.case_no, dist.place_symbol
--order by p.case_no, distance asc
)sql_pnimi

where sql_pnimi.Row_Num=1
