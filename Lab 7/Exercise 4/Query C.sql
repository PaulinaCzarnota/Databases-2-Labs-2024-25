SELECT ns.gid, ns.name AS street_name, ns.geom 

FROM nycstreet ns 

JOIN nycnb nb ON ST_Within(ns.geom, nb.geom)

WHERE ns.name IN ('Broadway', '5th Avenue') AND nb.boroname = 'Manhattan';