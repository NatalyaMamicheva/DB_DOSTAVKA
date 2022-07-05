/* Используем Базу данных dostavka */
USE dostavka;


/* Представления */

/* Показать цену, которая выше средней стоимости заказов */
CREATE OR REPLACE VIEW price AS
SELECT summa as 'Цена, которая выше средней стоимости заказов'
FROM orders
WHERE summa > (SELECT AVG(summa) FROM orders);

/* Показать как оплачивались заказы (наличные/онлайн/карта) */
CREATE OR REPLACE VIEW oplata AS 
SELECT oplata_zakaza.oplata 
FROM orders, oplata_zakaza
WHERE orders.oplata_id = oplata_zakaza.id;