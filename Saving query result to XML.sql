select  [Place_Symbol]
      ,[Place_Desc]
      ,[Place_Latitude]
      ,[Place_Longitude]
      ,[City_GK]
      ,[City_Desc]
      ,[City_Latitude]
      ,[City_Longitude]
      ,[Place_City_Distance]
from [dbo].[tbl_Monitor_Station_City_Distances]
for XML AUTO, ELEMENTS, XMLSCHEMA ('MyURL')
--for XML PATH ('Places')



