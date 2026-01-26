-- Slamrock (POC)
-- Adds a new consumable-like item that can be used on gear.
-- Client targeting is provided by spellid_1=2828 (Sharpening Stone style item-target spell; avoids enchanting rod requirements).
-- Server-side behavior is handled by ScriptDevAI ScriptName='item_slamrock' (consumes item + applies +1 STR enchant).

DELETE FROM `item_template` WHERE `entry` = 90001;

INSERT INTO `item_template` (
  `entry`, `class`, `subclass`, `name`, `displayid`, `Quality`,
  `ItemLevel`, `RequiredLevel`, `stackable`,
  `spellid_1`, `spelltrigger_1`, `spellcharges_1`,
  `ScriptName`
) VALUES (
  90001, 0, 0, 'Slamrock', 0, 1,
  1, 1, 20,
  2828, 0, 0,
  'item_slamrock'
);


