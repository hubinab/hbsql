CREATE USER IF NOT EXISTS 'Ilona'@'localhost' IDENTIFIED BY 'Ilona';
CREATE USER IF NOT EXISTS 'Laci'@'localhost' IDENTIFIED BY 'Laci';

CREATE USER IF NOT EXISTS 'Dani'@'localhost' IDENTIFIED BY 'Dani';
CREATE USER IF NOT EXISTS 'Juci'@'localhost' IDENTIFIED BY 'Juci';
CREATE USER IF NOT EXISTS 'Kati'@'localhost' IDENTIFIED BY 'Kati';
CREATE USER IF NOT EXISTS 'Marci'@'localhost' IDENTIFIED BY 'Marci';

CREATE USER IF NOT EXISTS 'Admin'@'localhost' IDENTIFIED BY 'Admin';

GRANT SELECT, UPDATE, INSERT, DELETE ON `iskola`.`jegyek` TO 'Ilona'@'localhost';
GRANT SELECT, UPDATE, INSERT, DELETE ON `iskola`.`jegyek` TO 'Laci'@'localhost';

GRANT SELECT ON `iskola`.`jegyeim` TO 'Dani'@'localhost';
GRANT SELECT ON `iskola`.`jegyeim` TO 'Juci'@'localhost';
GRANT SELECT ON `iskola`.`jegyeim` TO 'Kati'@'localhost';
GRANT SELECT ON `iskola`.`jegyeim` TO 'Marci'@'localhost';

GRANT ALL PRIVILEGES ON `iskola`.* TO 'Admin'@'localhost';