/* 
1. My partner and I want to come by each of the stores in person and meet the managers. 
Please send over the managers’ names at each store, with the full address 
of each property (street address, district, city, and country please).  
*/ 
SELECT 
	sr.store_id,
    CONCAT(sf.first_name, ' ', sf.last_name) AS manager_full_name,
    ad.address,
    ad.district,
    city,
    country
FROM store sr
JOIN staff sf 
	ON sr.manager_staff_id = sf.staff_id
JOIN address ad
	ON sr.address_id = ad.address_id 
JOIN city USING(city_id)
JOIN country USING(country_id);
	
/*
2.	I would like to get a better understanding of all of the inventory that would come along with the business. 
Please pull together a list of each inventory item you have stocked, including the store_id number, 
the inventory_id, the name of the film, the film’s rating, its rental rate and replacement cost. 
*/

SELECT 
	store_id,
    inventory_id,
    f.title,
    f.rating,
    f.rental_rate,
    f.replacement_cost
FROM inventory i
JOIN film f USING (film_id);


/* 
3.	From the same list of films you just pulled, please roll that data up and provide a summary level overview 
of your inventory. We would like to know how many inventory items you have with each rating at each store. 
*/
SELECT 
	store_id,
    f.rating,
    COUNT(inventory_id) inventory_items
FROM inventory i
JOIN film f USING (film_id)
GROUP BY store_id, rating WITH ROLLUP;


/* 
4. Similarly, we want to understand how diversified the inventory is in terms of replacement cost. We want to 
see how big of a hit it would be if a certain category of film became unpopular at a certain store.
We would like to see the number of films, as well as the average replacement cost, and total replacement cost, 
sliced by store and film category. 
*/ 

SELECT 
	i.store_id,
    c.name AS category,
    COUNT(i.inventory_id) AS number_of_films_inventory,
    AVG(replacement_cost) AS average_replacment_cost,
    SUM(replacement_cost) AS total_replacement_cost
FROM inventory i
JOIN film f USING(film_id)
JOIN film_category fc USING(film_id)
JOIN category c USING(category_id)
GROUP BY i.store_id, c.name WITH ROLLUP
ORDER BY total_replacement_cost DESC;


/*
5.	We want to make sure you folks have a good handle on who your customers are. Please provide a list 
of all customer names, which store they go to, whether or not they are currently active, 
and their full addresses – street address, city, and country. 
*/

SELECT 
	CONCAT(first_name, ' ', last_name) AS customer_name,
    store_id,
    ad.address,
    city,
    country
FROM customer c
JOIN address ad USING(address_id)
JOIN city USING(city_id)
JOIN country USING(country_id);

/*
6.	We would like to understand how much your customers are spending with you, and also to know 
who your most valuable customers are. Please pull together a list of customer names, their total 
lifetime rentals, and the sum of all payments you have collected from them. It would be great to 
see this ordered on total lifetime value, with the most valuable customers at the top of the list. 
*/

SELECT 
	CONCAT(first_name, ' ', last_name) AS customer_name,
    COUNT(r.rental_id) AS total_rentals,
    SUM(amount) AS total_payment_amount
FROM customer c
JOIN rental r USING(customer_id)
JOIN payment USING(rental_id)
GROUP BY CONCAT(first_name, ' ', last_name)
ORDER BY total_payment_amount DESC;


/*
7. My partner and I would like to get to know your board of advisors and any current investors.
Could you please provide a list of advisor and investor names in one table? 
Could you please note whether they are an investor or an advisor, and for the investors, 
it would be good to include which company they work with. 
*/
SELECT 
	CONCAT(first_name, ' ', last_name) AS name,
    'investor' AS category,
    company_name
FROM investor
UNION
SELECT 
	CONCAT(first_name, ' ', last_name) AS name,
    'advisor',
    ' '
FROM advisor;


/*
8. We're interested in how well you have covered the most-awarded actors. 
Of all the actors with three types of awards, for what % of them do we carry a film?
And how about for actors with two types of awards? Same questions. 
Finally, how about actors with just one award? 
*/
/* View to classify award winners actors 3, 2 and 1*/
CREATE OR REPLACE VIEW actor_number_of_award AS
SELECT 
	actor_award_id,
    actor_id,
    awards,
    CASE
		WHEN awards LIKE 'Emmy, Oscar, Tony ' THEN 3
        WHEN awards IN ('Emmy, Oscar', 'Oscar, Tony', 'Emmy, Tony') THEN 2
        WHEN awards IN ('Emmy', 'Oscar', 'Tony') THEN 1
    END AS number_of_awards
FROM actor_award
WHERE actor_id IS NOT NULL;

SELECT
	( SELECT 
		100 * COUNT(actor_id) / COUNT(*) -- Divide the number of award(3) winners actors we carry a film by the number of ALL award(3) winners
	  FROM actor_number_of_award
	  WHERE number_of_awards = 3
    ) AS percentage_with_3_awards,
    ( SELECT 
		100 * COUNT(actor_id) / COUNT(*)
	  FROM actor_number_of_award
	  WHERE number_of_awards = 2
    ) AS percentage_with_2_award,
     ( SELECT 
		100 * COUNT(actor_id) / COUNT(*)
	  FROM actor_number_of_award
	  WHERE number_of_awards = 1
    ) AS percentage_with_1_award
    





























