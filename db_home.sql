CREATE DATABASE home;
USE home;
CREATE TABLE users(
id INT,
created_at DATETIME,
name VARCHAR(225),
city VARCHAR(225),
PRIMARY kEY(id));

CREATE TABLE skus(
id INT,
price FLOAT,
category VARCHAR(225),
PRIMARY KEY(id));

CREATE TABLE purchases(
id INT,
created_at DATETIME,
user_id INT,
sku_id INT,
PRIMARY KEY(id),
FOREIGN KEY(user_id) REFERENCES users(id),
FOREIGN KEY(sku_id) REFERENCES skus(id));

INSERT INTO users(id, created_at, name, city)
VALUES (1, '2021-11-01 13:30:00', 'Andrew', 'Moscow');

INSERT INTO users(id, created_at, name, city)
VALUES (2, '2021-11-02 14:30:00', 'Alla', 'Moscow');

INSERT INTO users(id, created_at, name, city)
VALUES (3, '2021-11-02 17:00:00', 'Boris', 'Novosibisk');

INSERT INTO users(id, created_at, name, city)
VALUES (4, '2021-12-01 13:30:00', 'Oleg', 'Moscow');

INSERT INTO users(id, created_at, name, city)
VALUES (5, '2021-12-01 12:10:00', 'Denis', 'Novosibisk');

SELECT EXTRACT(YEAR_MONTH, created_at) FROM users
WHERE EXTRACT(YEAR_MONTH, created-at) = november;

SELECT COUNT(*) FROM users
WHERE
created_at >= '2021-11-02 00:00:00' AND
created_at <= '2021-11-02 23:59:59';

INSERT INTO skus(id, price, category)
VALUES (1, 33900.0, 'tv');

INSERT INTO skus(id, price, category)
VALUES (2, 15400.0, 'phone');

INSERT INTO skus(id, price, category)
VALUES (3, 1590.0, 'audio');

SELECT * FROM skus;

INSERT INTO purchases(id, created_at, user_id, sku_id)
VALUES (1, '2021-11-10 12:00:00', 3, 1)

INSERT INTO purchases(id, created_at, user_id, sku_id)
VALUES (2, '2021-11-10 13:00:00', 4, 1)

SELECT COUNT(*) FROM purchases
WHERE
created_at >= '2021-11-10 00:00:00' AND
created_at <= '2021-11-10 23:59:59' AND
sku_id = 1;

INSERT INTO purchases(id, created_at, user_id, sku_id)
VALUES (3, '2021-10-10 13:00:00', 1, 2);

INSERT INTO purchases(id, created_at, user_id, sku_id)
VALUES (4, '2021-10-10 13:00:00', 2, 2);

INSERT INTO purchases(id, created_at, user_id, sku_id)
VALUES (5, '2021-11-10 13:00:00', 4, 2);

INSERT INTO purchases(id, created_at, user_id, sku_id)
VALUES (6, '2021-10-10 14:00:00', 1, 2);

INSERT INTO purchases(id, created_at, user_id, sku_id)
VALUES (7, '2021-10-10 14:00:00', 1, 3);

INSERT INTO purchases(id, created_at, user_id, sku_id)
VALUES (8, '2021-10-10 14:00:00', 1, 1);

INSERT INTO purchases(id, created_at, user_id, sku_id)
VALUES (9, '2021-10-10 14:00:00', 1, 2);

INSERT INTO purchases(id, created_at, user_id, sku_id)
VALUES (10, '2021-10-10 14:00:00', 1, 3);

INSERT INTO purchases(id, created_at, user_id, sku_id)
VALUES (11, '2021-10-12 14:00:00', 4, 3);

INSERT INTO purchases(id, created_at, user_id, sku_id)
VALUES (12, '2021-10-12 14:00:00', 4, 1);

INSERT INTO purchases(id, created_at, user_id, sku_id)
VALUES (13, '2021-10-12 14:00:00', 4, 2);

INSERT INTO purchases(id, created_at, user_id, sku_id)
VALUES (14, '2021-10-12 14:00:00', 4, 3);

