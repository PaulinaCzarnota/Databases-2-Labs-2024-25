SELECT 

    ROW_NUMBER() OVER () AS id, 

    nb.name AS neighborhood, 

    nb.geom 

FROM nycnb nb 

JOIN nycstreet ns 

    ON ST_Crosses(nb.geom, ns.geom)

WHERE ns.name = 'Broadway' AND nb.boroname = 'Manhattan';