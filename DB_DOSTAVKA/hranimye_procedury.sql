/* Используем Базу данных dostavka */
USE dostavka;


/* Хранимые процедуры */

/* Показать сумму всех заказов */

DELIMITER $$
DROP PROCEDURE my_procedura_summa$$
CREATE PROCEDURE my_procedura_summa()
BEGIN         
SELECT SUM(summa) FROM orders;   
END$$

CALL my_procedura_summa();


/* Показать максимальное количество блюд, которые были в заказе покупателей */
DELIMITER $$
DROP PROCEDURE my_procedura_quantity$$
CREATE PROCEDURE my_procedura_quantity()
BEGIN         
SELECT MAX(quantity) FROM product_v_zakaze;   
END$$

CALL my_procedura_quantity();