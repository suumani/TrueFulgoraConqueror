-- ----------------------------
-- 30分イベント
-- ----------------------------
script.on_nth_tick(108000, function()
	-- フルゴララッシュの実行
	local fulgora_surface = game.surfaces["fulgora"]
	if fulgora_surface ~= nil then
		local evolution_factor = game.forces["enemy"].get_evolution_factor(fulgora_surface)
		--
		-- game.print("evolution_factor = " .. evolution_factor)
		fulgora_rush(fulgora_surface, evolution_factor)
	end
end)

-- ----------------------------
-- フルゴララッシュ
-- ----------------------------
function fulgora_rush(fulgora_surface, evolution_factor)
	-- デモリッシャーの数
	local demolisher_count = #(fulgora_surface.find_entities_filtered{force = "enemy", name = {"small-demolisher","medium-demolisher","big-demolisher"}})
	
	-- フルゴラのフルゴラの貯蔵庫の遺構からは30分おきに100%の確率でバイターの巣とワームが3個発生する、発生できない場合はデモリッシャー判定がある
	fulgora_rush_vault(fulgora_surface, evolution_factor, demolisher_count)
	
	-- フルゴラの超巨大な遺跡からは30分おき100%の確率でバイターの巣とワームが1個発生する、発生できない場合はデモリッシャー判定がある
	fulgora_rush_colossal(fulgora_surface, evolution_factor, demolisher_count)
	
	-- フルゴラの巨大な遺跡からは30分おき10%の確率でバイターの巣とワームが発生する、発生できない場合はデモリッシャー判定がある
	fulgora_rush_huge(fulgora_surface, evolution_factor, demolisher_count)
	
	-- バイターの巣
	-- local spawners = fulgora_surface.find_entities_filtered{name = "biter-spawner"}
	-- local spitterspawners = fulgora_surface.find_entities_filtered{name = "spitter-spawner"}
	-- game.print("total = " .. (#spawners+#spitterspawners))
end

-- ----------------------------
-- フルゴラのフルゴラの貯蔵庫の遺構からは30分おきに100%の確率でバイターの巣とワームが3個発生する、発生できない場合はデモリッシャー判定がある
-- ----------------------------
function fulgora_rush_vault(fulgora_surface, evolution_factor, demolisher_count)
	local ruins = fulgora_surface.find_entities_filtered{name = "fulgoran-ruin-vault"}
	-- game.print("#vaults = "..#ruins)
	if ruins ~= nil and #ruins ~= 0 then
		for _, ruin in pairs(ruins) do
			local result = "success"
			for i = 0, 3, 1 do
				if math.random() < 0.5 then
					local result2 = place_spawner_around(fulgora_surface, evolution_factor, ruin.position)
					if result2 == "failed" then
						result = "failed"
					end
				else
					local result2 = place_worm_around(fulgora_surface, evolution_factor, ruin.position)
					if result2 == "failed" then
						result = "failed"
					end
				end
			end
			if(result == "failed") then
				-- デモリッシャー配置トライ(スポナー10個でデモリッシャー発生)
				try_place_demolisher(fulgora_surface, evolution_factor, ruin.position, demolisher_count)
			end
		end
	end
end

-- ----------------------------
-- デモリッシャー配置トライ(スポナー10個でデモリッシャー発生)
-- ----------------------------
function try_place_demolisher(fulgora_surface, evolution_factor, center_position, demolisher_count)
	local biter_spawners = fulgora_surface.find_entities_filtered{
		name = "biter-spawner", 
		area = {{center_position.x - 20, center_position.y - 20}, {center_position.x + 20, center_position.y + 20}}
	}
	local spitter_spawners = fulgora_surface.find_entities_filtered{
		name = "spitter-spawner", 
		area = {{center_position.x - 20, center_position.y - 20}, {center_position.x + 20, center_position.y + 20}}
	}
	local spawner_count = #biter_spawners + #spitter_spawners
	if spawner_count >= 10 and demolisher_count < 100 then
		game.print({"item-description.demolisher-spawn"})
		fulgora_surface.create_entity{name = demolisher_name(evolution_factor), position = center_position, quality = choose_quality(evolution_factor),force = "enemy"}
	end
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
	elseif evolution_factor < 0.5 then
		if r < 0.5 then
			return "small-demolisher"
		else
			return "medium-demolisher"
		end
	-- 進化0.9未満
	elseif evolution_factor < 0.9 then
		if r < 0.5 then
			return "medium-demolisher"
		else
			return "big-demolisher"
		end
	-- 進化0.9以上
	else
		return "big-demolisher"
	end
end

-- ----------------------------
-- フルゴラの超巨大な遺跡からは30分おき100%の確率でバイターの巣とワームが1個発生する
-- ----------------------------
function fulgora_rush_colossal(fulgora_surface, evolution_factor, demolisher_count)
	local ruins = fulgora_surface.find_entities_filtered{name = "fulgoran-ruin-colossal"}
	-- game.print("#colossals = "..#ruins)
	if ruins ~= nil and #ruins ~= 0 and math.random() < 0.1 then
		for _, ruin in pairs(ruins) do
			
			if math.random() < 0.5 then
				local result = place_spawner_around(fulgora_surface, evolution_factor, ruin.position)
				if(result == "failed") then
					-- デモリッシャー配置トライ(スポナー10個でデモリッシャー発生)
					try_place_demolisher(fulgora_surface, evolution_factor, ruin.position, demolisher_count)
				end
			else
				local result = place_worm_around(fulgora_surface, evolution_factor, ruin.position)
				if(result == "failed") then
					-- デモリッシャー配置トライ(スポナー10個でデモリッシャー発生)
					try_place_demolisher(fulgora_surface, evolution_factor, ruin.position, demolisher_count)
				end
			end
		end
	end
end

-- ----------------------------
-- フルゴラの巨大な遺跡からは30分おき10%の確率でバイターの巣とワームが発生する
-- ----------------------------
function fulgora_rush_huge(fulgora_surface, evolution_factor, demolisher_count)
	local ruins = fulgora_surface.find_entities_filtered{name = "fulgoran-ruin-huge"}
	-- game.print("#huges = "..#ruins)
	if ruins ~= nil and #ruins ~= 0 then
		for _, ruin in pairs(ruins) do
			if math.random() < 0.5 then
				local result = place_spawner_around(fulgora_surface, evolution_factor, ruin.position)
				if(result == "failed") then
					-- デモリッシャー配置トライ(スポナー10個でデモリッシャー発生)
					try_place_demolisher(fulgora_surface, evolution_factor, ruin.position, demolisher_count)
				end
			else
				local result = place_worm_around(fulgora_surface, evolution_factor, ruin.position)
				if(result == "failed") then
					-- デモリッシャー配置トライ(スポナー10個でデモリッシャー発生)
					try_place_demolisher(fulgora_surface, evolution_factor, ruin.position, demolisher_count)
				end
			end
		end
	end
end

-- ----------------------------
-- 周辺座標にバイターかスピッターの巣を配置する
-- ----------------------------
function place_spawner_around(fulgora_surface, evolution_factor, center_position)
	local spawn_position = {x = center_position.x + math.random(-20, 20), y = center_position.y + math.random(-20, 20)}
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
