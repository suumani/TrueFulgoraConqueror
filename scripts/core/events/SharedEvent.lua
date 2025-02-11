-- ----------------------------
-- SharedEventの定義
-- file path: scripts/core/events/SharedEvent.lua
-- ----------------------------
local SharedEvent = {}

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
	fulgora_demolisher_count)

	-- game_print.debug("execute_chunk_queue")
	-- キューが存在しなければ終了
	if queue == nil then return end
	if #queue == 0 then	return end

	-- スポナーの数が5000を超える場合は、終了(負荷対策)
	if Spawner.get_cached_spawner_count() > 5000 then return end

	-- 進化度の取得
	local evolution_factor = game.forces["enemy"].get_evolution_factor(surface)

	local size = math.floor(total_queue_size / 180) + 1

	-- 全チャンク走査、確率10％、通常規模no charted 1000、進化度1.0で期待値100
	for i = #queue, #queue - size, -1 do 
		-- 定義外まで進んだら終了
		if i <= 0 then return end
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
			PlaceEntity.try_fulgoran_ruin_vault(
				surface, 
				evolution_factor, 
				spawners[math.random(1, #spawners)].position, 
				fulgora_demolisher_count)
		end
		table.remove(queue, i)
	end
	-- game_print.debug("#queue = " .. #queue .. ", storage.suumani_tfc[fulgora_no_charted_chunk_queue] = " .. #storage.suumani_tfc["fulgora_no_charted_chunk_queue"])
end

return SharedEvent
