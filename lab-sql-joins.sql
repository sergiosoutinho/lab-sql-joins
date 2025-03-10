/* Write SQL queries to perform the following tasks using the Sakila database:*/
USE sakila;
/* 1. List the number of films per category.*/

SELECT name, count(*)
FROM sakila.film_category
INNER JOIN sakila.category
ON sakila.category.category_id = sakila.film_category.category_id
GROUP BY sakila.category.name;

/* 2. Retrieve the store ID, city, and country for each store.*/

SELECT *
FROM sakila.store;
SELECT *
FROM sakila.city;
SELECT *
FROM sakila.country;
SELECT *
FROM sakila.address;

SELECT store_id, city, country
FROM
	(SELECT store_id, adress_city.city_id, sakila.city.city, sakila.city.country_id
	FROM
		(SELECT city_id, store_id
		FROM sakila.store
		INNER JOIN sakila.address
		ON sakila.store.address_id = sakila.address.address_id) AS adress_city
	INNER JOIN sakila.city
	ON 	sakila.city.city_id = adress_city.city_id) AS adress_store
INNER JOIN sakila.country
ON sakila.country.country_id = adress_store.country_id;


/* 3. Calculate the total revenue generated by each store in dollars.*/

SELECT store_id, ROUND(SUM(sakila.payment.amount + "$"),2) AS total_revenue$
FROM sakila.payment
INNER JOIN sakila.staff
ON sakila.payment.staff_id = sakila.staff.staff_id
GROUP BY store_id;

/* 4. Determine the average running time of films for each category.*/

SELECT category_id, AVG(film.length)
FROM sakila.film
INNER JOIN sakila.film_category
ON sakila.film.film_id = sakila.film_category.film_id
GROUP BY category_id; 

/* 5. Identify the film categories with the longest average running time.*/

SELECT category_id, AVG(film.length)
FROM sakila.film
INNER JOIN sakila.film_category
ON sakila.film.film_id = sakila.film_category.film_id
GROUP BY category_id
ORDER BY AVG(film.length) DESC
LIMIT 1;

/* 6. Display the top 10 most frequently rented movies in descending order.*/

SELECT f.film_id, 
       f.title, 
       COUNT(r.rental_id) AS rental_count
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY f.film_id, f.title
ORDER BY rental_count DESC
LIMIT 10;

/* 7.Determine if "Academy Dinosaur" can be rented from Store 1.*/

SELECT film.film_id, film.title, inventory_id, store_id
FROM sakila.film
INNER JOIN
	(SELECT inventory.inventory_id, store_id, film_id
	FROM sakila.inventory
	INNER JOIN
		(SELECT inventory_ID
		FROM sakila.rental
		WHERE return_date > rental_date) AS available
	ON sakila.inventory.inventory_ID = available.inventory_ID) available_by_store
ON sakila.film.film_id = sakila.available_by_store.film_id
WHERE film.title LIKE "%demy _inosa%"
AND store_id = 1; 
