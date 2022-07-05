DROP DATABASE IF EXISTS dostavka;
CREATE DATABASE dostavka;
USE dostavka;

DROP TABLE IF EXISTS card; 
CREATE TABLE card (
	id SERIAL PRIMARY KEY,
   	number_card BIGINT COMMENT 'Номер карты',
   	data_card VARCHAR(100) COMMENT 'Срок действия карты',
   	CVV2 VARCHAR(100) COMMENT '3 цифры на обороте карты'
   
);

INSERT INTO card (number_card, data_card, CVV2) VALUES
  ('4276555566667777', '10/21', '243'),
  ('4276555566667790', '11/22', '421'),
  ('4276555566669999', '10/21', '666'),
  ('4276555566687877', '05/23', '345'),
  ('4276555566660000', '01/22', '216'),
  ('4276555566661111', '07/25', '578');

DROP TABLE IF EXISTS buyer;
CREATE TABLE buyer (
	id SERIAL PRIMARY KEY,
    firstname VARCHAR(100) COMMENT 'Имя покупателя',
    lastname VARCHAR(100) COMMENT 'Фамилия покупателя',
    phone BIGINT UNIQUE COMMENT 'Номер телефона покупателя',
    email VARCHAR(100) UNIQUE COMMENT 'Электронная почта покупателя',
    card_id BIGINT UNSIGNED NOT NULL COMMENT 'Связываем покупателя с картой',
    INDEX buyer_firstname_lastname_idx(firstname, lastname),
   	FOREIGN KEY (card_id) REFERENCES card(id) ON UPDATE CASCADE ON DELETE CASCADE
);

INSERT INTO buyer (firstname, lastname, phone, email, card_id) VALUES
  ('Геннадий', 'Иванов', '89667817683', 'adrienne25@example.org', '1'),
  ('Наталья', 'Петрова', '89690653421', 'reva26@example.net', '2'),
  ('Александр', 'Сидоров', '89654321234', 'ksoorttt@example.net', '3'),
  ('Сергей', 'Королев', '89277312345', 'arielleswift@example.com', '4'),
  ('Иван', 'Кирилов', '89894567216', 'hegmannbroderick@example.net', '5'),
  ('Мария', 'Соловьева', '89043216578', 'nparker@example.org', '6');

DROP TABLE IF EXISTS status_zakaza; 
CREATE TABLE status_zakaza (
	id SERIAL PRIMARY KEY,
   	name VARCHAR(100) COMMENT 'Статус заказа: Оплачено и скоро доставится, Ошибка оплаты, Доставлено',
   	color VARCHAR(100) COMMENT 'Оплачено и скоро доставится - желтый, Ошибка оплаты - красный, Доставлено - зеленый'
);

INSERT INTO status_zakaza (name, color) VALUES
  ('Спасибо за заказ', 'Зеленый'),
  ('Ошибка оплаты заказа','Красный');
 
 
DROP TABLE IF EXISTS positions;
CREATE TABLE positions (
	id SERIAL PRIMARY KEY,
	name VARCHAR(100) COMMENT 'Должность сотрудника'
);

INSERT INTO positions (name) VALUES
  ('Менеджер - самовывоз'),
  ('Доставщик - доставка');
 
DROP TABLE IF EXISTS personal;
CREATE TABLE personal (
	id SERIAL PRIMARY KEY,
    firstname VARCHAR(100) COMMENT 'Имя сотрудника',
    lastname VARCHAR(100) COMMENT 'Фамилия сотрудника',
    phone BIGINT COMMENT 'Номер телефона сотрудника',
    experience VARCHAR(100) COMMENT 'Стаж работы сотрудника',
    post_id BIGINT UNSIGNED NOT NULL COMMENT 'Должность сотрудника',
    FOREIGN KEY (post_id) REFERENCES positions(id) ON UPDATE CASCADE ON DELETE CASCADE,
    INDEX personal_firstname_lastname_experience_idx(firstname, lastname, experience)
);

INSERT INTO personal (firstname, lastname, phone, experience, post_id) VALUES
  ('Ольга', 'Жаркова', '89699453421', '4 года', '1'),
  ('Константин', 'Вольский', '89894107216', '6 лет', '1'),
  ('Марина', 'Васильева', '89043235078', '1 год', '1'),
  ('Георгий', 'Самохвалов', '89664007683', '3 года', '2'),
  ('Андрей', 'Рыжов', '89652309234', '8 лет', '2'),
  ('Владимир', 'Веров', '89277209345', '1 год', '2');


DROP TABLE IF EXISTS product;
CREATE TABLE product (
	id SERIAL PRIMARY KEY,
    name VARCHAR(100) COMMENT 'Название блюда',
    description TEXT COMMENT 'Ингредиенты',
    price BIGINT UNSIGNED NOT NULL COMMENT 'Цена'
);

