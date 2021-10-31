// Task 1: MASL's new ufo sighting 

MERGE (y:Year {year: toInteger(2021)})
MERGE (m:Month {month: toInteger(1), year: toInteger(2021)})
MERGE(y)-[rel1:IN_MONTH]->(m)
MERGE (s:State {state: "IN", month: toInteger(1), year:toInteger(2011) })
MERGE(m)-[rel2:IN_STATE]->(s)
MERGE (co:County {County: "LAKE"})
MERGE(s)-[rel3:IN_COUNTY]->(co)
MERGE (ci:City {city: "HIGHLAND", month: toInteger(1), year:toInteger(2021), latitude:toFloat(34.1113), longitude:toFloat(-117.1654) })
MERGE(co)-[rel4:IN_CITY]->(ci)
MERGE(ufo:Ufo {duration: "25 Minutes", text: "Awesome lights were seen in the sky", summary: "Awesome Lights", date_time: "14th January 2021 11PM", city: "HIGHLAND", county: "LAKE", state: "IN" , weather_observation: "the same as that observed during 14th
August 1998 4PM"})
MERGE(ci)-[rel6:IN_SIGHT]->(ufo);

// Task 2. They have also realised that for all UFO sightings recorded in 2011 and 2008 with
// ‘Unknown’ shape should be ‘flying saucer’ and also the ‘Clear’ weather condition
// should be ‘Sunny/Clear’. Update these records with the correct UFO shape and
// weather conditions.

// SET Weather Conditions
MATCH(ufo:Ufo) WHERE ufo.conds ="CLEAR" AND ufo.year = 2011 OR ufo.year = 2008
SET ufo.conds = "SUNNY/CLEAR" 
RETURN ufo;

// Update Shape
MATCH(ufo:Ufo) WHERE ufo.shape ="UNKNOWN" AND ufo.year = 2011 OR ufo.year = 2008
SET ufo.shape = "FLYING SAUCER" 
RETURN ufo


// Task 3: Remove ARCADIA city from database 

MATCH(ci:City) WHERE ci.city = "ARCADIA" DETACH DELETE ci;


