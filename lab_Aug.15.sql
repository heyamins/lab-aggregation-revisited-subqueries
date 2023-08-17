-- Select the first name, last name, and email address of all the customers who have rented a movie.
use sakila;

select distinct first_name, last_name, email 
FROM sakila.customer c
INNER JOIN rental r on c.customer_id = r.customer_id;

-- What is the average payment made by each customer (display the customer id, customer name (concatenated), and the average payment made).

select p.customer_id, avg(amount) as avg_payment, concat(first_name, ' ',last_name) as full_name  
FROM sakila.payment p
left join customer c on p.customer_id = c.customer_id
group by p.customer_id, full_name;

-- Select the name and email address of all the customers who have rented the "Action" movies.
-- Write the query using multiple join statements

select distinct c.first_name, c.last_name, c.email 
from customer c
join rental r on c.customer_id = r.customer_id
join inventory i on r.inventory_id = i.inventory_id
join film_category f on i.film_id = f.film_id
join category ca on f.category_id = ca.category_id
where ca.name = 'action';


-- Write the query using sub queries with multiple WHERE clause and IN condition

SELECT DISTINCT first_name, last_name, email 
FROM customer 
WHERE customer_id IN (
    SELECT r.customer_id 
    FROM rental r
    WHERE r.inventory_id IN (
        SELECT i.inventory_id 
        FROM inventory i 
        WHERE i.film_id IN (
            SELECT f.film_id 
            FROM film_category f
            WHERE f.category_id IN (
                SELECT category_id 
                FROM category 
                WHERE name = 'Action'
            )
        )
    )
);


-- Verify if the above two queries produce the same results or not
-- Use the case statement to create a new column classifying existing columns as either or high value transactions based on the amount of payment.
-- If the amount is between 0 and 2, label should be low and if the amount is between 2 and 4, the label should be medium, 
-- and if it is more than 4, then it should be high.

select amount,
	case
		when amount between 0 and 2 then 'low'
        when amount between 2 and 4 then 'medium'
        else 'high'
	end as transaction_label
from payment;
