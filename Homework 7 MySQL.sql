--Scott Otto
--Homework 7
--Module 9 MySql

use sakila;

--1a. Display the first and last names of all actors from the table `actor`.

--SELECT * FROM actor;
SELECT first_name, last_name
FROM actor;


--1b. Display the first and last name of each actor in a single column in 
--    upper case letters. Name the column `Actor Name`.

SELECT UPPER(CONCAT(first_name, ' ', last_name)) AS 'Actor Name'
FROM actor;		


--2a. You need to find the ID number, first name, and last name of an 
--    actor, of whom you know only the first name, "Joe." 
--    What is one query would you use to obtain this information?

SELECT actor_id, first_name, last_name
FROM actor
WHERE first_name = 'Joe';


--2b. Find all actors whose last name contain the letters `GEN`

SELECT actor_id, first_name, last_name
FROM actor
WHERE last_name LIKE '%GEN%';


--2c. Find all actors whose last names contain the letters `LI`. This time, 
--    order the rows by last name and first name, in that order

SELECT last_name, first_name, actor_id
FROM actor
WHERE last_name LIKE '%LI%'
ORDER BY last_name, first_name;


--2d. Using `IN`, display the `country_id` and `country` columns of the following 
--    countries: Afghanistan, Bangladesh, and China

SELECT country_id, country
FROM country
WHERE country IN ('Afghanistan' , 'Bangladesh', 'China');


--3a. You want to keep a description of each actor. You don't think you will be 
--    performing queries on a description, so create a column in the 
--    table `actor` named `description` and use the data type `BLOB` (Make sure to research the 
--    type `BLOB`, as the difference between it and `VARCHAR` are significant).

ALTER TABLE actor
ADD COLUMN description BLOB;
SELECT *
FROM actor;


--3b. Very quickly you realize that entering descriptions for each actor is too much 
--    effort. Delete the `description` column.

ALTER TABLE actor
DROP COLUMN description;
SELECT *
FROM actor;


--4a. List the last names of actors, as well as how many actors have that last name.

SELECT last_name, COUNT(last_name) AS Total
FROM actor
GROUP BY last_name;


--4b. List last names of actors and the number of actors who have that last name, but 
--    only for names that are shared by at least two actors.

SELECT last_name, COUNT(last_name) AS total
FROM actor
GROUP BY last_name
HAVING total > 1;


--4c. The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table as `GROUCHO WILLIAMS`. 
--    Write a query to fix the record.

SELECT *
FROM actor
WHERE last_name = 'Williams'
AND first_name = 'Groucho';

UPDATE actor 
SET first_name = 'HARPO'
WHERE actor_id = 172;

SELECT *
FROM actor
WHERE last_name = 'Williams'
AND first_name = 'Harpo';


--4d. Perhaps we were too hasty in changing `GROUCHO` to `HARPO`. It turns out that `GROUCHO` was the
--    correct name after all! In a single query, if the first name of the actor is currently `HARPO`, 
--    change it to `GROUCHO`.

-- Turn off safe updates
SET SQL_SAFE_UPDATES = 0;
UPDATE actor
SET first_name = 'GROUCHO'
WHERE first_name = 'HARPO';

SELECT *
FROM actor
WHERE last_name = 'Williams'
AND first_name = 'Groucho';


--5a. You cannot locate the schema of the `address` table. Which query would you use to re-create it?

SHOW CREATE TABLE sakila.address;


--6a. Use `JOIN` to display the first and last names, as well as the address, of each staff member. 
--    Use the tables `staff` and `address`

--SELECT * FROM staff;
--SELECT * FROM address;

SELECT first_name, last_name, address.address
FROM staff
JOIN address ON staff.address_id = address.address_id;


--6b. Use `JOIN` to display the total amount rung up by each staff member in 
--    August of 2005. Use tables `staff` and `payment`

--SELECT * FROM staff;
--SELECT * FROM payment;

SELECT first_name, last_name, SUM(payment.amount) AS total_amount
FROM staff
JOIN payment ON staff.staff_id = payment.staff_id
WHERE payment.payment_date BETWEEN '2005-08-01 00:00:00' AND '2005-08-31 23:59:59'
GROUP BY first_name, last_name;


--6c. List each film and the number of actors who are listed for that film. Use tables 
--    `film_actor` and `film`. Use inner join.

--SELECT * FROM film;
--SELECT * FROM film_actor;

SELECT title, COUNT(film_actor.film_id) AS number_of_actors
FROM film
INNER JOIN film_actor ON film.film_id = film_actor.film_id
GROUP BY film.film_id;


--6d. How many copies of the film `Hunchback Impossible` exist in the inventory system?

--SELECT * FROM inventory;
--SELECT * FROM film;

SELECT title, count(inventory.film_id) as number_of_copies
FROM film
INNER JOIN inventory ON film.film_id = inventory.film_id
WHERE title = 'Hunchback Impossible';


