LOAD CSV FROM 'file:///ufo_a2.csv' AS row
WITH row[9] AS year
MERGE (y:Year {Year: year});

LOAD CSV FROM 'file:///ufo_a2.csv' AS row
WITH row[0] AS month
MERGE (m:Month {Month: month})
    SET m.month = month;

LOAD CSV  FROM 'file:///ufo_a2.csv' AS row
WITH row[9] AS year, row[0] AS month
MATCH (y:Year {Year: year})
MATCH (m:Month {Month: month})
MERGE (y)-[rel:IN_MONTH]->(m);

LOAD CSV FROM 'file:///ufo_a2.csv' AS row
WITH row[7] AS state
MERGE (s:State {State: state})
    SET s.state = state;


LOAD CSV FROM 'file:///ufo_a2.csv' AS row
WITH row[7] AS state, row[0] AS month
MATCH (m:Month {Month: month})
MATCH (s:State {State: state})
MERGE (m)-[rel:IN_STATE]->(s);


LOAD CSV FROM 'file:///states_a2.csv' AS row
WITH row[4] AS county
MERGE (c:County {County: county})
    SET c.county = county;

LOAD CSV FROM 'file:///states_a2.csv' AS row
WITH row[4] AS county, row[1] AS state
MATCH (c:County {County: county})
MATCH (s:State {State: state})
MERGE (s)-[rel:IN_COUNTY]->(c);

LOAD CSV FROM 'file:///states_a2.csv' AS row
WITH row[0] AS city
MERGE (c:City {City: city})
    SET c.city = city;

LOAD CSV FROM 'file:///states_a2.csv' AS row
WITH row[0] AS city, row[4] AS county
MATCH (co:County {County: county})
MATCH (ci:City {City: city})
MERGE (co)-[rel:IN_CITY]->(ci);

LOAD CSV FROM 'file:///states_a2.csv' AS row
WITH row[0] AS city, toFloat(row[2]) as latitude, toFloat(row[3]) as longitude
MERGE (c:City {City: city})
    SET c.latitude = latitude
    SET c.longitude = longitude;




// Create ufos
LOAD CSV FROM 'file:///ufo_a2.csv' AS row

WITH row[2] AS duration, row[8] as shape, row[4] AS text, row[6] AS city, row[7] AS state, toInteger(row[9]) AS year, toInteger(row[1]) AS day, toInteger(row[2]) AS hour, 
toFloat(row[10]) as pressure, toFloat(row[11]) as temp, toInteger(row[12]) as hail, toFloat(row[13]) as heatindex, toFloat(row[14]) as windchill, toInteger(row[15]) as rain, 
toFloat(row[16]) as vis, toFloat(row[17]) as dewpt, toInteger(row[18]) as thunder, toInteger(row[19]) as fog, toFloat(row[20]) as precip, 
toFloat(row[21]) as wspd, toInteger(row[22]) as tornado, toFloat(row[23]) as hum, toInteger(row[24]) as snow, toFloat(row[25]) as wgust, row[26] as wdire, row[5] as summary,  row[27] AS conds,  toInteger(row[0]) AS month WHERE month IS NOT NULL


MERGE (u:Ufo {summary: summary,  duration: duration, city:city, state:state,  
month:month, year:year,   hail:hail,rain:rain,  thunder:thunder, fog:fog, tornado:tornado,snow:snow,month:month    })




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
    SET u.text = text;


// Create relation between Shape and Ufos


LOAD CSV FROM 'file:///ufo_a2.csv' AS row

WITH row[2] AS duration, row[8] as shape, row[4] AS text, row[6] AS city, row[7] AS state, toInteger(row[9]) AS year, toInteger(row[1]) AS day, toInteger(row[2]) AS hour, 
toFloat(row[10]) as pressure, toFloat(row[11]) as temp, toInteger(row[12]) as hail, toFloat(row[13]) as heatindex, toFloat(row[14]) as windchill, toInteger(row[15]) as rain, 
toFloat(row[16]) as vis, toFloat(row[17]) as dewpt, toInteger(row[18]) as thunder, toInteger(row[19]) as fog, toFloat(row[20]) as precip, 
toFloat(row[21]) as wspd, toInteger(row[22]) as tornado, toFloat(row[23]) as hum, toInteger(row[24]) as snow, toFloat(row[25]) as wgust, row[26] as wdire, row[5] as summary,  row[27] AS conds,  toInteger(row[0]) AS month WHERE month IS NOT NULL


MATCH(u:Ufo {summary: summary,  duration: duration, city:city, state:state,  
month:month, year:year,   hail:hail,rain:rain,  thunder:thunder, fog:fog, tornado:tornado,snow:snow,month:month })
MATCH (ci:City {City: city})
MERGE (ci)-[rel:IN_SIGHT]->(u)

