--Attach for each patient the monitor stations only for the patient's city mapped by Uriel
select 

pnimi.Rec_Id,pnimi.Patient_Id,
cast(pnimi.[Admission_Date] as date) Admission_Date,
pnimi.City_Id, pnimi.City_desc,

--pnimi.Rec_Id, -- This should be taken eventually from pat
map.Monitor_Station_Id, map.Monitor_Station_Desc, dis.Place_City_Distance as Station_City_Distance_km,

dat.Station_Id, 
cast(dat.[Date] as date) Monitor_date, cast(dat.[Time] as time) Monitor_time,
 dat.CO, dat.Filter, dat.[Filter-2.5], dat.ITemp, dat.Benzen, dat.H2S, dat.[No], dat.No2, dat.Nox, dat.O3, dat.PM10, dat.PREC, dat.RH, dat.SO2, dat.STAB, dat.[Temp], dat.TOLUENE, dat.WD, dat.WS, dat.BP, dat.[PM2.5], dat.SR, dat.StWd, dat.NO_T, dat.NOX_T, dat.NO2_T, dat.shTemp, dat.PM1

from 
--dbo.tbl_Patient_dummy_Data pat
--left join dbo.tbl_City_To_Monitor_Station_Partial_Map map
--on pat.City_Id = map.City_Code
tbl_City_To_Monitor_Station_Partial_Map map
join dbo.tbl_Monitor_Station_City_Distances dis
on dis.Place_Symbol=map.Monitor_Station_Id
and dis.City_code = map.City_Code --only for the patient's city mapped by Uriel

join dbo.tbl_Monitor_Stations_Data dat
on dat.Station_Id = map.Monitor_Station_Id

join (
select pat.Rec_Id,pat.Patient_Id,pat.Admission_Date,pat.City_Id, pat.City_desc
from dbo.tbl_Patient_dummy_Data pat
) pnimi
on 
pnimi.City_Id = map.City_Code and
--cast(dat.[Date] as date)= pnimi.Admission_Date
--cast(dat.[Date] as date) = dateadd(dy, -5,pnimi.Admission_Date)
cast(dat.[Date] as date) between dateadd(dy, -12,pnimi.Admission_Date) and dateadd(dy, -5,pnimi.Admission_Date)
