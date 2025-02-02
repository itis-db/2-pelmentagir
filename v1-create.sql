CREATE TABLE IF NOT EXISTS Airport (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    city VARCHAR(255) NOT NULL,
    country VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS Airline (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    country VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS Offer (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    valid_from DATE NOT NULL,
    valid_to DATE NOT NULL,
    conditions TEXT,
    airline_id INT,
    CONSTRAINT fk_airline_offer FOREIGN KEY (airline_id) REFERENCES Airline(id)
);

CREATE TABLE IF NOT EXISTS Route (
    id SERIAL PRIMARY KEY,
    origin_airport_id INT,
    destination_airport_id INT,
    airline_id INT,
    distance_km INT NOT NULL,
    CONSTRAINT fk_origin_airport FOREIGN KEY (origin_airport_id) REFERENCES Airport(id),
    CONSTRAINT fk_destination_airport FOREIGN KEY (destination_airport_id) REFERENCES Airport(id),
    CONSTRAINT fk_airline_route FOREIGN KEY (airline_id) REFERENCES Airline(id),
    CONSTRAINT unique_route UNIQUE (origin_airport_id, destination_airport_id, airline_id)
);

CREATE TABLE IF NOT EXISTS FlightSchedule (
    id SERIAL PRIMARY KEY,
    route_id INT,
    departure_time TIMESTAMP NOT NULL,
    arrival_time TIMESTAMP NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    offer_id INT,
    CONSTRAINT fk_route_schedule FOREIGN KEY (route_id) REFERENCES Route(id),
    CONSTRAINT fk_offer_schedule FOREIGN KEY (offer_id) REFERENCES Offer(id)
);