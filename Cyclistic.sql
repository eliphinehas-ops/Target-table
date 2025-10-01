SELECT
TRI.usertype,
ZIPSTART.zip_code AS zip_code_start,
ZIPSTARTNAME.borough borough_start,
ZIPSTARTNAME.neighborhood AS neighborhood_start,
ZIPEND.zip_code AS zip_code_end,
ZIPENDNAME.borough borough_end,
ZIPENDNAME.neighborhood neighborhood_end,
DATE_ADD(DATE(TRI.starttime),INTERVAL 5 YEAR) AS Start_day,
DATE_ADD(DATE(TRI.stoptime),INTERVAL 5 YEAR) AS Stop_day,
WEA.temp AS day_mean_temp,
WEA.wdsp AS day_mean_wind_spd,
WEA.prcp AS day_mean_prcptatn,
ROUND(CAST(TRI.tripduration / 60 AS INT64), -1) AS trip_minutes,
COUNT(TRI.bikeid) AS trip_count
FROM
  `bigquery-public-data.new_york_citibike.citibike_trips` AS TRI
INNER JOIN
  `bigquery-public-data.geo_us_boundaries.zip_codes` ZIPSTART
ON ST_WITHIN(ST_GEOGPOINT(TRI.start_station_longitude, TRI.start_station_latitude),
ZIPSTART.zip_code_geom)
INNER JOIN
  `bigquery-public-data.geo_us_boundaries.zip_codes` ZIPEND
ON ST_WITHIN(ST_GEOGPOINT(TRI.end_station_longitude, TRI.end_station_latitude),
ZIPEND.zip_code_geom)
INNER JOIN
  `bigquery-public-data.noaa_gsod.gsod20*` AS WEA
ON PARSE_DATE("%Y%m%d", CONCAT(WEA.year, WEA.mo, WEA.da)) = DATE(TRI.starttime)
INNER JOIN
  `Zipcodes.Cyclistic` AS ZIPSTARTNAME
ON ZIPSTART.zip_code=CAST(ZIPSTARTNAME.zip AS string)
INNER JOIN
`Zipcodes.Cyclistic` AS ZIPENDNAME
ON ZIPEND.zip_code=CAST(ZIPENDNAME.zip AS string)
WHERE
  WEA.wban = '94728'
  AND EXTRACT(YEAR FROM DATE(TRI.starttime)) BETWEEN 2014 AND 2015
GROUP BY
1,2,3,4,5,6,7,8,9,10,11,12,13;





