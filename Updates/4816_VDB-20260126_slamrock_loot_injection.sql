/* CMaNGOS 1.12 - Slamrock Loot Injection (idempotent)
 *
 * - Injects Slamrock into creature loot via a reference loot template
 * - Scaling: 0.001% (lvl 1) -> 0.1% (lvl 60)
 * - Boss/Rare bonus: flat 10% for rank >= 2
 *
 * Notes:
 * - Uses a fixed reference id to remain stable across re-runs.
 * - Aggregates by lootid safely (MIN(minlevel), MAX(rank)) to avoid non-deterministic GROUP BY.
 */

-- 1) Find Slamrock item entry (created in 4814_* as entry 90000; this keeps it robust if you change the entry later)
SET @SLAMROCK_ITEM := (
  SELECT `entry`
  FROM `item_template`
  WHERE `name` = 'Slamrock'
  ORDER BY `entry` DESC
  LIMIT 1
);

-- 2) Fixed reference id for Slamrock
SET @SLAMROCK_REF := 900000;

-- 3) Create/refresh reference loot entry
DELETE FROM `reference_loot_template` WHERE `entry` = @SLAMROCK_REF;
INSERT INTO `reference_loot_template`
  (`entry`, `item`, `ChanceOrQuestChance`, `groupid`, `mincountOrRef`, `maxcount`, `condition_id`, `comments`)
SELECT
  @SLAMROCK_REF, @SLAMROCK_ITEM, 100, 0, 1, 1, 0, 'Slamrock'
WHERE @SLAMROCK_ITEM IS NOT NULL;

-- Optional: name for tooling that joins reference_loot_template_names
DELETE FROM `reference_loot_template_names` WHERE `entry` = @SLAMROCK_REF;
INSERT INTO `reference_loot_template_names` (`entry`, `name`)
SELECT @SLAMROCK_REF, 'Slamrock'
WHERE @SLAMROCK_ITEM IS NOT NULL;

-- 4) Remove existing creature links for this reference (idempotent)
DELETE FROM `creature_loot_template` WHERE `mincountOrRef` = -@SLAMROCK_REF;

-- 5) Insert per-lootid links with scaling chance
INSERT INTO `creature_loot_template`
  (`entry`, `item`, `ChanceOrQuestChance`, `groupid`, `mincountOrRef`, `maxcount`, `condition_id`, `comments`)
SELECT
  ct.lootid,
  0,
  CASE
    WHEN MAX(ct.rank) >= 2 THEN
      10.0
    ELSE
      LEAST(GREATEST(0.001 + (MIN(ct.minlevel) - 1) * (0.099 / 59), 0.001), 0.1)
  END AS calculated_chance,
  0,
  -@SLAMROCK_REF,
  1,
  0,
  'Slamrock'
FROM `creature_template` ct
WHERE ct.lootid > 0
  AND @SLAMROCK_ITEM IS NOT NULL
GROUP BY ct.lootid;

-- 6) Show what we resolved
SELECT @SLAMROCK_ITEM AS Found_Item_ID, @SLAMROCK_REF AS Ref_ID;


