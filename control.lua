-- ----------------------------
-- description: en
-- Concept:
-- There are still creatures living underground...! What will encounters with them bring forth?
-- 
-- Features:
-- ・Biter nests may occasionally spawn from ruins.
-- ・When Biter nests gather in large numbers, Demolishers might crawl out as well.
-- ・The evolution factor starts at 0.
-- ・Pollution does not spread.
-- ----------------------------

-- ----------------------------
-- description: jp
-- コンセプト：
-- 地下にはまだ生物が居たんだ・・・！彼らとの出会いは何を産むのだろうか。
-- 
-- 仕様：
-- ・遺跡からバイターの巣がまれに発生する 
-- ・バイターの巣が群れてくると、デモリッシャーも這い出して来るかもしれない 
-- ・進化係数は0から開始される
-- ・汚染は広がらない
-- ----------------------------

require("defines.constant_entity_name")
require("scripts.common.game_print")
require("scripts.common.util")

require("scripts.events.on_nth_tick_10sec")
require("scripts.events.on_nth_tick_30min")
require("scripts.events.on_player_used_capsule")
require("scripts.events.on_rocket_launched")

require("scripts.events.on_insert_ammo_to_turrets")

game_debug = false

local SaveData = require("scripts.core.SaveData")
