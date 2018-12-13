--Attach for each patient the monitor stations only for the patient's city mapped by Uriel
select 

--pat.Rec_Id,pat.Patient_Id,pat.Admission_Date,pat.City_Id, pat.City_desc,
pat.patient_id, 
map.Monitor_Station_Id, map.Monitor_Station_Desc, dis.monitor_station_city_distance as Station_City_Distance_km,
--pat.Admission_Date,cast(dat.[Date] as date) Monitor_date, --delete these fields for the researcher
month(cast(dat.[Date] as date)) Monitor_month, 
year(cast(dat.[Date] as date)) Monitor_year
--,ROW_NUMBER() over (partition by  pat.patient_id, map.Monitor_Station_Id, cast(dat.[Date] as date) order by cast(dat.[Time] as time) asc ) AS Row_Num
--,ROW_NUMBER() over (partition by  pat.patient_id, map.Monitor_Station_Id, cast(dat.[Date] as date) order by cast(dat.[Time] as time) asc ) / 48 as shifted_date_representor
--,datediff(day, pat.Admission_Date,cast(dat.[Date] as date)) as shifted_date_representor
,datediff(day, dateadd(dy, -5,pat.Admission_Date),cast(dat.[Date] as date)) as no_of_days_before_admission

,cast(dat.[Time] as time) Monitor_time,
dat.CO, dat.Filter, dat.[Filter-2.5], dat.ITemp, dat.Benzen, dat.H2S, dat.[No], dat.No2, dat.Nox, dat.O3, dat.PM10, dat.PREC, dat.RH, dat.SO2, dat.STAB, dat.[Temp], dat.TOLUENE, dat.WD, dat.WS, dat.BP, dat.[PM2.5], dat.SR, dat.StWd, dat.NO_T, dat.NOX_T, dat.NO2_T, dat.shTemp, dat.PM1


from dbo.klimodo_Patient_dummy_Data pat
left join dbo.klimodo_city_to_monitor_station_partial_map map

on pat.City_code = map.City_Code
join dbo.klimodo_monitor_station_city_distances dis
on dis.Monitor_Station_Id=map.Monitor_Station_Id
and dis.City_code = map.City_Code --only for the patient's city mapped by Uriel
join dbo.klimodo_monitor_stations_data dat
on dat.monitor_station_id = map.Monitor_Station_Id

where 
--Remember that pat.Admission_Date in the reservoir was shifted 5 days into the future
--and that we give 7 data days of the relevant stations prior to the admission date
cast(dat.[Date] as date) between dateadd(dy, -12,pat.Admission_Date) and dateadd(dy, -5,pat.Admission_Date)

