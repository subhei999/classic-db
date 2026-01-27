-- Set min_ilvl for all SPELL group_keys based on the +X value in description
-- Extracts numeric value after '+' sign and sets min_ilvl to that value (1:1 ratio)
-- Example: "Increase Spell Damage +54" → min_ilvl = 54
-- Example: "Increases Healing +2" → min_ilvl = 2
-- Example: "+1 Arcane Spell Damage" → min_ilvl = 1
-- Example: "Healing and Spell Damage +13/Intellect +15" → min_ilvl = 13

UPDATE `slamrock_enchant_whitelist`
SET `min_ilvl` = CAST(
    SUBSTRING_INDEX(
        SUBSTRING_INDEX(
            SUBSTRING(`description`, LOCATE('+', `description`) + 1),
            '/',
            1
        ),
        ' ',
        1
    ) AS UNSIGNED
)
WHERE UPPER(`group_key`) LIKE '%SPELL%'
  AND `description` LIKE '%+%'
  AND LOCATE('+', `description`) > 0;

-- Adjust SPELL_HEALING: divide min_ilvl by 2 because healing is weaker than spell damage
-- Example: "+20 Healing" → min_ilvl = 20 → adjusted to min_ilvl = 10
UPDATE `slamrock_enchant_whitelist`
SET `min_ilvl` = FLOOR(`min_ilvl` / 2)
WHERE `group_key` = 'SPELL_HEALING'
  AND `min_ilvl` > 0;
