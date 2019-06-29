CREATE DATABASE chicago_yelp;

USE chicago_yelp;

CREATE TABLE food_inspection (
	id INTEGER PRIMARY KEY AUTO_INCREMENT,
    inspection_id INTEGER (15),
    dba_name VARCHAR (100),
    aka_name VARCHAR (100),
    license_no INTEGER (15),
    facility_type VARCHAR (100),
    risk VARCHAR (50),
    address VARCHAR (150),
    city VARCHAR (70),
    state VARCHAR (2),
    zip VARCHAR (10),
    inspection_date DATETIME,
    inspection_type VARCHAR(50),
    results VARCHAR (50),
    violations VARCHAR (8000),
    latitude FLOAT (20),
    longitude FLOAT (20),
    location VARCHAR (100),
    historical_wards INTEGER (2),
    zip_codes INTEGER (5),
    community_areas INTEGER (5),
    census_tracts INTEGER (5),
    wards INTEGER (3)
);


CREATE TABLE yelp_business_info (
	id INTEGER PRIMARY KEY AUTO_INCREMENT,
	alias VARCHAR (100),
    categories VARCHAR (1000),
    coordinates VARCHAR (100),
    display_phone VARCHAR (15),
    hours VARCHAR (1000),
    yelp_id VARCHAR (50),
    image_url VARCHAR (1000),
    is_claimed BOOLEAN,
    is_closed BOOLEAN,
    display_address VARCHAR (300),
    address1 VARCHAR (100),
    address2 VARCHAR (100),
    address3 VARCHAR (100),
    city VARCHAR (70),
    state VARCHAR (2),
    zip_code VARCHAR (10),
	country VARCHAR (100),
    business_name VARCHAR (100),
    phone VARCHAR (20),
    price VARCHAR (5),
    rating DECIMAL (2,1),
    review_count INTEGER (20),
    transactions VARCHAR (100),
    yelp_url VARCHAR (1000)
);

CREATE TABLE business_info (
	id INTEGER PRIMARY KEY AUTO_INCREMENT,
	license_no INTEGER (15),
	yelp_id VARCHAR (50),
    inspection_name VARCHAR (100),
	inspection_address VARCHAR (300),
    yelp_name VARCHAR (100),
	yelp_address VARCHAR (300)
);

CREATE VIEW restaurant_inspection_review AS SELECT a.dba_name AS 'Business Name', a.inspection_date AS 'Inspection Date', a.risk AS 'Inspection Risk', a.results as 'Inspection Result', c.rating as 'Yelp Rating', c.review_count as 'Yelp Number of Reviews'
FROM food_inspection as a 
JOIN business_info as b on a.license_no = b.license_no
JOIN yelp_business_info as c on b.yelp_id = c.yelp_id;

