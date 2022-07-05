/* Используем Базу данных dostavka */
USE dostavka;

/* Триггеры */


/* При удалении покупателя(отказ от заказа) удаляются и данные о его карте */
DELIMITER //
DROP TRIGGER delete_buyer//
CREATE TRIGGER delete_buyer BEFORE DELETE ON buyer
FOR EACH ROW 
BEGIN
  DELETE FROM card WHERE card_id=OLD.id;
END//
DELIMITER ;

/* При добавлении покупателя(оформление заказа) добавляются и данные о его карте */
DELIMITER $$
DROP TRIGGER update_buyer$$
CREATE TRIGGER update_buyer 
AFTER INSERT ON buyer 
FOR EACH ROW
BEGIN
	INSERT INTO log Set msg = 'insert', card_id = NEW.id; 
END$$
DELIMITER ;