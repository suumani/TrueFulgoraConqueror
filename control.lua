-- ----------------------------
-- フルゴラの巨大な遺跡からは、たまにバイターの巣やデモリッシャーが発生する
-- ----------------------------

-- ----------------------------
-- タイマーイベント
-- ----------------------------
script.on_event(defines.events.on_tick, function(event)

	-- フルゴララッシュの実行
	-- if(game.tick % 3600 == 0) then --1分
	if(game.tick % 108000 == 0) then --30分
		local fulgora_surface = game.surfaces["fulgora"]
		if fulgora_surface ~= nil then
			local evolution_factor = game.forces["enemy"].get_evolution_factor(fulgora_surface)
			fulgora_rush(fulgora_surface, evolution_factor)
		end
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
				local result2 = place_spawner_around(fulgora_surface, evolution_factor, ruin.position)
				if result2 == "failed" then
					result = "failed"
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
		game.print("Demolishers have emerged from the depths beneath Fulgora...")
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
			local result = place_spawner_around(fulgora_surface, evolution_factor, ruin.position)
			if(result == "failed") then
				-- デモリッシャー配置トライ(スポナー10個でデモリッシャー発生)
				try_place_demolisher(fulgora_surface, evolution_factor, ruin.position, demolisher_count)
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
			local result = place_spawner_around(fulgora_surface, evolution_factor, ruin.position)
			if(result == "failed") then
				-- デモリッシャー配置トライ(スポナー10個でデモリッシャー発生)
				try_place_demolisher(fulgora_surface, evolution_factor, ruin.position, demolisher_count)
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

-- ----------------------------
-- 品質の決定
-- ----------------------------
function choose_quality(evolution_factor)
	-- 変更なければnormal
	local quality = "normal"
	local r = math.random()
	
	if evolution_factor < 0.1 then
		if r < 0.01 then
			-- レア1％
			return "rare"
		elseif r < 0.1 then
			-- アンコモン9％
			return "uncommon"
		end
		
	elseif evolution_factor < 0.2 then
		if r < 0.05 then
			-- レア5％
			return "rare"
		elseif r < 0.2 then
			-- アンコモン15％
			return "uncommon"
		end
	
	elseif evolution_factor < 0.3 then
		if r < 0.1 then
			-- レア10％
			return "rare"
		elseif r < 0.3 then
			-- アンコモン20％
			return "uncommon"
		end
	
	elseif evolution_factor < 0.4 then
		if r < 0.01 then
			-- エピック1％
			return "epic"
		elseif r < 0.16 then
			-- レア15％
			return "rare"
		elseif r < 0.4 then
			-- アンコモン24％
			return "uncommon"
		end
	
	elseif evolution_factor < 0.5 then
		if r < 0.05 then
			-- エピック5％
			return "epic"
		elseif r < 0.25 then
			-- レア20％
			return "rare"
		elseif r < 0.5 then
			-- アンコモン25％
			return "uncommon"
		end
	
	elseif evolution_factor < 0.6 then
		if r < 0.10 then
			-- エピック10％
			return "epic"
		elseif r < 0.3 then
			-- レア20％
			return "rare"
		elseif r < 0.6 then
			-- アンコモン30％
			return "uncommon"
		end
	
	elseif evolution_factor < 0.7 then
		if r < 0.01 then
			-- レジェンド
			return "legendary"
		elseif r < 0.16 then
			-- エピック15％
			return "epic"
		elseif r < 0.41 then
			-- レア25％
			return "rare"
		elseif r < 0.7 then
			-- アンコモン29％
			return "uncommon"
		end
	
	elseif evolution_factor < 0.8 then
		if r < 0.05 then
			-- レジェンド5%
			return "legendary"
		elseif r < 0.25 then
			-- エピック20％
			return "epic"
		elseif r < 0.55 then
			-- レア30％
			return "rare"
		elseif r < 0.8 then
			-- アンコモン25％
			return "uncommon"
		end
	
	elseif evolution_factor < 0.9 then
		if r < 0.1 then
			-- レジェンド10%
			return "legendary"
		elseif r < 0.35 then
			-- エピック25％
			return "epic"
		elseif r < 0.65 then
			-- レア30％
			return "rare"
		elseif r < 0.9 then
			-- アンコモン25％
			return "uncommon"
		end
	
	elseif evolution_factor < 0.95 then
		if r < 0.2 then
			-- レジェンド20%
			return "legendary"
		elseif r < 0.5 then
			-- エピック30％
			return "epic"
		elseif r < 0.75 then
			-- レア25％
			return "rare"
		elseif r < 0.95 then
			-- アンコモン20％
			return "uncommon"
		end
	
	elseif evolution_factor < 0.98 then
		if r < 0.34 then
			-- レジェンド34%
			return "legendary"
		elseif r < 0.64 then
			-- エピック30％
			return "epic"
		elseif r < 0.84 then
			-- レア20％
			return "rare"
		elseif r < 0.99 then
			-- アンコモン15％
			return "uncommon"
		end
	
	else
		if r < 0.5 then
			-- レジェンド50%
			return "legendary"
		elseif r < 0.85 then
			-- エピック35％
			return "epic"
		elseif r < 0.95 then
			-- レア10％
			return "rare"
		else
			-- アンコモン5％
			return "uncommon"
		end
	
	end
	return "normal"
end