INSERT INTO product (name, description, price) VALUES
  ('Пицца "Ветчина и сыр"', 'Ветчина, моцарелла, соус альфредо', '400'),
  ('Чизбургер-пицца', 'Мясной соус болоньезе, моцарелла, красный лук, соленые огурчики, томаты, соус бургер', '800'),
  ('Пицца "Сырный цыпленок"', 'Цыпленок, сырный соус, моцарелла, томаты', '380'),
  ('Малиновый молочный коктейль', 'Освежающий напиток с малиновым пюре, молоком и мороженым', '180'),
  ('Блинчики с малиной, 2шт', 'Воздушные блинчики с малиновой начинкой, приготовленные в печи', '129'),
  ('Чизкейк Нью-Йорк', 'Классический американский творожный десерт', '119');

DROP TABLE IF EXISTS point_cafe;
CREATE TABLE point_cafe (
	id SERIAL PRIMARY KEY,
    adress VARCHAR(100) COMMENT 'Адреса кафе для самовывоза или доставки'

);

INSERT INTO point_cafe (adress) VALUES
  ('ул. 1-я Машиностроения, 10'),
  ('ул. Строителей, 18А'),
  ('ул. Победы, 99'),
  ('пр-т Богатырский, 54');


DROP TABLE IF EXISTS oplata_zakaza; 
CREATE TABLE oplata_zakaza (
	id SERIAL PRIMARY KEY,
   	oplata VARCHAR(100) COMMENT 'Оплата картой, онлайн, наличными',
   	status_id BIGINT UNSIGNED NOT NULL COMMENT 'После выбора оплаты переходим к статусу заказа',
   	FOREIGN KEY (status_id) REFERENCES status_zakaza(id) ON UPDATE CASCADE ON DELETE CASCADE
);

INSERT INTO oplata_zakaza (oplata, status_id) VALUES
  ('Онлайн',  '1'),
  ('Онлайн',  '2'),
  ('Наличными', '1'),
  ('Картой', '1');
 
 
DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
	id SERIAL PRIMARY KEY,
	created_at DATETIME DEFAULT NOW() COMMENT 'Время создания заказа',
	buyer_id BIGINT UNSIGNED NOT NULL COMMENT 'Кто сделал заказ',
	point_id BIGINT UNSIGNED NOT NULL COMMENT 'Откуда привезут заказ или откуда можно его забрать',
	summa BIGINT UNSIGNED NOT NULL COMMENT 'Сумма заказа',
    personal_id BIGINT UNSIGNED NOT NULL COMMENT 'Доставщик(при доставке) и менеджер(при самовывозе), который прикреплен к заказу',
    oplata_id BIGINT UNSIGNED NOT NULL COMMENT 'Оплата - наличные/карта/онлайн',
    FOREIGN KEY (buyer_id) REFERENCES buyer(id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (point_id) REFERENCES point_cafe(id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (personal_id) REFERENCES personal(id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (oplata_id) REFERENCES oplata_zakaza(id) ON UPDATE CASCADE ON DELETE CASCADE
    
);

INSERT INTO orders (created_at, buyer_id, point_id, summa, personal_id, oplata_id) VALUES
  (NOW(), '1', '1', '180', '4', '4'),
  (NOW(), '2', '2', '1600', '1', '3'),
  (NOW(), '3', '3', '800', '2', '1'),
  (NOW(), '4', '4', '380', '3', '1'),
  (NOW(), '5', '2', '129', '5', '1'),
  (NOW(), '6', '1', '119', '6', '2');
 
 
DROP TABLE IF EXISTS product_v_zakaze;
CREATE TABLE product_v_zakaze (
orders_id BIGINT UNSIGNED NOT NULL COMMENT 'Из какого заказа блюдо',
product_id BIGINT UNSIGNED NOT NULL COMMENT 'Какое блюдо заказано',
quantity BIGINT UNSIGNED NOT NULL COMMENT 'Количество блюд(продуктов) в заказе',
PRIMARY KEY (orders_id,product_id),
FOREIGN KEY (orders_id) REFERENCES orders(id) ON UPDATE CASCADE ON DELETE CASCADE,
FOREIGN KEY (product_id) REFERENCES product(id) ON UPDATE CASCADE ON DELETE CASCADE

);

INSERT INTO product_v_zakaze (orders_id, product_id, quantity) VALUES
  ('1', '4', '1'),
  ('2', '2', '2'),
  ('3', '1', '2'),
  ('4', '3', '1'),
  ('5', '5', '1'),
  ('6', '6', '1');







