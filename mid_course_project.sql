-- This is an exploratory analysis of the maven movies data

/*
1.	List of all staff members, including their first and last names, 
email addresses, and the store identification number where they work. 
*/ 
SELECT 
	first_name,
    last_name,
    email,
    store_id
FROM staff;

/*
2.	Separate counts of inventory items held at each of two stores. 
*/ 
SELECT 
	store_id,
	COUNT(inventory_id) AS number_of_items
FROM inventory
GROUP BY store_id;

/*
3. Count of active customers for each of stores. Separately. 
*/
SELECT 
	store_id,
    COUNT(customer_id) AS Active_customers
FROM customer
WHERE active = 1 -- 1 for active, 0 for non acive 
GROUP BY store_id;

/*
4. Count of all customer email addresses stored in the database. 
*/ 
SELECT 
	COUNT(email) AS number_of_customer_email
FROM customer;

/*
5. Count of unique film titles in inventory at each store and 
count of the unique categories of films you provide. 
*/
SELECT 
	store_id,
    COUNT( DISTINCT f.title)
FROM inventory i
JOIN film f USING(film_id)
GROUP BY i.store_id;
SELECT 
	COUNT(category_id) AS number_of_categories
FROM film_category;

/*
6.Replacement cost for the film that is least expensive to replace, 
the most expensive to replace, and the average of all films you carry. ``	
*/

SELECT 
    MIN(replacement_cost) AS least_expensive_film_to_replace,
	MAX(replacement_cost) AS most_expensive_film_to_replace,
	AVG(replacement_cost) AS average
FROM film;

/*
7.	We are interested in having you put payment monitoring systems and maximum payment 
processing restrictions in place in order to minimize the future risk of fraud by your staff. 
Please provide the average payment you process, as well as the maximum payment you have processed.
*/

SELECT 
	AVG(amount) AS average_payment,
    MAX(amount) AS maximum_payment
FROM payment;

/*
8.	We would like to better understand what your customer base looks like. 
Please provide a list of all customer identification values, with a count of rentals 
they have made all-time, with your highest volume customers at the top of the list.
*/
SELECT 
	customer_id,
    COUNT(rental_id) AS number_of_rentals
FROM rental
GROUP BY customer_id
ORDER BY number_of_rentals DESC;

















