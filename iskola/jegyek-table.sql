CREATE TABLE IF NOT EXISTS `jegyek` (
    `id` INT NOT NULL PRIMARY KEY auto_increment,
    `tantargy_id` INT NOT NULL,
    `jegy` INT,
    `diak` VARCHAR(20),
    `tanar` VARCHAR(20),
    `beirva` DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT `fk_tantargy_id`
        FOREIGN KEY (`tantargy_id`)
        REFERENCES `tantargyak` (`id`)
);