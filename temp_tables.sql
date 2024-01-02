-- Create a view that summarizes rental information for each customer. 
-- The view should include the customer's ID, name, email address, 
-- and total number of rentals (rental_count).

CREATE VIEW rental_summary AS
SELECT
customer.customer_id,
CONCAT(first_name,' ',last_name) AS name,
email AS email_address,
COUNT(rental_id) rental_count
FROM customer
JOIN rental ON customer.customer_id=rental.customer_id
GROUP BY customer.customer_id,
CONCAT(first_name,' ',last_name),
email ;

-- Create a Temporary Table

CREATE TEMPORARY TABLE total_paid_table AS
(SELECT 
rental_summary.customer_id,
name,
SUM(amount) total_paid
FROM 
rental_summary
JOIN payment ON rental_summary.customer_id=payment.customer_id
GROUP BY rental_summary.customer_id, name);

-- Create a CTE and the Customer Summary Report
WITH customer_summary_report AS
(SELECT
rental_summary.customer_id,
rental_summary.name,
rental_summary.email_address,
rental_summary.rental_count,
total_paid_table.total_paid,
total_paid_table.total_paid/rental_summary.rental_count AS average_payment_per_rental
FROM rental_summary
JOIN total_paid_table ON rental_summary.customer_id= total_paid_table.customer_id)
SELECT 
*
FROM customer_summary_report
;

SELECT *
FROM customer_summary_report;
