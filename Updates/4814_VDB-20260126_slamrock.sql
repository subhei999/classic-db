/* CMaNGOS 1.12 - Slamrock (Spell + Item + Loot) (idempotent)
 *
 * 1) Creates custom targeting spell in `spell_template` (33394)
 * 2) Creates Slamrock item in `item_template` (90001) using that spell and ScriptName='item_slamrock'
 * 3) Injects Slamrock into creature loot via `reference_loot_template` (900000)
 *
 * Drop chances:
 * - Normal mobs (rank = 1): 1%
 * - Raid bosses (rank >= 2 AND MinLevel >= 62): 100%
 * - Rank 2 bosses below level 62: 10% (lvl 1) -> 50% (lvl 61)
 * - Rank 4 rares below level 62: 2x rank 2 formula (20% lvl 1 -> 100% lvl 61, capped at 100%)
 */

-- 0) Constants
SET @SLAMROCK_SPELL := 33394;
SET @SLAMROCK_ITEM  := 90001;
SET @SLAMROCK_REF   := 900000;

-- 1) Create/refresh the Slamrock targeting spell
DELETE FROM `spell_template` WHERE `Id` = @SLAMROCK_SPELL;

INSERT INTO `spell_template` (`Id`, `School`, `Category`, `CastUI`, `Dispel`, `Mechanic`, `Attributes`, `AttributesEx`, `AttributesEx2`, `AttributesEx3`, `AttributesEx4`, `Stances`, `StancesNot`, `Targets`, `TargetCreatureType`, `RequiresSpellFocus`, `CasterAuraState`, `TargetAuraState`, `CastingTimeIndex`, `RecoveryTime`, `CategoryRecoveryTime`, `InterruptFlags`, `AuraInterruptFlags`, `ChannelInterruptFlags`, `ProcFlags`, `ProcChance`, `ProcCharges`, `MaxLevel`, `BaseLevel`, `SpellLevel`, `DurationIndex`, `PowerType`, `ManaCost`, `ManaCostPerlevel`, `ManaPerSecond`, `ManaPerSecondPerLevel`, `RangeIndex`, `Speed`, `ModalNextSpell`, `StackAmount`, `Totem1`, `Totem2`, `Reagent1`, `Reagent2`, `Reagent3`, `Reagent4`, `Reagent5`, `Reagent6`, `Reagent7`, `Reagent8`, `ReagentCount1`, `ReagentCount2`, `ReagentCount3`, `ReagentCount4`, `ReagentCount5`, `ReagentCount6`, `ReagentCount7`, `ReagentCount8`, `EquippedItemClass`, `EquippedItemSubClassMask`, `EquippedItemInventoryTypeMask`, `Effect1`, `Effect2`, `Effect3`, `EffectDieSides1`, `EffectDieSides2`, `EffectDieSides3`, `EffectBaseDice1`, `EffectBaseDice2`, `EffectBaseDice3`, `EffectDicePerLevel1`, `EffectDicePerLevel2`, `EffectDicePerLevel3`, `EffectRealPointsPerLevel1`, `EffectRealPointsPerLevel2`, `EffectRealPointsPerLevel3`, `EffectBasePoints1`, `EffectBasePoints2`, `EffectBasePoints3`, `EffectMechanic1`, `EffectMechanic2`, `EffectMechanic3`, `EffectImplicitTargetA1`, `EffectImplicitTargetA2`, `EffectImplicitTargetA3`, `EffectImplicitTargetB1`, `EffectImplicitTargetB2`, `EffectImplicitTargetB3`, `EffectRadiusIndex1`, `EffectRadiusIndex2`, `EffectRadiusIndex3`, `EffectApplyAuraName1`, `EffectApplyAuraName2`, `EffectApplyAuraName3`, `EffectAmplitude1`, `EffectAmplitude2`, `EffectAmplitude3`, `EffectMultipleValue1`, `EffectMultipleValue2`, `EffectMultipleValue3`, `EffectChainTarget1`, `EffectChainTarget2`, `EffectChainTarget3`, `EffectItemType1`, `EffectItemType2`, `EffectItemType3`, `EffectMiscValue1`, `EffectMiscValue2`, `EffectMiscValue3`, `EffectTriggerSpell1`, `EffectTriggerSpell2`, `EffectTriggerSpell3`, `EffectPointsPerComboPoint1`, `EffectPointsPerComboPoint2`, `EffectPointsPerComboPoint3`, `SpellVisual`, `SpellIconID`, `ActiveIconID`, `SpellPriority`, `SpellName`, `SpellName2`, `SpellName3`, `SpellName4`, `SpellName5`, `SpellName6`, `SpellName7`, `SpellName8`, `Rank1`, `Rank2`, `Rank3`, `Rank4`, `Rank5`, `Rank6`, `Rank7`, `Rank8`, `ManaCostPercentage`, `StartRecoveryCategory`, `StartRecoveryTime`, `MaxTargetLevel`, `SpellFamilyName`, `SpellFamilyFlags`, `MaxAffectedTargets`, `DmgClass`, `PreventionType`, `StanceBarOrder`, `DmgMultiplier1`, `DmgMultiplier2`, `DmgMultiplier3`, `MinFactionId`, `MinReputation`, `RequiredAuraVision`, `EffectBonusCoefficient1`, `EffectBonusCoefficient2`, `EffectBonusCoefficient3`, `EffectBonusCoefficientFromAP1`, `EffectBonusCoefficientFromAP2`, `EffectBonusCoefficientFromAP3`, `IsServerSide`, `AttributesServerside`) VALUES (33394, 0, 0, 0, 0, 0, 262144, 0, 0, 0, 0, 0, 0, 16, 0, 0, 0, 0, 14, 0, 0, 15, 0, 0, 0, 101, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1799, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 40, 0, 0, 0, 0, 0, 0, 0, 0, 3324, 1, 0, 0, 'Slam Item', '', '', '', '', '', '', '', 'Rank 1', '', '', '', '', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

-- 2) Create/refresh the Slamrock item
DELETE FROM `item_template` WHERE `entry` = @SLAMROCK_ITEM;
INSERT INTO `item_template` (
  `entry`, `class`, `subclass`, `name`, `displayid`, `Quality`,`Flags`,
  `ItemLevel`, `RequiredLevel`, `stackable`,
  `spellid_1`, `spelltrigger_1`, `spellcharges_1`,
  `bonding`,
  `ScriptName`
) VALUES (
  @SLAMROCK_ITEM, 0, 0, 'Slamrock', 38285, 4, 64,
  100, 1, 20,
  @SLAMROCK_SPELL, 0, 0,
  1, -- BIND_WHEN_PICKED_UP (BoP)
  'item_slamrock'
);

