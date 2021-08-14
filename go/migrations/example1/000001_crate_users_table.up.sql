CREATE TABLE IF NOT EXISTS person(
    id serial PRIMARY KEY,
    first_name VARCHAR(10) NOT NULL,
    last_name VARCHAR(10) NOT NULL,
    email VARCHAR(20)
);