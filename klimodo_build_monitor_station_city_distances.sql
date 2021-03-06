---truncate table klimodo_monitor_station_city_distances

--Here we calculate the distances of every station to every city - in order to extract the minimum distance in future used sql in Impala


INSERT INTO [klimodo].[dbo].[klimodo_monitor_station_city_distances] ( monitor_station_id, monitor_station_desc, monitor_station_latitude, monitor_station_longitude, City_code, City_Desc,City_Latitude,City_Longitude,monitor_station_city_distance)

SELECT stations.monitor_station_id, stations.monitor_station_Desc, stations.Latitude, stations.Longitude, city.City_code, city.City_Desc,city.Latitude,city.Longitude,distance



FROM  [klimodo].[dbo].[klimodo_Monitor_Stations] stations
JOIN  [klimodo].[dbo].[Dim_City] city
on stations.Amir_monitor_station_id <> city.City_Gk --This is intentional because we want all the possible record cross


CROSS APPLY (SELECT (SIN(PI()*stations.Latitude/180.0)*SIN(PI()*city.Latitude/180.0)+COS(PI()*stations.Latitude/180.0)*COS(PI()*city.Latitude/180.0)*COS(PI()*city.Longitude/180.0-PI() *stations.Longitude/180.0))) T(ACosInput)

cross apply  (SELECT 6371 * acos(CASE WHEN ABS(ACosInput) > 1 THEN SIGN(ACosInput)*1 ELSE ACosInput END)) T2(distance)

where city.city_code >3 and city.city_Desc <>'לא ידוע'
order by stations.monitor_station_desc, city.city_desc