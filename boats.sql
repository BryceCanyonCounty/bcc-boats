CREATE TABLE IF NOT EXISTS `boats` (
  `id` int(11) NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `identifier` VARCHAR(50) NOT NULL,
  `charid` INT(11) NOT NULL,
  `name` VARCHAR(100) NOT NULL,
  `model` VARCHAR(100) NOT NULL,
  `fuel` int(11) NULL,
  `condition` int(11) NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

ALTER TABLE `boats` ADD COLUMN IF NOT EXISTS (`fuel` INT(11) NOT NULL);
ALTER TABLE `boats` ADD COLUMN IF NOT EXISTS (`condition` INT(11) NOT NULL);

INSERT INTO `items`(`item`, `label`, `limit`, `can_remove`, `type`, `usable`, `desc`) VALUES ('portable_canoe', 'Portable Canoe', 1, 1, 'item_standard', 1, 'Bryce Canyon Canoes')
ON DUPLICATE KEY UPDATE `item`='portable_canoe', `label`='Portable Canoe', `limit`=1, `can_remove`=1, `type`='item_standard', `usable`=1, `desc`='Bryce Canyon Canoes';

INSERT INTO `items`(`item`, `label`, `limit`, `can_remove`, `type`, `usable`, `desc`) VALUES ('bagofcoal', 'Bag of Coal', 10, 1, 'item_standard', 1, 'Fuel for steam engines.')
ON DUPLICATE KEY UPDATE `item`='bagofcoal', `label`='Bag of Coal', `limit`=10, `can_remove`=1, `type`='item_standard', `usable`=1, `desc`='Fuel for steam engines.';
