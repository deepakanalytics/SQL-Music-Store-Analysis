Q1 Who is the senior most employee based on job title?

SELECT * FROM  EMPLOYEE
ORDER BY LEVELS DESC
LIMIT 1

Q2 Which countries have the most Invoices?

SELECT COUNT (*) AS C, BILLING_COUNTRY
FROM INVOICE
GROUP BY BILLING_COUNTRY
ORDER BY C DESC

Q3 What are top 3 values of total invoice?

SELECT TOTAL FROM INVOICE
ORDER BY TOTAL DESC
LIMIT 3

Q4 Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money. Write a query that returns one city that has the highest sum of invoice totals. Return both the city name & sum of all invoice totals

SELECT SUM(TOTAL) AS INVOICE_TOTAL, BILLING_CITY
FROM INVOICE
GROUP BY BILLING_CITY
ORDER BY INVOICE_TOTAL DESC

Q5 Who is the best customer? The customer who has spent the most money will be declared the best customer. Write a query that returns the person who has spent the most money

SELECT c.customer_id,
       c.first_name,
       c.last_name,
       SUM(i.total) AS total_spent
FROM customer c
JOIN invoice i
ON c.customer_id = i.customer_id
GROUP BY c.customer_id,
         c.first_name,
         c.last_name
ORDER BY total_spent DESC
LIMIT 1;

Q6. Email, first name, last name & genre of all Rock music listeners

SELECT DISTINCT
       c.email,
       c.first_name,
       c.last_name,
       g.name AS genre
FROM customer c
JOIN invoice i
ON c.customer_id = i.customer_id
JOIN invoice_line il
ON i.invoice_id = il.invoice_id
JOIN track t
ON il.track_id = t.track_id
JOIN genre g
ON t.genre_id = g.genre_id
WHERE g.name = 'Rock'
ORDER BY c.email;

Q7. Top 10 Rock bands (artists with most Rock tracks)

SELECT a.artist_id,
       a.name,
       COUNT(*) AS total_tracks
FROM artist a
JOIN album al
ON a.artist_id = al.artist_id
JOIN track t
ON al.album_id = t.album_id
JOIN genre g
ON t.genre_id = g.genre_id
WHERE g.name = 'Rock'
GROUP BY a.artist_id, a.name
ORDER BY total_tracks DESC
LIMIT 10;

Q8. Tracks longer than average song length

SELECT name,
       milliseconds
FROM track
WHERE milliseconds >
(
    SELECT AVG(milliseconds)
    FROM track
)
ORDER BY milliseconds DESC;

Q9. Amount spent by each customer on artists

SELECT
       c.first_name,
       c.last_name,
       a.name AS artist_name,
       SUM(il.unit_price * il.quantity) AS total_spent
FROM customer c
JOIN invoice i
ON c.customer_id = i.customer_id
JOIN invoice_line il
ON i.invoice_id = il.invoice_id
JOIN track t
ON il.track_id = t.track_id
JOIN album al
ON t.album_id = al.album_id
JOIN artist a
ON al.artist_id = a.artist_id
GROUP BY
       c.first_name,
       c.last_name,
       a.name
ORDER BY total_spent DESC;

Q10. Most popular genre for each country

WITH genre_purchases AS
(
    SELECT
        i.billing_country AS country,
        g.name AS genre,
        COUNT(*) AS purchases,
        RANK() OVER
        (
            PARTITION BY i.billing_country
            ORDER BY COUNT(*) DESC
        ) AS rank_no
    FROM invoice i
    JOIN invoice_line il
    ON i.invoice_id = il.invoice_id
    JOIN track t
    ON il.track_id = t.track_id
    JOIN genre g
    ON t.genre_id = g.genre_id
    GROUP BY
        i.billing_country,
        g.name
)
SELECT
    country,
    genre,
    purchases
FROM genre_purchases
WHERE rank_no = 1
ORDER BY country;






