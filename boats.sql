CREATE TABLE IF NOT EXISTS `boats` (
  `id` INT(11) NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `identifier` VARCHAR(50) NOT NULL,
  `charid` INT(11) NOT NULL,
  `name` VARCHAR(100) NOT NULL,
  `model` VARCHAR(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

ALTER TABLE `boats` ADD COLUMN IF NOT EXISTS (`fuel` INT(11) NULL);
ALTER TABLE `boats` ADD COLUMN IF NOT EXISTS (`condition` INT(11) NULL);

INSERT INTO `items` (`item`, `label`, `limit`, `can_remove`, `type`, `usable`, `desc`)
VALUES
  ('portable_canoe', 'Portable Canoe', 1, 1, 'item_standard', 1, 'Bryce Canyon Canoes'),
  ('bcc_coal', 'Coal', 50, 1, 'item_standard', 1, 'Fuel for steam engines.'),
  ('bcc_repair_hammer', 'Repair Hammer', 1, 1, 'item_standard', 1, 'Tool used for repairs.'),
  ('a_c_fishbluegil_01_ms', 'Bluegill (Medium)', 10, 1, 'item_standard', 1, 'A medium-sized Bluegill fish.'),
  ('a_c_fishbluegil_01_sm', 'Bluegill (Small)', 10, 1, 'item_standard', 1, 'A small-sized Bluegill fish.'),
  ('a_c_fishbullheadcat_01_ms', 'Bullhead Catfish (Medium)', 10, 1, 'item_standard', 1, 'A medium-sized Bullhead Catfish.'),
  ('a_c_fishbullheadcat_01_sm', 'Bullhead Catfish (Small)', 10, 1, 'item_standard', 1, 'A small-sized Bullhead Catfish.'),
  ('a_c_fishchainpickerel_01_ms', 'Chain Pickerel (Medium)', 10, 1, 'item_standard', 1, 'A medium-sized Chain Pickerel.'),
  ('a_c_fishchainpickerel_01_sm', 'Chain Pickerel (Small)', 10, 1, 'item_standard', 1, 'A small-sized Chain Pickerel.'),
  ('a_c_fishchannelcatfish_01_lg', 'Channel Catfish (Large)', 10, 1, 'item_standard', 1, 'A large-sized Channel Catfish.'),
  ('a_c_fishchannelcatfish_01_xl', 'Channel Catfish (XL)', 10, 1, 'item_standard', 1, 'An extra-large Channel Catfish.'),
  ('a_c_fishlakesturgeon_01_lg', 'Lake Sturgeon', 10, 1, 'item_standard', 1, 'A large Lake Sturgeon.'),
  ('a_c_fishlargemouthbass_01_lg', 'Largemouth Bass (Large)', 10, 1, 'item_standard', 1, 'A large Largemouth Bass.'),
  ('a_c_fishlargemouthbass_01_ms', 'Largemouth Bass (Medium)', 10, 1, 'item_standard', 1, 'A medium-sized Largemouth Bass.'),
  ('a_c_fishlongnosegar_01_lg', 'Longnose Gar', 10, 1, 'item_standard', 1, 'A large Longnose Gar.'),
  ('a_c_fishmuskie_01_lg', 'Muskie', 10, 1, 'item_standard', 1, 'A large Muskie.'),
  ('a_c_fishnorthernpike_01_lg', 'Northern Pike', 10, 1, 'item_standard', 1, 'A large Northern Pike.'),
  ('a_c_fishperch_01_ms', 'Perch (Medium)', 10, 1, 'item_standard', 1, 'A medium-sized Perch.'),
  ('a_c_fishperch_01_sm', 'Perch (Small)', 10, 1, 'item_standard', 1, 'A small-sized Perch.'),
  ('a_c_fishrainbowtrout_01_lg', 'Rainbow Trout (Large)', 10, 1, 'item_standard', 1, 'A large Rainbow Trout.'),
  ('a_c_fishrainbowtrout_01_ms', 'Rainbow Trout (Medium)', 10, 1, 'item_standard', 1, 'A medium-sized Rainbow Trout.'),
  ('a_c_fishredfinpickerel_01_ms', 'Redfin Pickerel (Medium)', 10, 1, 'item_standard', 1, 'A medium-sized Redfin Pickerel.'),
  ('a_c_fishredfinpickerel_01_sm', 'Redfin Pickerel (Small)', 10, 1, 'item_standard', 1, 'A small-sized Redfin Pickerel.'),
  ('a_c_fishrockbass_01_ms', 'Rock Bass (Medium)', 10, 1, 'item_standard', 1, 'A medium-sized Rock Bass.'),
  ('a_c_fishrockbass_01_sm', 'Rock Bass (Small)', 10, 1, 'item_standard', 1, 'A small-sized Rock Bass.'),
  ('a_c_fishsalmonsockeye_01_lg', 'Sockeye Salmon (Large)', 10, 1, 'item_standard', 1, 'A large Sockeye Salmon.'),
  ('a_c_fishsalmonsockeye_01_ml', 'Sockeye Salmon (Medium-Large)', 10, 1, 'item_standard', 1, 'A medium-large Sockeye Salmon.'),
  ('a_c_fishsalmonsockeye_01_ms', 'Sockeye Salmon (Medium)', 10, 1, 'item_standard', 1, 'A medium-sized Sockeye Salmon.'),
  ('a_c_fishsmallmouthbass_01_lg', 'Smallmouth Bass (Large)', 10, 1, 'item_standard', 1, 'A large Smallmouth Bass.'),
  ('a_c_fishsmallmouthbass_01_ms', 'Smallmouth Bass (Medium)', 10, 1, 'item_standard', 1, 'A medium-sized Smallmouth Bass.')
ON DUPLICATE KEY UPDATE
  `item` = VALUES(`item`),
  `label` = VALUES(`label`),
  `limit` = VALUES(`limit`),
  `can_remove` = VALUES(`can_remove`),
  `type` = VALUES(`type`),
  `usable` = VALUES(`usable`),
  `desc` = VALUES(`desc`);
