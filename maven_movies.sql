-- Providing stakeholder's introductory information
--List of manager names, their store_id, and the property address
SELECT 
	store.store_id,
    staff.first_name,
    staff.last_name,
    address.address,
	city.city,
    address.district,
    country.country
FROM store
	INNER JOIN staff
		ON store.store_id = staff.store_id
        AND store.manager_staff_id IN (1,2)
	INNER JOIN address
		ON staff.address_id = address.address_id
	INNER JOIN city
		ON address.city_id = city.city_id
	INNER JOIN country
		ON city.country_id = country.country_id


--Inventory: total stock assessment, includes duplicate titles for all stores
--Includes film name, rating, rental rate and replacement cost
SELECT 
	inventory.store_id,
	inventory.inventory_id,
    film.title,
    film.rating,
    film.rental_rate,
    film.replacement_cost
FROM inventory
	INNER JOIN film
		ON inventory.film_id = film.film_id

  
--Inventory analysis: group's films into rating category.
--Counts unique titles for each rating and store
SELECT
	film.rating,
	inventory.store_id,
	COUNT(inventory.inventory_id) as num_films
FROM inventory
	INNER JOIN film
		ON inventory.film_id = film.film_id
GROUP BY 1, 2
ORDER BY 2,1


--Inventory Analysis: groups films by category id and store id
--Count of unique films, Avg replacement cost of a film, and total replacement cost for all films
SELECT 
	inventory.store_id,
    film_category.category_id,
	COUNT(DISTINCT(inventory.film_id)) AS num_films,
    ROUND(AVG(replacement_cost),2) AS avg_replacement_cost,
    SUM(replacement_cost) AS total_replacement_cost
FROM film_category
	INNER JOIN film
		ON film_category.film_id = film.film_id
	INNER JOIN inventory
		ON film.film_id = inventory.film_id
GROUP BY inventory.store_id, film_category.category_id


--Customer Assessment: all customer names
--Customer's preffered store, status(active or inactive), and full address
SELECT 
	first_name,
    last_name,
    store_id,
    CASE WHEN active = 0 THEN 'Inactive' ELSE 'Active' END as active_or_inactive,
    address.address,
    city.city,
    country.country
FROM customer
	LEFT JOIN address
		ON customer.address_id = address.address_id
	INNER JOIN city
		ON address.city_id = city.city_id
	INNER JOIN country
		ON city.country_id = country.country_id


--Customer Analysis: sales grouped by customer ID
--Returns number of sales, and ranks by DESC value of total sales
SELECT 
	customer.customer_id,
	customer.first_name,
    customer.last_name,
    COUNT(DISTINCT(rental_id)) AS num_rentals,
    SUM(amount) AS total_sales
FROM customer
	LEFT JOIN payment
		ON customer.customer_id = payment.customer_id
        AND customer.active = 1
GROUP BY customer.customer_id
ORDER BY total_sales DESC
--Karl Seal(526) has highest total sales($221.55), and second highest number of rentals(45)
--Eleanor Hunt(148) has highest number of rentals(46) and second highest total sales($216.54)


--UNION list: investors and advisors
--advisors assigned 'maven movies' company name in order to align investory company data
SELECT 
	'advisor' AS type,
    first_name,
    last_name,
    'maven movies' AS company_name
FROM advisor
UNION
SELECT 
	'investor' AS type,
    first_name,
    last_name,
    company_name
FROM investor
