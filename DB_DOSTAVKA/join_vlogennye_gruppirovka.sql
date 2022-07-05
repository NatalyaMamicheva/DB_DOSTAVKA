/* Используем Базу данных dostavka */
USE dostavka;

/* 1)Вложенные запросы */

/* Покупатель с самой большой суммой заказа */
SELECT buy.firstname as `Имя покупателя`, buy.lastname as `Фамилия покупателя`, MAX(summa) as `Сумма заказа`
FROM buyer buy, orders o
WHERE buy.id IN (SELECT buyer_id
               FROM orders
               WHERE summa = (SELECT MAX(summa)
                            FROM orders));
                            
/* Показываем имя, фамилию покупателя и сотрудника, прикрепленного к заказу, а так же указываем Доставка или Самовывоз */
SELECT buy.lastname as 'Имя покупателя', buy.firstname as 'Фамилия покупателя', pers.firstname as 'Имя сотрудника', pers.lastname as 'Фамилия сотрудника', pos.name as 'Доставка/Самовывоз'
FROM buyer buy, personal pers, positions pos
WHERE (buy.id, pers.id, pos.id) IN (SELECT buyer_id, personal_id, post_id
              FROM orders);
              
              
              
/* 2)Группировки */

/* Показать название продукта и его стоимость в порядке возрастания */
SELECT name as 'Наименование блюда', price as 'Цена'
FROM product
GROUP BY price
ORDER BY price;

/* Показать сотрудников со стажем больше 3 лет в порядке убывания */
SELECT firstname as 'Имя сотрудника', lastname as 'Фамилия сотрудника', experience as 'Стаж'
FROM personal
WHERE experience > 3
GROUP BY experience
ORDER BY experience DESC;


/* 3)Join */

/* Показать покупателей и суммы их заказа */
SELECT 
	b.firstname AS 'Имя покупателя',
	b.lastname AS 'Фамилия покупателя',
	o.summa AS 'Сумма заказа покупателя'
FROM
	buyer AS b
JOIN
	orders AS o
ON 
	o.buyer_id = b.id;

/* Показать откуда будет доставлен заказ покупателю или откуда его забрать(в случае самовывоза) */
SELECT 
	pc.adress AS 'Адрес кафе для доставки/самовывоза заказа', b.firstname AS 'Имя покупателя', b.lastname AS 'Фамилия покупателя'
FROM
	point_cafe pc
JOIN
	orders AS o
ON 
	o.point_id = pc.id
JOIN
	buyer AS b
ON 
	o.buyer_id = b.id;