INSERT INTO purchases(id, created_at, user_id, sku_id)
VALUES (15, '2021-10-12 14:00:00', 4, 2);

INSERT INTO purchases(id, created_at, user_id, sku_id)
VALUES (16, '2021-10-12 14:00:00', 5, 2);

INSERT INTO purchases(id, created_at, user_id, sku_id)
VALUES (17, '2021-10-12 14:00:00', 5, 3);

INSERT INTO purchases(id, created_at, user_id, sku_id)
VALUES (18, '2021-10-12 14:00:00', 5, 1);

INSERT INTO purchases(id, created_at, user_id, sku_id)
VALUES (19, '2021-10-12 14:00:00', 5, 2);

INSERT INTO purchases(id, created_at, user_id, sku_id)
VALUES (20, '2021-10-12 14:00:00', 5, 1);

INSERT INTO purchases(id, created_at, user_id, sku_id)
VALUES (21, '2021-10-12 14:00:00', 3, 2);

INSERT INTO purchases(id, created_at, user_id, sku_id)
VALUES (24, '2021-10-12 14:00:00', 3, 2);

INSERT INTO purchases(id, created_at, user_id, sku_id)
VALUES (22, '2021-10-12 14:00:00', 3, 2);

INSERT INTO purchases(id, created_at, user_id, sku_id)
VALUES (23, '2021-10-12 14:00:00', 3, 3);


#Рассчитаем среднюю стоимость 5-ой покупки у пользователей в разных городах

(WITH cteshka AS (SELECT city, purchases.id, price, user_id, ROW_NUMBER() OVER(PARTITION BY purchases.user_id) AS rownumber FROM purchases
INNER JOIN skus ON skus.id = purchases.sku_id
INNER JOIN users ON users.id = purchases.user_id WHERE (users.city = 'Moscow')
ORDER BY rownumber) SELECT city, AVG(price) AS avg_price_5th_purchase FROM cteshka WHERE rownumber = 5)
UNION
(WITH cteshka AS (SELECT city, purchases.id, price, user_id, ROW_NUMBER() OVER(PARTITION BY purchases.user_id) AS rownumber FROM purchases
INNER JOIN skus ON skus.id = purchases.sku_id
INNER JOIN users ON users.id = purchases.user_id WHERE (users.city = 'Novosibisk')
ORDER BY rownumber) SELECT city, AVG(price) AS avg_price_5th_purchase FROM cteshka WHERE rownumber = 5);


#Получим число людей из Москвы купило телефоны в октябре и ноябре.

(WITH cte2 AS (SELECT purchases.id, users.city, user_id, sku_id, EXTRACT(MONTH FROM purchases.created_at) AS month FROM purchases
INNER JOIN skus ON skus.id = purchases.sku_id
INNER JOIN users ON users.id = purchases.user_id WHERE users.city = 'Moscow'
HAVING (month= 10) AND (sku_id=2)) SELECT (WITH cte AS (SELECT DISTINCT EXTRACT(MONTH FROM created_at) AS month FROM purchases HAVING month =10) SELECT
(CASE WHEN month = 10 THEN 'october' END) AS month FROM cte) AS month, COUNT(*) AS people FROM cte2)
UNION
(WITH cte2 AS (SELECT purchases.id, users.city, user_id, sku_id, EXTRACT(MONTH FROM purchases.created_at) AS month FROM purchases
INNER JOIN skus ON skus.id = purchases.sku_id
INNER JOIN users ON users.id = purchases.user_id WHERE users.city = 'Moscow'
HAVING (month= 11) AND (sku_id=2)) SELECT (WITH cte AS (SELECT DISTINCT EXTRACT(MONTH FROM created_at) AS month FROM purchases HAVING month =11) SELECT
(CASE WHEN month = 11 THEN 'november' END) AS month FROM cte) AS month, COUNT(*) AS people FROM cte2);


#Число людей купивших товар телефоны 5 октября.

SELECT COUNT(*) FROM purchases WHERE
(sku_id=2) AND
(EXTRACT(MONTH FROM created_at))=10 AND
(EXTRACT(DAY FROM created_at))=10;
