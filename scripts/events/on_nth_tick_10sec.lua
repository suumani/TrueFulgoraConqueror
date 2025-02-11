-- ----------------------------
-- 10秒イベント (180回で次の30分イベント)
-- ----------------------------
local Spawner = require("scripts.core.Spawner")

script.on_nth_tick(600, function()

	-- フルゴララッシュの蓄積キュー実行	
	-- game_print.debug("[debug] on_nth_tick 600")
	
	-- フルゴラが存在しなければ終了
	local fulgora_surface = game.surfaces["fulgora"]
	if fulgora_surface == nil then
		return
	end

	-- 遺跡イベントの実行
	execute_ruins_queue(fulgora_surface)

	-- 生成済みチャンクイベントの実行(生成済み未開拓)
	execute_chunk_queue_no_charted(fulgora_surface)

	-- 生成済みチャンクイベントの実行(開拓済み視界外)
	execute_chunk_queue_no_visible(fulgora_surface)

end)

-- ----------------------------
-- バイターの巣の増加スピードブースト
-- ----------------------------
local function chunk_event_spawn_biter_spawner(surface, queue, total_queue_size)

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
	for i = #queue, -1, #queue - size do 
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
			-- 10％で生成する大きな遺跡処理の呼び出し
			try_fulgoran_ruin_huge(surface, evolution_factor, spawners[math.random(1, #spawners)], storage.fulgora_demolisher_count)
		end
		table.remove(queue, i)
	end
end

-- ----------------------------
-- 自然増殖バイターの巣周辺のデモリッシャー追加イベント
-- ----------------------------
local function chunk_event_spawn_demolisher(surface, queue)

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
				result = try_place_demolisher(surface, evolution_factor, position, storage.fulgora_demolisher_count)
				-- １回デモリッシャーの生成をトライすれば、その時点で終了
				if result == true then
					break
				end
			end
		end
	end
end

-- ----------------------------
-- 生成済みチャンクイベントの実行(生成済み未開拓)
-- ----------------------------
function execute_chunk_queue_no_charted(fulgora_surface)
	-- 自然増殖バイターの巣周辺のデモリッシャー追加イベント
	chunk_event_spawn_demolisher(fulgora_surface, storage.fulgora_no_charted_chunk_queue, storage.fulgora_no_charted_chunk_queue_size)
	-- バイターの巣の増加スピードブースト
	chunk_event_spawn_biter_spawner(fulgora_surface, storage.fulgora_no_charted_chunk_queue, storage.fulgora_no_charted_chunk_queue_size)
end

-- ----------------------------
-- 生成済みチャンクイベントの実行(開拓済み視界外)
-- ----------------------------
function execute_chunk_queue_no_visible(fulgora_surface)
	chunk_event_spawn_demolisher(fulgora_surface, storage.fulgora_no_visible_chunk_queue, storage.fulgora_no_visible_chunk_queue_size)
end

-- ----------------------------
-- 遺跡イベントの実行
-- ----------------------------
function execute_ruins_queue(fulgora_surface)
	-- キューが存在しなければ終了
	if storage.ruins_queue == nil or #storage.ruins_queue == 0 then
		-- game_print.debug("[debug] #storage.ruins_queue, storage.ruins_queue_size = " .. #storage.ruins_queue .. ", " .. storage.ruins_queue_size)
		return
	end

	-- 進化度の取得
	local evolution_factor = game.forces["enemy"].get_evolution_factor(fulgora_surface)
	
	-- 今回の実行数
	local target_count = math.floor((storage.ruins_queue_size or 0) / 180) + 1

	local ruins_queue_size = #storage.ruins_queue

	-- game_print.debug("([debug] ruins_queue_size, ruins_queue_size - target_count) = ( " .. ruins_queue_size .. ", " .. ruins_queue_size - target_count .. ")" )
	for i = ruins_queue_size, ruins_queue_size - target_count, -1 do
		-- 対象がなくなったら終了
		if i < 1 then
			-- game_print.debug("[debug] on_nth_tick 600 finish")
			return
		end

		-- 対象が既になければ除去して終了
		if storage.ruins_queue[i].valid == false then
			table.remove(storage.ruins_queue, i)
		else

			if storage.ruins_queue[i].name == "fulgoran-ruin-vault" then
				-- フルゴラのフルゴラの貯蔵庫の遺構からは30分おきに100%の確率でバイターの巣とワームが3個発生する、発生できない場合はデモリッシャー判定がある
				try_fulgoran_ruin_vault(fulgora_surface, evolution_factor, storage.ruins_queue[i].position, storage.fulgora_demolisher_count)
			elseif storage.ruins_queue[i].name == "fulgoran-ruin-colossal" then
				-- フルゴラの超巨大な遺跡からは30分おき100%の確率でバイターの巣とワームが1個発生する
				try_fulgoran_ruin_colossal(fulgora_surface, evolution_factor, storage.ruins_queue[i].position, storage.fulgora_demolisher_count)
			elseif storage.ruins_queue[i].name == "fulgoran-ruin-huge" then
				-- フルゴラの巨大な遺跡からは30分おき10%の確率でバイターの巣とワームが発生する
				try_fulgoran_ruin_huge(fulgora_surface, evolution_factor, storage.ruins_queue[i].position, storage.fulgora_demolisher_count)
			end
	
			-- 操作終了したら除去
			table.remove(storage.ruins_queue, i)
		end
		
	end
end

-- ----------------------------
-- フルゴラのフルゴラの貯蔵庫の遺構からは30分おきに100%の確率でバイターの巣とワームが3個発生する、発生できない場合はデモリッシャー判定がある
-- ----------------------------
function try_fulgoran_ruin_vault(fulgora_surface, evolution_factor, position, demolisher_count)
	-- game_print.debug("[debug] try_fulgoran_ruin_vault")
	-- 設置が成功すると仮定
	local result = "success"

	for i = 0, 3, 1 do
		if math.random() < 0.5 then
			local result2 = place_spawner_around(fulgora_surface, evolution_factor, position)
			-- 設置が一度でも失敗したら、最終失敗判定
			if result2 == "failed" then
				result = "failed"
			end
		else
			local result2 = place_worm_around(fulgora_surface, evolution_factor, position)
			-- 設置が一度でも失敗したら、最終失敗判定
			if result2 == "failed" then
				result = "failed"
			end
		end
	end

	-- 設置に成功したら終了
	if result == "success" then
		return
	end

	-- デモリッシャー配置
	try_place_demolisher(fulgora_surface, evolution_factor, position, demolisher_count)

end

-- ----------------------------
-- フルゴラの超巨大な遺跡からは30分おき100%の確率でバイターの巣とワームが1個発生する
-- ----------------------------
function try_fulgoran_ruin_colossal(fulgora_surface, evolution_factor, position, demolisher_count)
	-- game_print.debug("[debug] try_fulgoran_ruin_colossal")
	local result = "success"
	if math.random() < 0.5 then
		result = place_spawner_around(fulgora_surface, evolution_factor, position)
	else
		result = place_worm_around(fulgora_surface, evolution_factor, position)
	end

	if(result == "failed") then
		-- デモリッシャー配置トライ(スポナー10個でデモリッシャー発生)
			try_place_demolisher(fulgora_surface, evolution_factor, position, demolisher_count)
	end
end

-- ----------------------------
-- フルゴラの巨大な遺跡からは30分おき10%の確率でバイターの巣とワームが発生する
-- ----------------------------
function try_fulgoran_ruin_huge(fulgora_surface, evolution_factor, position, demolisher_count)
	-- game_print.debug("[debug] try_fulgoran_ruin_huge")

	-- 90%の確率で終了
	if math.random() < 0.9 then
		return
	end

	local result = "success"
	if math.random() < 0.5 then
		result = place_spawner_around(fulgora_surface, evolution_factor, position)
	else
		result = place_worm_around(fulgora_surface, evolution_factor, position)
	end

	if(result == "failed") then
		-- デモリッシャー配置トライ(スポナー10個でデモリッシャー発生)
		try_place_demolisher(fulgora_surface, evolution_factor, position, demolisher_count)
	end
end

-- ----------------------------
-- デモリッシャー配置トライ(スポナー＊0.8＋ワーム*0.5) * (1 + evolution_factor * 0.5)＞10でデモリッシャー発生可
-- ----------------------------
function try_place_demolisher(fulgora_surface, evolution_factor, center_position, demolisher_count)
	-- デモリッシャーがマップに多すぎで終了
	if demolisher_count > 200 then
		return
	end

	-- デモリッシャーが近くに3匹以上居たら終了
	local nearby_demolishers = fulgora_surface.find_entities_filtered{
		force = "enemy", 
		name = {"small-demolisher","medium-demolisher","big-demolisher"},
		area = {{center_position.x - 100, center_position.y - 100}, {center_position.x + 100, center_position.y + 100}}
	}
	if #nearby_demolishers > 2 then
		return false
	end

	-- デモリッシャー発生条件未達成で終了
	local spawners = fulgora_surface.find_entities_filtered{
		name = {"biter-spawner", "spitter-spawner"},
		area = {{center_position.x - 20, center_position.y - 20}, {center_position.x + 20, center_position.y + 20}}
	}
	local worms = fulgora_surface.find_entities_filtered{
		name = {CONST_ENTITY_NAME.SMALL_WORM, CONST_ENTITY_NAME.MEDIUM_WORM, CONST_ENTITY_NAME.BIG_WORM, CONST_ENTITY_NAME.BEHEMOTH_WORM},
		area = {{center_position.x - 20, center_position.y - 20}, {center_position.x + 20, center_position.y + 20}}
	}
	if ((#spawners * 0.8 + #worms * 0.5) * (1 + evolution_factor * 0.5)) < 10 then
		return false
	end
	
	-- チャンク未生成は終了
	-- if fulgora_surface.is_chunk_generated({x = math.floor(center_position.x / 32), y = math.floor(center_position.y / 32)}) == false then
	-- 	return
	-- end
	-- チャンク未生成も強制作成（+32チャンク以上は削除処理)

	game_print.debug("[fulgora] demolishers = " .. demolisher_count)
	game.print({"item-description.demolisher-spawn"})
	game_print.debug("at (x, y) = (" .. center_position.x .. ", " .. center_position.y .. ")")

	fulgora_surface.create_entity{name = demolisher_name(evolution_factor), position = center_position, quality = choose_quality(evolution_factor),force = "enemy"}
	return true
end

-- ----------------------------
-- デモリッシャーのサイズ決定
-- ----------------------------
function demolisher_name(evolution_factor)
	local r = math.random()
	-- 進化0.3未満
	if evolution_factor < 0.3 then
		return "small-demolisher"
	-- 進化0.5未満
	elseif evolution_factor < 0.4 then
		if r < 0.95 then
			return "small-demolisher"
		else
			return "medium-demolisher"
		end
	elseif evolution_factor < 0.5 then
		if r < 0.9 then
			return "small-demolisher"
		else
			return "medium-demolisher"
		end
	elseif evolution_factor < 0.6 then
		if r < 0.85 then
			return "small-demolisher"
		else
			return "medium-demolisher"
		end
	elseif evolution_factor < 0.7 then
		if r < 0.80 then
			return "small-demolisher"
		elseif r < 0.98 then
			return "medium-demolisher"
		else
			return "big-demolisher"
		end
	elseif evolution_factor < 0.8 then
		if r < 0.75 then
			return "small-demolisher"
		elseif r < 0.96 then
			return "medium-demolisher"
		else
			return "big-demolisher"
		end
	elseif evolution_factor < 0.9 then
		if r < 0.7 then
			return "small-demolisher"
		elseif r < 0.94 then
			return "medium-demolisher"
		else
			return "big-demolisher"
		end
	elseif evolution_factor < 0.95 then
		if r < 0.65 then
			return "small-demolisher"
		elseif r < 0.92 then
			return "medium-demolisher"
		else
			return "big-demolisher"
		end
	elseif evolution_factor < 0.98 then
		if r < 0.6 then
			return "small-demolisher"
		elseif r < 0.9 then
			return "medium-demolisher"
		else
			return "big-demolisher"
		end
	else
		if r < 0.55 then
			return "small-demolisher"
		elseif r < 0.8 then
			return "medium-demolisher"
		else
			return "big-demolisher"
		end
	end
end

-- ----------------------------
-- 周辺座標にバイターかスピッターの巣を配置する
-- ----------------------------
function place_spawner_around(fulgora_surface, evolution_factor, center_position)
	local spawn_position = {x = center_position.x + math.random(-20, 20), y = center_position.y + math.random(-20, 20)}

	-- チャンク未生成は終了
	if fulgora_surface.is_chunk_generated({x = math.floor(spawn_position.x / 32), y = math.floor(spawn_position.y / 32)}) == false then
		return "failed"
	end

	if fulgora_surface.can_place_entity{name = "spitter-spawner", position = spawn_position} then
		place_spawner(fulgora_surface, evolution_factor, spawn_position)
		return "success"
	else 
		return "failed"
	end
end

-- ----------------------------
-- 周辺座標にワームを配置する
-- ----------------------------
function place_worm_around(fulgora_surface, evolution_factor, center_position)
	local spawn_position = {x = center_position.x + math.random(-20, 20), y = center_position.y + math.random(-20, 20)}

	-- チャンク未生成は終了
	if fulgora_surface.is_chunk_generated({x = math.floor(spawn_position.x / 32), y = math.floor(spawn_position.y / 32)}) == false then
		return "failed"
	end

	local name = get_current_worm_size(evolution_factor)
	if fulgora_surface.can_place_entity{name = name, position = spawn_position} then
		place_worm(fulgora_surface, evolution_factor, name, spawn_position)
		return "success"
	else 
		return "failed"
	end
end

-- ----------------------------
-- ワームサイズの決定
-- ----------------------------
function get_current_worm_size(evolution_factor)
	local r = math.random()
	if evolution_factor < 0.2 then -- small worm 100%
		return CONST_ENTITY_NAME.SMALL_WORM
	elseif evolution_factor < 0.5 then -- small 70% medium 30%
		if r < 0.7 then
			return CONST_ENTITY_NAME.SMALL_WORM
		else
			return CONST_ENTITY_NAME.MEDIUM_WORM
		end
	elseif evolution_factor < 0.9 then -- small 10% medium 50% big 40%
		if r < 0.1 then
			return CONST_ENTITY_NAME.SMALL_WORM
		elseif r < 0.6 then
			return CONST_ENTITY_NAME.MEDIUM_WORM
		else
			return CONST_ENTITY_NAME.BIG_WORM
		end
	elseif evolution_factor < 0.98 then -- small 0% medium 40% big 30% behemoth 30%
		if r < 0.4 then
			return CONST_ENTITY_NAME.MEDIUM_WORM
		elseif r < 0.5 then
			return CONST_ENTITY_NAME.BIG_WORM
		else
			return CONST_ENTITY_NAME.BEHEMOTH_WORM
		end
	else -- small 0% medium 20% big 40% behemoth 40%
		if r < 0.2 then
			return CONST_ENTITY_NAME.MEDIUM_WORM
		elseif r < 0.6 then
			return CONST_ENTITY_NAME.BIG_WORM
		else
			return CONST_ENTITY_NAME.BEHEMOTH_WORM
		end
	end
end

-- ----------------------------
-- 周辺座標にワームを配置する
-- ----------------------------
function place_worm(fulgora_surface, evolution_factor, name, spawn_position)
	local quality = choose_quality(evolution_factor)
	fulgora_surface.create_entity{name = name, position = spawn_position, quality = quality, force = "enemy"}
end

-- ----------------------------
-- 指定座標にバイターかスピッターの巣を配置する
-- ----------------------------
function place_spawner(fulgora_surface, evolution_factor, spawn_position)
	local quality = choose_quality(evolution_factor)
	local r = math.random()
	if(r < 0.5) then
		fulgora_surface.create_entity{name = "biter-spawner", position = spawn_position, quality = quality, force = "enemy"}
	else
		fulgora_surface.create_entity{name = "spitter-spawner", position = spawn_position, quality = quality, force = "enemy"}
	end
end
