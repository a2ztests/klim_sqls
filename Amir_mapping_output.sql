--Attach for each patient the monitor stations only for the patient's city NOT mapped by Uriel
select 

pnimi.Rec_Id,pnimi.Patient_Id, cast(pnimi.[Admission_Date] as date) Admission_Date,
pnimi.City_code as P_City_code, pnimi.City_desc as P_City_desc,
--pnimi.Rec_Id, -- This should be taken eventually from pnimi to replace only the above line (not the lines below)

pnimi.monitor_station_id,
pnimi.monitor_station_desc,
pnimi.Distance as Station_City_Distance_km,

dat.monitor_station_id, 
cast(dat.[Date] as date) Monitor_date, cast(dat.[Time] as time) Monitor_time,
 dat.CO, dat.Filter, dat.[Filter-2.5], dat.ITemp, dat.Benzen, dat.H2S, dat.[No], dat.No2, dat.Nox, dat.O3, dat.PM10, dat.PREC, dat.RH, dat.SO2, dat.STAB, dat.[Temp], dat.TOLUENE, dat.WD, dat.WS, dat.BP, dat.[PM2.5], dat.SR, dat.StWd, dat.NO_T, dat.NOX_T, dat.NO2_T, dat.shTemp, dat.PM1

from (
select 
pat.Rec_Id,pat.Patient_Id,pat.Admission_Date,pat.City_code, pat.City_desc,
dist.monitor_station_id as monitor_station_id, dist.monitor_station_desc as monitor_station_desc
, min(dist.monitor_station_city_distance) as distance
,ROW_NUMBER() over (partition by pat.Rec_Id, pat.Patient_Id, pat.Admission_Date order by min(dist.monitor_station_city_distance) asc ) AS Row_Num

from dbo.klimodo_Patient_dummy_Data pat
join dbo.klimodo_monitor_station_city_distances dist
on pat.city_code = dist.City_code
--We only take patient's cities that are not in Uriel's mapping
where  dist.monitor_station_desc not in (select map.City_Desc from dbo.klimodo_city_to_monitor_station_partial_map map)

group by 
pat.Rec_Id,pat.Patient_Id,pat.Admission_Date,pat.City_code, pat.City_desc, dist.monitor_station_id, dist.monitor_station_desc
) pnimi

join dbo.klimodo_monitor_stations_data dat
on dat.monitor_station_id = pnimi.Monitor_Station_Id
and cast(dat.[Date] as date) between dateadd(dy, -12,pnimi.Admission_Date) and dateadd(dy, -5,pnimi.Admission_Date)

where pnimi.Row_Num=1




