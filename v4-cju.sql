-- CTE

WITH RouteCount AS (
    SELECT 
        route_id, 
        COUNT(*) AS flight_count
    FROM 
        FlightSchedule
    GROUP BY 
        route_id
)
SELECT 
    Route.id AS route_id,
    AirportOrigin.name AS origin_airport,
    AirportDestination.name AS destination_airport,
    RouteCount.flight_count
FROM 
    Route
JOIN 
    RouteCount ON Route.id = RouteCount.route_id
JOIN 
    Airport AS AirportOrigin ON Route.origin_airport_id = AirportOrigin.id
JOIN 
    Airport AS AirportDestination ON Route.destination_airport_id = AirportDestination.id
ORDER BY 
    RouteCount.flight_count DESC
LIMIT 10;

-- UNION
SELECT name, 'Airport' AS type FROM Airport
UNION
SELECT name, 'Airline' AS type FROM Airline;

-- 1. JOIN
SELECT 
    Route.id AS route_id,
    A1.name AS origin_airport,
    A2.name AS destination_airport,
    Route.distance_km
FROM 
    Route
JOIN 
    Airport A1 ON Route.origin_airport_id = A1.id
JOIN 
    Airport A2 ON Route.destination_airport_id = A2.id;

-- 2. JOIN

SELECT 
    FlightSchedule.id AS schedule_id,
    Airline.name AS airline_name,
    Route.distance_km,
    FlightSchedule.departure_time,
    FlightSchedule.arrival_time,
    FlightSchedule.price
FROM 
    FlightSchedule
JOIN 
    Route ON FlightSchedule.route_id = Route.id
JOIN 
    Airline ON Route.airline_id = Airline.id;

-- 3. JOIN

SELECT 
    Offer.id AS offer_id,
    Offer.title,
    Offer.description,
    Offer.valid_from,
    Offer.valid_to,
    Offer.conditions,
    Airline.name AS airline_name
FROM 
    Offer
JOIN 
    Airline ON Offer.airline_id = Airline.id;

-- 4. JOIN

SELECT 
    FlightSchedule.id AS schedule_id,
    Airline.name AS airline_name,
    Offer.title AS offer_title,
    Offer.description AS offer_description,
    Offer.discount AS offer_discount,
    FlightSchedule.departure_time,
    FlightSchedule.arrival_time,
    FlightSchedule.price
FROM 
    FlightSchedule
LEFT JOIN 
    Offer ON FlightSchedule.offer_id = Offer.id
JOIN 
    Route ON FlightSchedule.route_id = Route.id
JOIN 
    Airline ON Route.airline_id = Airline.id;