-- 3) Create/refresh reference loot entry
DELETE FROM `reference_loot_template` WHERE `entry` = @SLAMROCK_REF;
INSERT INTO `reference_loot_template`
  (`entry`, `item`, `ChanceOrQuestChance`, `groupid`, `mincountOrRef`, `maxcount`, `condition_id`, `comments`)
VALUES
  (@SLAMROCK_REF, @SLAMROCK_ITEM, 100, 0, 1, 1, 0, 'Slamrock');

-- Optional: name for tooling that joins reference_loot_template_names
DELETE FROM `reference_loot_template_names` WHERE `entry` = @SLAMROCK_REF;
INSERT INTO `reference_loot_template_names` (`entry`, `name`) VALUES (@SLAMROCK_REF, 'Slamrock');

-- 4) Remove existing creature links for this reference (idempotent)
DELETE FROM `creature_loot_template` WHERE `mincountOrRef` = -@SLAMROCK_REF;

-- 5) Insert per-lootid links with scaling chance
INSERT INTO `creature_loot_template`
  (`entry`, `item`, `ChanceOrQuestChance`, `groupid`, `mincountOrRef`, `maxcount`, `condition_id`, `comments`)
SELECT
  ct.lootid,
  0,
  CASE
    -- Raid bosses (rank >= 2 AND MinLevel >= 62): 100%
    WHEN MAX(ct.rank) >= 2 AND MIN(ct.minlevel) >= 62 THEN
      100.0
    -- Rank 2 bosses below level 62: 10% (lvl 1) -> 50% (lvl 61)
    WHEN MAX(ct.rank) = 2 THEN
      LEAST(GREATEST(10.0 + (MIN(ct.minlevel) - 1) * (40.0 / 61.0), 10.0), 50.0)
    -- Rank 4 rares below level 62: 2x rank 2 formula (20% lvl 1 -> 100% lvl 61, capped at 100%)
    WHEN MAX(ct.rank) = 4 THEN
      LEAST((10.0 + (MIN(ct.minlevel) - 1) * (40.0 / 61.0)) * 2.0, 100.0)
    -- Normal mobs: 1%
    ELSE
      1.0
  END AS calculated_chance,
  0,
  -@SLAMROCK_REF,
  1,
  0,
  'Slamrock'
FROM `creature_template` ct
WHERE ct.lootid > 0
GROUP BY ct.lootid;

-- 6) Show what we resolved
SELECT @SLAMROCK_SPELL AS Slamrock_Spell_ID, @SLAMROCK_ITEM AS Slamrock_Item_ID, @SLAMROCK_REF AS Slamrock_Ref_ID;


