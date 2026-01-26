-- Slamrock (POC)
-- Hijack Rough Sharpening Stone to use ScriptDevAI item_slamrock.
-- This lets us test against a known-working item/targeting spell.

UPDATE `item_template`
SET `ScriptName` = 'item_slamrock'
WHERE `entry` = 2862;