--6e. Using the tables `payment` and `customer` and the `JOIN` command, list the total paid by 
--    each customer. List the customers alphabetically by last name

--SELECT * FROM payment;
--SELECT * FROM customer;

SELECT last_name, first_name, SUM(payment.amount) as total_paid
FROM customer
INNER JOIN payment ON customer.customer_id = payment.customer_id
GROUP BY last_name, first_name
ORDER BY last_name, first_name;


--7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. 
--    As an unintended consequence, films starting with the letters `K` and `Q` 
--    have also soared in popularity. Use subqueries to display the titles
--    of movies starting with the letters `K` and `Q` whose language is English

--SELECT * FROM film;
--SELECT * FROM language;

SELECT title
FROM film
WHERE
	(
    SELECT language_id
    FROM language
    WHERE name = 'English'
    )
AND title LIKE 'K%'
OR title LIKE 'Q%';


--7b. Use subqueries to display all actors who appear in the film `Alone Trip`

--SELECT * FROM film;
--SELECT * FROM film_actor;
--SELECT * FROM actor;

SELECT first_name, last_name
FROM actor
WHERE actor_id IN
	(
	SELECT actor_id
	FROM film_actor
    WHERE film_id IN
		(
		SELECT film_id
		FROM film
		WHERE  title = 'Alone Trip'
        )
	)
;   


--7c. You want to run an email marketing campaign in Canada, for which you will need 
--    the names and email addresses of all Canadian customers. Use joins to retrieve 
--    this information.

--SELECT * FROM customer;
--SELECT * FROM address;
--SELECT * FROM city;
--SELECT * FROM country;

SELECT first_name, last_name, email, country
FROM customer
JOIN address ON customer.address_id = address.address_id
JOIN city ON address.city_id = city.city_id
JOIN country ON city.country_id = country.country_id
WHERE country.country LIKE 'Canada';


--7d. Sales have been lagging among young families, and you wish to target all family 
--    movies for a promotion. Identify all movies categorized as _family_ films

--SELECT * FROM film;
--SELECT * FROM film_category;
--SELECT * FROM category;

SELECT title, category.name AS category
FROM film
JOIN film_category ON film.film_id = film_category.film_id
JOIN category ON film_category.category_id = category.category_id
WHERE category.name LIKE 'family%';



--7e. Display the most frequently rented movies in descending order.

--SELECT * from film;
--SELECT * from rental;
--SELECT * from inventory;

SELECT title, count(rental.rental_id) AS times_rented
FROM film
JOIN inventory ON film.film_id = inventory.film_id
JOIN rental ON inventory.inventory_id = rental.inventory_id
GROUP BY title
ORDER BY times_rented DESC;


--7f. Write a query to display how much business, in dollars, each store brought in.

--SELECT * FROM payment;
--SELECT * FROM store;

SELECT store_id, SUM(payment.amount)
FROM payment
JOIN staff ON payment.staff_id = staff.staff_id
GROUP BY store_id;


--7g. Write a query to display for each store its store ID, city, and country.

--SELECT * FROM store;
--SELECT * FROM address;
--SELECT * FROM city;
--SELECT * FROM country;

SELECT store_id, city.city, country.country
FROM store
JOIN address ON store.address_id = address.address_id
JOIN city ON address.city_id = city.city_id
JOIN country ON city.country_id = country.country_id;


--7h. List the top five genres in gross revenue in descending order. 
--    (**Hint**: you may need to use the following tables: 
--    category, film_category, inventory, payment, and rental.)

--SELECT * FROM category;
--SELECT * FROM film_category;
--SELECT * FROM inventory;
--SELECT * FROM payment;
--SELECT * FROM rental;

SELECT category.name, SUM(payment.amount) AS gross_revenue
FROM category
JOIN film_category ON category.category_id = film_category.category_id
JOIN inventory ON film_category.film_id = inventory.film_id
JOIN rental ON inventory.inventory_id = rental.inventory_id
JOIN payment ON rental.rental_id = payment.rental_id
GROUP BY category.name
ORDER BY gross_revenue DESC LIMIT 5;


--8a. In your new role as an executive, you would like to have an easy way of viewing the 
--    Top five genres by gross revenue. Use the solution from the problem above to create a view. 
--    If you haven't solved 7h, you can substitute another query to create a view.
CREATE VIEW top_five_genres_revenue AS
SELECT category.name, SUM(payment.amount) AS gross_revenue
FROM category
JOIN film_category ON category.category_id = film_category.category_id
JOIN inventory ON film_category.film_id = inventory.film_id
JOIN rental ON inventory.inventory_id = rental.inventory_id
JOIN payment ON rental.rental_id = payment.rental_id
GROUP BY category.name
ORDER BY gross_revenue DESC LIMIT 5;


--8b. How would you display the view that you created in 8a?
SELECT * FROM top_five_genres_revenue;


--8c. You find that you no longer need the view `top_five_genres`. Write a query to delete it.
DROP VIEW top_five_genres_revenue;

