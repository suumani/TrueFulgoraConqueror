-- ----------------------------
-- 10秒イベント (180回で次の30分イベント)
-- ----------------------------
local Spawner = require("scripts.core.Spawner")
local Demolisher = require("scripts.core.Demolisher")
local SuumaniTfcEvent = require("scripts.core.SuumaniTfcEvent")

script.on_nth_tick(600, function()

	-- フルゴラが存在しなければ終了
	local fulgora_surface = game.surfaces["fulgora"]
	if fulgora_surface == nil then
		return
	end

	-- キャッシュされたデモリッシャー数の取得
	local fulgora_demolisher_count = Demolisher.count_demolishers_now(fulgora_surface)

	-- 遺跡イベントの実行
	SuumaniTfcEvent.RuinsEvent.execute(fulgora_surface, fulgora_demolisher_count)

	-- 生成済みチャンクイベントの実行(生成済み未開拓)
	SuumaniTfcEvent.NoChartedChunkEvent.execute(fulgora_surface, fulgora_demolisher_count)

	-- 生成済みチャンクイベントの実行(開拓済み視界外)
	SuumaniTfcEvent.NoVisibleChunkEvent.execute(fulgora_surface, fulgora_demolisher_count)

end)
