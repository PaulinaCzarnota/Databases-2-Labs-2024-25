SELECT ns.gid, ns.name AS street_name, ns.geom 

FROM nycstreet ns 

WHERE ST_Crosses(ns.geom, (SELECT geom FROM nycnb WHERE name = 'East Village' LIMIT 1))

   OR ST_Contains(ns.geom, (SELECT geom FROM nycnb WHERE name = 'East Village' LIMIT 1));