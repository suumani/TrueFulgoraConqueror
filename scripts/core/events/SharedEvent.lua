-- ----------------------------
-- SharedEventの定義
-- file path: scripts/core/events/SharedEvent.lua
-- ----------------------------
local SharedEvent = {}

local Chunk = require("scripts.core.Chunk")
local Spawner = require("scripts.core.Spawner")
local PlaceEntity = require("scripts.core.events.common.PlaceEntity")

-- ----------------------------
-- 自然増殖バイターの巣周辺のデモリッシャー追加イベント
-- ----------------------------
function SharedEvent.chunk_event_spawn_demolisher(surface, queue, fulgora_demolisher_count)

	-- game_print.debug("execute_chunk_queue")
	-- キューが存在しなければ終了
	if queue == nil then return end
	if #queue == 0 then return end

	-- 進化度の取得
	local evolution_factor = game.forces["enemy"].get_evolution_factor(surface)

	-- 生成頻度を、全チャンク走査から、10秒ごとにランダム１チャンクに変更、確率50％→10％、1分0.6個=1時間36個
	-- ただし、バイターの巣が見つからない場合は、最大3回、ランダムチェック
	local target_chunk = queue[math.random(1, #queue)]
	local result = false
	for i = 0, 3, 1 do
		-- 進化度を考慮
		if math.random() < evolution_factor / 10 then
			-- 対象チャンクにバイターの巣があれば、デモリッシャートライ
			local spawners = surface.find_entities_filtered{
				force = "enemy", 
				name = {"biter-spawner", "spitter-spawner"}, 
				area = {
					{x = target_chunk.x * 32, y = target_chunk.y * 32},
					{x = (target_chunk.x + 1) * 32, y = (target_chunk.y + 1) * 32}
				}
			}
			if #spawners ~= 0 then
				local position = spawners[math.random(1, #spawners)].position
				-- デモリッシャー配置トライ
				result = PlaceEntity.try_place_demolisher(surface, evolution_factor, position, fulgora_demolisher_count)
				-- １回デモリッシャーの生成をトライすれば、その時点で終了
				if result == true then
					break
				end
			end
		end
	end
end

-- ----------------------------
-- バイターの巣の増加スピードブースト(注意！queueを直接減少させる)
-- ----------------------------
function SharedEvent.chunk_event_spawn_biter_spawner(
	surface, 
	queue, 
	total_queue_size, 
	fulgora_demolisher_count,
	nocharted)
    -- game_print.debug("SharedEvent.chunk_event_spawn_biter_spawner")
    -- game_print.debug("#queue = " .. #queue)

	-- game_print.debug("execute_chunk_queue")
	-- キューが存在しなければ終了
	if queue == nil then return end
	if #queue == 0 then	return end

	-- スポナーの数
	local cached_spawner_count = Spawner.get_cached_spawner_count(surface)
	local cached_unvisible_chunk_count = Chunk.get_cached_unvisible_chunk_count(surface)

	-- 進化度の取得
	local evolution_factor = game.forces["enemy"].get_evolution_factor(surface)

	local size = math.floor(total_queue_size / 180) + 1

	local rate = 0
	
	-- チャンクあたり平均0.15個を切るなら150% - 50%
	if cached_spawner_count < cached_unvisible_chunk_count * 0.15 then
		rate = 1.5 - evolution_factor
		game_print.debug("spawner, chunk = ".. cached_spawner_count ..", ".. cached_unvisible_chunk_count .. ", nest lower than 0.15, rate = " .. rate)
	-- チャンクあたり平均0.5個を切るなら110% - 10%
	elseif cached_spawner_count < cached_unvisible_chunk_count * 0.5 then
		rate = 1.1 - evolution_factor
		game_print.debug("spawner, chunk = ".. cached_spawner_count ..", ".. cached_unvisible_chunk_count .. ", nest lower than 0.5, rate = " .. rate)
	-- チャンクあたり平均0.75個を切るなら101% - 1%
	elseif cached_spawner_count < cached_unvisible_chunk_count * 0.75 then
		rate = 1.01 - evolution_factor
		game_print.debug("spawner, chunk = ".. cached_spawner_count ..", ".. cached_unvisible_chunk_count .. ", nest lower than 0.75, rate = " .. rate)
	else
		--game_print.debug("spawner, chunk = ".. cached_spawner_count ..", ".. cached_unvisible_chunk_count .. ", nest more than 0.75, rate = " .. rate)
		rate = 0
	end
	for i = #queue, #queue - size, -1 do
		-- 定義外まで進んだら終了
		if i <= 0 then return end
		if rate > math.random() then
			local target_chunk = queue[i]
			-- 対象チャンクにバイターの巣があれば、増殖トライ
			local spawners = surface.find_entities_filtered{
				force = "enemy", 
				name = {"biter-spawner", "spitter-spawner"}, 
				area = {
					{x = target_chunk.x * 32, y = target_chunk.y * 32},
					{x = (target_chunk.x + 1) * 32, y = (target_chunk.y + 1) * 32}
				}
			}

			if #spawners > 0 then
				-- 100％で生成する大きな遺跡処理の呼び出し
				PlaceEntity.try_fulgoran_ruin_colossal(
					surface, 
					evolution_factor, 
					spawners[math.random(1, #spawners)].position, 
					fulgora_demolisher_count)
			end
		end
		table.remove(queue, i)
	end
	-- game_print.debug("#queue = " .. #queue .. ", storage.suumani_tfc[fulgora_no_charted_chunk_queue] = " .. #storage.suumani_tfc["fulgora_no_charted_chunk_queue"])
end

return SharedEvent
