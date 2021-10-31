//Create Year and Month Nodes

LOAD CSV FROM 'file:///ufo_a2.csv' AS row
WITH toInteger(row[9]) AS year WHERE year IS NOT NULL
MERGE (y:Year {year: year});

LOAD CSV WITH HEADERS FROM 'file:///ufo_a2.csv' AS row
FOREACH (x IN row.year |
  MERGE (z:Year {year: x})
  MERGE (m:Month {month: toInteger(row.month), year: x})
  MERGE (z)-[rel:IN_MONTH]->(m));

// Create State Nodes
LOAD CSV WITH HEADERS FROM 'file:///ufo_a2.csv' AS row
FOREACH (x IN row.month |
  MERGE (m:Month {month: toInteger(x), year: row.year})
  MERGE (s:State {state: row.state, month: x, year:row.year })
  MERGE (m)-[rel1:IN_STATE]->(s));

  


// Create County nodes
:auto USING PERIODIC COMMIT 500
LOAD CSV FROM 'file:///states_a2.csv' AS row
  WITH row[1] as states, row[4] as county, row[0] as city
  UNWIND states as state
  MATCH(s:State {state: state})
  MERGE (co:County {county: county, month: s.month, year:s.year })
  MERGE(s)-[rel:IN_COUNTY]->(co)
  MERGE(co)-[rel1:IN_CITY]->(ci:City{city: city, month:s.month, year: s.year });


// Set Latitude and Longitude to Cities
LOAD CSV FROM 'file:///states_a2.csv' AS row
WITH row[0] AS city, toFloat(row[2]) as latitude, toFloat(row[3]) as longitude
MATCH (c:City {city: city})
    SET c.latitude = latitude
    SET c.longitude = longitude;


// Create Ufo


LOAD CSV FROM 'file:///ufo_a2.csv' AS row

WITH row[2] AS duration, row[8] as shape, row[4] AS text, row[6] AS city, row[7] AS state, toInteger(row[9]) AS year, toInteger(row[1]) AS day, toInteger(row[2]) AS hour, 
toFloat(row[10]) as pressure, toFloat(row[11]) as temp, toInteger(row[12]) as hail, toFloat(row[13]) as heatindex, toFloat(row[14]) as windchill, toInteger(row[15]) as rain, 
toFloat(row[16]) as vis, toFloat(row[17]) as dewpt, toInteger(row[18]) as thunder, toInteger(row[19]) as fog, toFloat(row[20]) as precip, 
toFloat(row[21]) as wspd, toInteger(row[22]) as tornado, toFloat(row[23]) as hum, toInteger(row[24]) as snow, toFloat(row[25]) as wgust, row[26] as wdire, row[5] as summary,  row[27] AS conds,  toInteger(row[0]) AS month WHERE month IS NOT NULL


UNWIND city as cit
MATCH(ci:City {city: cit})

MERGE (u:Ufo {summary: summary,  duration: duration, city:city, state:state,  
month:month, year:year,   hail:hail,rain:rain,  thunder:thunder, fog:fog, tornado:tornado,snow:snow,month:month    })


MERGE (ci)-[rel1:IN_SIGHT]->(u)

    SET u.shape = shape
    SET u.pressure = pressure
    SET u. temp = temp
    SET u.heatindex = heatindex
    SET u.windchill = windchill
    SET u.vis = vis
    SET u.dewpt = dewpt
    SET u.precip = precip
    SET u.wspd = wspd
    SET u.hum = hum
    SET u.wgust = wgust
    SET u.wdire = wdire 
    SET u.conds = conds 
