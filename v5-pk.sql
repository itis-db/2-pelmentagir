ALTER TABLE Route DROP CONSTRAINT IF EXISTS fk_origin_airport;
ALTER TABLE Route DROP CONSTRAINT IF EXISTS fk_destination_airport;
ALTER TABLE Route DROP CONSTRAINT IF EXISTS fk_airline_route;
ALTER TABLE FlightSchedule DROP CONSTRAINT IF EXISTS fk_route_schedule;
ALTER TABLE FlightSchedule DROP CONSTRAINT IF EXISTS fk_offer_schedule;
ALTER TABLE Offer DROP CONSTRAINT IF EXISTS fk_airline_offer;

ALTER TABLE Offer ADD COLUMN airline_name VARCHAR(255);
ALTER TABLE Offer ADD COLUMN airline_country VARCHAR(255);
ALTER TABLE Route ADD COLUMN origin_airport_name VARCHAR(255);
ALTER TABLE Route ADD COLUMN origin_city VARCHAR(255);
ALTER TABLE Route ADD COLUMN origin_country VARCHAR(255);
ALTER TABLE Route ADD COLUMN destination_airport_name VARCHAR(255);
ALTER TABLE Route ADD COLUMN destination_city VARCHAR(255);
ALTER TABLE Route ADD COLUMN destination_country VARCHAR(255);
ALTER TABLE Route ADD COLUMN airline_name VARCHAR(255);
ALTER TABLE Route ADD COLUMN airline_country VARCHAR(255);
ALTER TABLE FlightSchedule ADD COLUMN origin_airport_name VARCHAR(255);
ALTER TABLE FlightSchedule ADD COLUMN origin_city VARCHAR(255);
ALTER TABLE FlightSchedule ADD COLUMN origin_country VARCHAR(255);
ALTER TABLE FlightSchedule ADD COLUMN destination_airport_name VARCHAR(255);
ALTER TABLE FlightSchedule ADD COLUMN destination_city VARCHAR(255);
ALTER TABLE FlightSchedule ADD COLUMN destination_country VARCHAR(255);
ALTER TABLE FlightSchedule ADD COLUMN airline_name VARCHAR(255);
ALTER TABLE FlightSchedule ADD COLUMN airline_country VARCHAR(255);

UPDATE Offer o
SET airline_name = a.name, airline_country = a.country
FROM Airline a
WHERE o.airline_id = a.id;

UPDATE Route r
SET origin_airport_name = a1.name, origin_city = a1.city, origin_country = a1.country,
    destination_airport_name = a2.name, destination_city = a2.city, destination_country = a2.country,
    airline_name = al.name, airline_country = al.country
FROM Airport a1, Airport a2, Airline al
WHERE r.origin_airport_id = a1.id AND r.destination_airport_id = a2.id AND r.airline_id = al.id;

UPDATE FlightSchedule fs
SET origin_airport_name = r.origin_airport_name, origin_city = r.origin_city, origin_country = r.origin_country,
    destination_airport_name = r.destination_airport_name, destination_city = r.destination_city, destination_country = r.destination_country,
    airline_name = r.airline_name, airline_country = r.airline_country
FROM Route r
WHERE fs.route_id = r.id;

ALTER TABLE Offer DROP COLUMN airline_id;
ALTER TABLE Route DROP COLUMN origin_airport_id;
ALTER TABLE Route DROP COLUMN destination_airport_id;
ALTER TABLE Route DROP COLUMN airline_id;
ALTER TABLE FlightSchedule DROP COLUMN route_id;

ALTER TABLE Airport DROP CONSTRAINT IF EXISTS airport_pkey;
ALTER TABLE Airport DROP COLUMN IF EXISTS id;
ALTER TABLE Airline DROP CONSTRAINT IF EXISTS airline_pkey;
ALTER TABLE Airline DROP COLUMN IF EXISTS id;
ALTER TABLE Offer DROP CONSTRAINT IF EXISTS offer_pkey;
ALTER TABLE Offer DROP COLUMN IF EXISTS id;
ALTER TABLE Route DROP CONSTRAINT IF EXISTS route_pkey;
ALTER TABLE Route DROP COLUMN IF EXISTS id;
ALTER TABLE FlightSchedule DROP CONSTRAINT IF EXISTS flightschedule_pkey;
ALTER TABLE FlightSchedule DROP COLUMN IF EXISTS id;

ALTER TABLE Airport ADD PRIMARY KEY (name, city, country);
ALTER TABLE Airline ADD PRIMARY KEY (name, country);
ALTER TABLE Offer ADD PRIMARY KEY (title, airline_name, airline_country, valid_from);
ALTER TABLE Route ADD PRIMARY KEY (origin_airport_name, origin_city, origin_country, destination_airport_name, destination_city, destination_country, airline_name, airline_country);
ALTER TABLE FlightSchedule ADD PRIMARY KEY (origin_airport_name, origin_city, origin_country, destination_airport_name, destination_city, destination_country, airline_name, airline_country, departure_time);

ALTER TABLE Offer ADD FOREIGN KEY (airline_name, airline_country) REFERENCES Airline(name, country);
ALTER TABLE Route ADD FOREIGN KEY (origin_airport_name, origin_city, origin_country) REFERENCES Airport(name, city, country);
ALTER TABLE Route ADD FOREIGN KEY (destination_airport_name, destination_city, destination_country) REFERENCES Airport(name, city, country);
ALTER TABLE Route ADD FOREIGN KEY (airline_name, airline_country) REFERENCES Airline(name, country);
ALTER TABLE FlightSchedule ADD FOREIGN KEY (origin_airport_name, origin_city, origin_country) REFERENCES Airport(name, city, country);
ALTER TABLE FlightSchedule ADD FOREIGN KEY (destination_airport_name, destination_city, destination_country) REFERENCES Airport(name, city, country);
ALTER TABLE FlightSchedule ADD FOREIGN KEY (airline_name, airline_country) REFERENCES Airline(name, country);

