// Task 1. How many UFO sightings were recorded in April?
MATCH(ufo:Ufo)
WHERE ufo.month = 4
WITH COUNT(ufo) as UfoSighting 
RETURN UfoSighting

// 2. Show all unique weather conditions, for UFOs in ‘CIRCLE’ shape appeared in ‘AZ’
// state before 2014(exclusive). Display all weather conditions in lowercase letters.

MATCH(ufo:Ufo) WHERE ufo.shape="CIRCLE" AND ufo.state = "AZ" 
    RETURN DISTINCT  toLower(ufo.conds) as WeatherConditions , ufo.year as Year
    ORDER BY ufo.year ASC
    LIMIT 18

// 3. Show all unique UFO shapes that appeared in 2015 but not in 2000.

MATCH(ufo:Ufo) WHERE ufo.year = 2015 AND NOT ufo.year = 2000
    RETURN DISTINCT  ufo.shape as Shape


// Task 4. List all unique years in ascending order if it has ‘at high speeds’ in the text in each
// UFO sighting recording.

MATCH(ufo:Ufo) 
WHERE ufo.text 
CONTAINS "at high speeds" 
    RETURN DISTINCT ufo.year as Year
    ORDER BY ufo.year ASC   

// Task 5: Count how many times each wind direction appeared across all years, sort the number
// of times of each direction in descending order.

MATCH(n:Ufo)  
WITH n.wdire as WindDirection, COUNT(n.wdire) as Count
RETURN DISTINCT WindDirection, Count
ORDER BY Count DESC;

// 6. Display the nearest city information around ‘CORAL SPRINGS’ city in
// ‘BROWARD’ county of ‘FL’. The output should also display the distance calculated
// between ‘CORAL SPRINGS’ city and the nearest city you found.
// 6. Display the nearest city information around ‘CORAL SPRINGS’ city in
// ‘BROWARD’ county of ‘FL’. The output should also display the distance calculated
// between ‘CORAL SPRINGS’ city and the nearest city you found.

MATCH(co:County{county:"BROWARD"})-[rel1:IN_CITY]->(ci:City)
UNWIND ci.latitude as lat
UNWIND ci.longitude as long
WITH
  ci.city as cities,
  point({latitude:lat, longitude:long }) AS p1,
  point({latitude:toFloat('26.2702'), longitude:toFloat('-80.2591')}) AS p2

RETURN DISTINCT cities, toInteger(distance(p1, p2)/1000) as km
ORDER BY km ASC
SKIP 1
LIMIT 1;



// Task 7: Find the year with the least number of different kinds of UFO shapes. Display the
// year and the number of counting in the output.

MATCH(ufo:Ufo)
RETURN DISTINCT ufo.year as  Year, COUNT(ufo.shape) as Shape
ORDER BY Shape ASC
LIMIT 1


// Task 8: What is the average temperature, pressure, and humidity of each UFO shape? (The
// output should also display the average values rounded to 3 decimal places)

MATCH (ufo:Ufo) 
WITH ufo.shape as Shape , round(AVG(ufo.temp),3) as Temperature , round(AVG(ufo.pressure),3) as Pressure,round(AVG(ufo.hum),3) as Humidity
RETURN DISTINCT Shape, Temperature, Pressure, Humidity;

// Task 9: Display the top 3 counties with the most number of different cities.
MATCH(co:County)-[rel1:IN_CITY]->(ci:City) 
WITH DISTINCT COUNT(ci.city) as Cities, co.county as County
RETURN  County, Cities 
ORDER BY Cities DESC
LIMIT 3

// Task 10: Rank the total number of UFO sighting recordings according to each state, display the
// state in descending order in the output.

MATCH(s:State)-[rel3:IN_COUNTY]->(co:County)-[rel4:IN_CITY]->(ci:City)-[rel5:IN_SIGHT]->(ufo:Ufo)
WITH s.state as State, ufo as UfoSighting
RETURN DISTINCT State, COUNT(UfoSighting)
ORDER BY COUNT(UfoSighting) DESC;