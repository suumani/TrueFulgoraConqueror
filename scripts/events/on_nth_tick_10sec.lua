-- ----------------------------
-- 10秒イベント (180回で次の30分イベント)
-- ----------------------------

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

	-- 生成済みチャンクイベントの実行
	execute_chunk_queue(fulgora_surface)

end)

-- ----------------------------
-- 生成済みチャンクイベントの実行
-- ----------------------------
function execute_chunk_queue(fulgora_surface)

	-- game_print.debug("execute_chunk_queue")
	-- キューが存在しなければ終了
	if storage.fulgora_chunk_queue == nil then
		-- game_print.debug("queue == nil")
		return
	end
	
	if #storage.fulgora_chunk_queue == 0 then
		-- game_print.debug("#storage.fulgora_chunk_queue == 0")
		return
	end

	-- 進化度の取得
	local evolution_factor = game.forces["enemy"].get_evolution_factor(fulgora_surface)
	
	-- 今回の実行数
	local target_count = math.floor((storage.fulgora_chunk_queue_size or 0) / 180) + 1

	local fulgora_chunk_queue_size = #storage.fulgora_chunk_queue

	-- game_print.debug("(fulgora_chunk_queue_size, fulgora_chunk_queue_size - target_count) = " .. fulgora_chunk_queue_size .. ", " .. fulgora_chunk_queue_size - target_count)
	local spawner_add = 0
	for i = fulgora_chunk_queue_size, fulgora_chunk_queue_size - target_count, -1 do
		-- 対象がなくなったら終了
		if i < 1 then
			return
		end

		-- 対象が既になければ除去して終了
		if storage.fulgora_chunk_queue[i].valid == false then
			-- game_print.debug("[debug] storage.fulgora_chunk_queue[i].valid = " .. storage.fulgora_chunk_queue[i].valid)
			table.remove(storage.fulgora_chunk_queue, i)
		else
			-- 進化度を考慮
			if math.random() < evolution_factor / 2 then
				-- 対象チャンクにバイターの巣があれば、バイターの巣の増殖トライ(失敗して条件満たしていたらデモリッシャー)
				local spawners = fulgora_surface.find_entities_filtered{
					force = "enemy", 
					name = {"biter-spawner", "spitter-spawner"}, 
					area = {
						{x = storage.fulgora_chunk_queue[i].x * 32, y = storage.fulgora_chunk_queue[i].y * 32},
						{x = (storage.fulgora_chunk_queue[i].x + 1) * 32, y = (storage.fulgora_chunk_queue[i].y + 1) * 32}
					}
				}
				if #spawners == 0 then
					-- nothing
				else
					local result = "success"
					local position = spawners[math.random(1, #spawners)].position
					if math.random() < 0.5 then
						result = place_spawner_around(fulgora_surface, evolution_factor, position)
					else
						result = place_worm_around(fulgora_surface, evolution_factor, position)
					end
					-- game_print.debug("try result = " .. result)
			
					if result == "failed" then
						-- デモリッシャー配置トライ(スポナー10個でデモリッシャー発生)
						try_place_demolisher(fulgora_surface, evolution_factor, position, storage.fulgora_demolisher_count)
					else
						spawner_add = spawner_add + 1
					end
				end
			end

			-- 操作終了したら除去
			table.remove(storage.fulgora_chunk_queue, i)
		end
	end
	if spawner_add ~= 0 then
		-- game_print.debug("[debug] spawner increase : " .. spawner_add)
	end
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

	-- 検索処理の重さより、生成後処理の重さを重視した
	local d_count = #(fulgora_surface.find_entities_filtered{force = "enemy", name = {"small-demolisher","medium-demolisher","big-demolisher"}})
	if d_count > 200 then
		return
	end
	--[[if demolisher_count > 200 then
		return
	end]]

	-- デモリッシャーが近くに3匹以上居たら終了
	local nearby_demolishers = fulgora_surface.find_entities_filtered{
		force = "enemy", 
		name = {"small-demolisher","medium-demolisher","big-demolisher"},
		area = {{center_position.x - 100, center_position.y - 100}, {center_position.x + 100, center_position.y + 100}}
	}
	if #nearby_demolishers > 2 then
		return
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
		return
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
