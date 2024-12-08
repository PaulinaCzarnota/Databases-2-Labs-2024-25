SELECT st.gid, st.name AS station_name, st.geom 

FROM nycstation st 

JOIN nycnb nb ON ST_Contains(nb.geom, st.geom)

WHERE nb.boroname = 'Brooklyn';