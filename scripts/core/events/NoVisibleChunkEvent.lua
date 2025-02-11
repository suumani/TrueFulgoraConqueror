-- ----------------------------
-- NoVisibleChunkEventの定義
-- file path: scripts/core/events/NoVisibleChunkEvent.lua
-- ----------------------------
local NoVisibleChunkEvent = {}

local SharedEvent = require("scripts.core.events.SharedEvent")

-- ----------------------------
-- 生成済みチャンクイベントの実行(開拓済み視界外)
-- ----------------------------
function NoVisibleChunkEvent.execute(fulgora_surface, fulgora_demolisher_count)
	-- バイターの巣の増加スピードブースト(no chartedは制限なし)
	SharedEvent.chunk_event_spawn_biter_spawner(
		fulgora_surface, 
		storage.suumani_tfc["fulgora_no_visible_chunk_queue"], 
		storage.suumani_tfc["fulgora_no_visible_chunk_queue_size"], 
		fulgora_demolisher_count)
    -- 自然増殖バイターの巣周辺のデモリッシャー追加イベント
    SharedEvent.chunk_event_spawn_demolisher(
        fulgora_surface, 
        storage.suumani_tfc["fulgora_no_visible_chunks"], 
        fulgora_demolisher_count)
end

return NoVisibleChunkEvent