-- Rollback
ALTER TABLE FlightSchedule DROP CONSTRAINT IF EXISTS flightchedule_airline_name_fkey;
ALTER TABLE FlightSchedule DROP CONSTRAINT IF EXISTS flightchedule_origin_airport_name_fkey;
ALTER TABLE FlightSchedule DROP CONSTRAINT IF EXISTS flightchedule_destination_airport_name_fkey;

ALTER TABLE Route DROP CONSTRAINT IF EXISTS route_airline_name_fkey;
ALTER TABLE Route DROP CONSTRAINT IF EXISTS route_origin_airport_name_fkey;
ALTER TABLE Route DROP CONSTRAINT IF EXISTS route_destination_airport_name_fkey;

ALTER TABLE Offer DROP CONSTRAINT IF EXISTS offer_airline_name_fkey;

ALTER TABLE FlightSchedule DROP CONSTRAINT IF EXISTS flightschedule_pkey;
ALTER TABLE Route DROP CONSTRAINT IF EXISTS route_pkey;
ALTER TABLE Offer DROP CONSTRAINT IF EXISTS offer_pkey;
ALTER TABLE Airline DROP CONSTRAINT IF EXISTS airline_pkey CASCADE;
ALTER TABLE Airport DROP CONSTRAINT IF EXISTS airport_pkey CASCADE;

ALTER TABLE FlightSchedule ADD COLUMN id SERIAL PRIMARY KEY;
ALTER TABLE Route ADD COLUMN id SERIAL PRIMARY KEY;
ALTER TABLE Offer ADD COLUMN id SERIAL PRIMARY KEY;
ALTER TABLE Airline ADD COLUMN id SERIAL PRIMARY KEY;
ALTER TABLE Airport ADD COLUMN id SERIAL PRIMARY KEY;

ALTER TABLE Offer ADD COLUMN airline_id INT;
ALTER TABLE Route ADD COLUMN origin_airport_id INT;
ALTER TABLE Route ADD COLUMN destination_airport_id INT;
ALTER TABLE Route ADD COLUMN airline_id INT;
ALTER TABLE FlightSchedule ADD COLUMN route_id INT;

UPDATE Offer o
SET airline_id = a.id
FROM Airline a
WHERE o.airline_name = a.name AND o.airline_country = a.country;

UPDATE Route r
SET origin_airport_id = a1.id,
    destination_airport_id = a2.id,
    airline_id = al.id
FROM Airport a1, Airport a2, Airline al
WHERE r.origin_airport_name = a1.name AND r.origin_city = a1.city AND r.origin_country = a1.country
  AND r.destination_airport_name = a2.name AND r.destination_city = a2.city AND r.destination_country = a2.country
  AND r.airline_name = al.name AND r.airline_country = al.country;

UPDATE FlightSchedule fs
SET route_id = r.id
FROM Route r
WHERE fs.origin_airport_name = r.origin_airport_name AND fs.origin_city = r.origin_city AND fs.origin_country = r.origin_country
  AND fs.destination_airport_name = r.destination_airport_name AND fs.destination_city = r.destination_city AND fs.destination_country = r.destination_country
  AND fs.airline_name = r.airline_name AND fs.airline_country = r.airline_country;

ALTER TABLE Offer DROP COLUMN IF EXISTS airline_name;
ALTER TABLE Offer DROP COLUMN IF EXISTS airline_country;

ALTER TABLE Route DROP COLUMN IF EXISTS origin_airport_name;
ALTER TABLE Route DROP COLUMN IF EXISTS origin_city;
ALTER TABLE Route DROP COLUMN IF EXISTS origin_country;
ALTER TABLE Route DROP COLUMN IF EXISTS destination_airport_name;
ALTER TABLE Route DROP COLUMN IF EXISTS destination_city;
ALTER TABLE Route DROP COLUMN IF EXISTS destination_country;
ALTER TABLE Route DROP COLUMN IF EXISTS airline_name;
ALTER TABLE Route DROP COLUMN IF EXISTS airline_country;

ALTER TABLE FlightSchedule DROP COLUMN IF EXISTS origin_airport_name;
ALTER TABLE FlightSchedule DROP COLUMN IF EXISTS origin_city;
ALTER TABLE FlightSchedule DROP COLUMN IF EXISTS origin_country;
ALTER TABLE FlightSchedule DROP COLUMN IF EXISTS destination_airport_name;
ALTER TABLE FlightSchedule DROP COLUMN IF EXISTS destination_city;
ALTER TABLE FlightSchedule DROP COLUMN IF EXISTS destination_country;
ALTER TABLE FlightSchedule DROP COLUMN IF EXISTS airline_name;
ALTER TABLE FlightSchedule DROP COLUMN IF EXISTS airline_country;

ALTER TABLE Route ADD CONSTRAINT fk_origin_airport FOREIGN KEY (origin_airport_id) REFERENCES Airport(id);
ALTER TABLE Route ADD CONSTRAINT fk_destination_airport FOREIGN KEY (destination_airport_id) REFERENCES Airport(id);
ALTER TABLE Route ADD CONSTRAINT fk_airline_route FOREIGN KEY (airline_id) REFERENCES Airline(id);

ALTER TABLE FlightSchedule ADD CONSTRAINT fk_route_schedule FOREIGN KEY (route_id) REFERENCES Route(id);

ALTER TABLE Offer ADD CONSTRAINT fk_airline_offer FOREIGN KEY (airline_id) REFERENCES Airline(id);

