CREATE TABLE IF NOT EXISTS `boats` (
  `id` INT(11) NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `identifier` VARCHAR(50) NOT NULL,
  `charid` INT(11) NOT NULL,
  `name` VARCHAR(100) NOT NULL,
  `model` VARCHAR(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

ALTER TABLE `boats` ADD COLUMN IF NOT EXISTS (`fuel` INT(11) NULL);
ALTER TABLE `boats` ADD COLUMN IF NOT EXISTS (`condition` INT(11) NULL);

INSERT INTO
    `items`(`item`, `label`, `limit`, `can_remove`, `type`, `usable`, `desc`)
VALUES
    ('portable_canoe', 'Portable Canoe', 1, 1, 'item_standard', 1, 'Bryce Canyon Canoes'),
    ('bcc_coal', 'Coal', 50, 1, 'item_standard', 1, 'Fuel for steam engines.'),
    ('bcc_repair_hammer', 'Repair Hammer', 1, 1, 'item_standard', 1, 'Tool used for repairs.')
ON DUPLICATE KEY UPDATE
    `item` = VALUES(`item`),
    `label` = VALUES(`label`),
    `limit` = VALUES(`limit`),
    `can_remove` = VALUES(`can_remove`),
    `type` = VALUES(`type`),
    `usable` = VALUES(`usable`),
    `desc` = VALUES(`desc`);
