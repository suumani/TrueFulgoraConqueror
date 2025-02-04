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
require("scripts.common.choose_quality")
require("scripts.common.game_print")
require("scripts.events.on_nth_tick_10sec")
require("scripts.events.on_nth_tick_30min")
require("scripts.events.on_player_used_capsule")
require("scripts.events.on_rocket_launched")

require("scripts.events.on_insert_ammo_to_turrets")

game_debug = true

-- ----------------------------
-- 開始
-- ----------------------------
script.on_init(function()
	init()
end)

-- ----------------------------
-- ロード
-- ----------------------------
script.on_load(function()
end)

-- ----------------------------
-- 構成変更
-- ----------------------------
script.on_configuration_changed(function(event)
	init()
end)

-- ----------------------------
-- 初期化
-- ----------------------------
function init()
	storage = storage or {}

    storage.ruins_queue = storage.ruins_queue or {}
    storage.ruins_queue_size = storage.ruins_queue_size or 0
    storage.fulgora_demolisher_count = storage.fulgora_demolisher_count or 0

	storage.fulgora_chunk_queue = storage.fulgora_chunk_queue or {}
	storage.fulgora_chunk_queue_size = storage.fulgora_chunk_queue_size or 0

    storage.latest_fulgora_rocket_histories = storage.latest_fulgora_rocket_histories or {}
end