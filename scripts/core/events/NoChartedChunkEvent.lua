-- ----------------------------
-- NoChartedChunkEventの定義
-- file path: scripts/core/events/NoChartedChunkEvent.lua
-- ----------------------------
local NoChartedChunkEvent = {}

local SharedEvent = require("scripts.core.events.SharedEvent")

-- ----------------------------
-- 生成済みチャンクイベントの実行(生成済み未開拓)
-- ----------------------------
function NoChartedChunkEvent.execute(fulgora_surface, fulgora_demolisher_count)
    -- game_print.debug("NoChartedChunkEvent.execute")
	-- バイターの巣の増加スピードブースト(no chartedは制限なし)
	local nocharted = true
	SharedEvent.chunk_event_spawn_biter_spawner(
		fulgora_surface, 
		storage.suumani_tfc["fulgora_no_charted_chunk_queue"], 
		storage.suumani_tfc["fulgora_no_charted_chunk_queue_size"], 
		fulgora_demolisher_count, nocharted)
	-- 自然増殖バイターの巣周辺のデモリッシャー追加イベント
	SharedEvent.chunk_event_spawn_demolisher(
		fulgora_surface, 
		storage.suumani_tfc["fulgora_no_charted_chunks"], 
		fulgora_demolisher_count)
end

return NoChartedChunkEvent
