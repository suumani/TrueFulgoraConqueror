-- ----------------------------
-- 30分イベント
-- ----------------------------
script.on_nth_tick(108000, function()

	if game_debug ~= nil and game_debug == true then
		item_used_secretary_normal()
	end

	-- フルゴララッシュの実行
	local fulgora_surface = game.surfaces["fulgora"]
	if fulgora_surface == nil then
		return
	end

	-- 進化度の取得
	local evolution_factor = game.forces["enemy"].get_evolution_factor(fulgora_surface)

	-- 遠すぎるチャンクが生成されている場合に削除
	delete_genarated_chunks_too_far(fulgora_surface)

	-- 現在の遺跡情報の上書き(デモリッシャーに壊される運命)
	storage.ruins_queue = fulgora_surface.find_entities_filtered{name = {"fulgoran-ruin-vault","fulgoran-ruin-colossal","fulgoran-ruin-huge"}}
	storage.ruins_queue_size = #storage.ruins_queue

	-- 現在のデモリッシャーの数の上書き
	local demolishers = fulgora_surface.find_entities_filtered{force = "enemy", name = {"small-demolisher","medium-demolisher","big-demolisher"}}
	storage.fulgora_demolisher_count = #demolishers

	-- 最新のチャンク情報
	local chunks = fulgora_surface.get_chunks()
	storage.fulgora_chunk_queue = {}
	for chunk in chunks do
		table.insert(storage.fulgora_chunk_queue, chunk)
	end
	storage.fulgora_chunk_queue_size = #storage.fulgora_chunk_queue

	
	local spawners = fulgora_surface.find_entities_filtered{
		force = "enemy", 
		name = {"biter-spawner", "spitter-spawner"}, 
	}

	--[[
	game_print.debug(
		"(evolution_factor, ruins, spawners, demolishers, chunk) = ("
		.. math.floor(100*evolution_factor) / 100 .. ", " 
		.. storage.ruins_queue_size .. ", " 
		.. #spawners .. ", " 
		.. storage.fulgora_demolisher_count .. ", " 
		.. storage.fulgora_chunk_queue_size ..")")]]

	-- 移動対象なしか、ロケット打ち上げなし
	if storage.latest_fulgora_rocket_histories == nil then storage.latest_fulgora_rocket_histories = {} end
	if #demolishers ~= 0 and #storage.latest_fulgora_rocket_histories ~= 0 then

		local move_rate = #storage.latest_fulgora_rocket_histories
		if move_rate > 3 then
			move_rate = 3
		end
		
		-- デモリッシャー移動イベント
		local count = Demolishers_Move_to_Silo(demolishers, evolution_factor, move_rate)
		if count == 1 then
			game_print.message("1 Demolisher begins to move ... The vibrations from the rocket silo are...")
		elseif count > 1 then
			game_print.message(count .. "Demolisher begin to move ... The vibrations from the rocket silo are...")
		end
	
	end


	-- ロケット発射座標履歴の初期化
	storage.latest_fulgora_rocket_histories = {}

end)

-- ----------------------------
-- デモリッシャー移動イベント(ロケット打ち上げ履歴依存)
-- ----------------------------
function Demolishers_Move_to_Silo(demolishers, evolution_factor, move_rate)
	
	-- 移動対象なしか、ロケット打ち上げなし
	if #demolishers == 0 or #storage.latest_fulgora_rocket_histories == 0 then
		return 0
	end

	-- 全てのデモリッシャーに対して実行
	local count = 0
	for _, demolisher in pairs(demolishers) do
		-- 進化度から、移動許可
		if (demolisher.name == "small-demolisher" and evolution_factor > 0.4) or
			(demolisher.name == "medium-demolisher" and evolution_factor > 0.7) or 
			(demolisher.name == "big-demolisher" and evolution_factor > 0.9) then

			-- 進化度の50％の確率で移動
			if math.random() < (evolution_factor / 2) then
				local max_distance = math.floor(20 * evolution_factor * move_rate) + 1
				if demolisher.name == "medium-demolisher" then
					max_distance = math.floor(20 * evolution_factor * move_rate) + 1
				elseif demolisher.name == "big-demolisher" then
					max_distance = math.floor(20 * evolution_factor * move_rate) + 1
				end
				max_distance = math.random(0, max_distance)
				Demolisher_Move_to_Silo(demolisher, storage.latest_fulgora_rocket_histories, max_distance)
				count = count + 1
			end
		end
	end
	return count
end

-- ----------------------------
-- Entityのサイロに向けたワープ
-- ----------------------------
function Demolisher_Move_to_Silo(entity, positions, max_distance)

	local min_distance
	-- 移動方向の座標
	local target_position
	-- 実際の移動先
	local move_position

	-- 最も近いサイロ座標を決定
	for _, position in pairs(positions) do
		if min_distance == nil then
			min_distance = squared_distance(entity.position, position)
			target_position = position
		else
			local current_distance = squared_distance(entity.position, position)
			if current_distance < min_distance then
				min_distance = current_distance
				target_position = position
			end
		end
	end

	move_position = calculate_next_position(entity.position, target_position, max_distance)

	-- game_print.debug("demolisher warp : (" .. entity.position.x .. ", " .. entity.position.y .. ") -> (" .. move_position.x .. ", " .. move_position.y .. ")")

	-- 移動先にコピー（.teleportはデモリッシャーに無効）
	local new_entity = entity.surface.create_entity{
        name = entity.name,
        position = move_position,
        force = entity.force,
        direction = entity.direction,
		quality = entity.quality
    }

	-- 移動元を削除
	entity.destroy()

	-- game_print.debug("new demolisher.pos = (" .. new_entity.position.x .. ", " .. new_entity.position.y .. ")")

end

function calculate_next_position(pos1, pos2, max_distance)
    local dx = pos2.x - pos1.x
    local dy = pos2.y - pos1.y
    local distance = math.sqrt(dx * dx + dy * dy)

    -- 目標地点がmax_distance以内なら、その座標を返す
    if distance <= max_distance then
        return {x = pos2.x, y = pos2.y}
    end

    -- 最大移動量
    local ratio = max_distance / distance
    local new_x = pos1.x + dx * ratio
    local new_y = pos1.y + dy * ratio

    return {x = new_x, y = new_y}
end

-- ----------------------------
-- 距離の二乗の取得
-- ----------------------------
function squared_distance(pos1, pos2)
	return (pos1.x - pos2.x)^2 + (pos1.y - pos2.y)^2
end


-- ----------------------------
-- 生成済みのチャンクの削除
-- ----------------------------
function delete_genarated_chunks_too_far(fulgora_surface)

	local force = game.forces["player"]
	-- generated chunk coordinate
    local min_x_generated, min_y_generated, max_x_generated, max_y_generated
	-- charted chunk coordinate
    local min_x_charted, min_y_charted, max_x_charted, max_y_charted

    -- すべての生成済みチャンクを走査
    for chunk in fulgora_surface.get_chunks() do
        local x, y = chunk.x, chunk.y
		-- 最初のチャンクを初期値として設定
		if not min_x_generated then
			min_x_generated, min_y_generated, max_x_generated, max_y_generated = x, y, x, y
		else
			-- 左上と右下のチャンクを更新
			if x < min_x_generated then min_x_generated = x end
			if y < min_y_generated then min_y_generated = y end
			if x > max_x_generated then max_x_generated = x end
			if y > max_y_generated then max_y_generated = y end
		end

		if force.is_chunk_charted(fulgora_surface, {x, y}) then
			-- 最初のチャンクを初期値として設定
			if not min_x_charted then
				min_x_charted, min_y_charted, max_x_charted, max_y_charted = x, y, x, y
			else
				-- 左上と右下のチャンクを更新
				if x < min_x_charted then min_x_charted = x end
				if y < min_y_charted then min_y_charted = y end
				if x > max_x_charted then max_x_charted = x end
				if y > max_y_charted then max_y_charted = y end
			end
		end
    end

	local chunk_count = 0
	local delete_count = 0
    -- すべての生成済みチャンクを走査
    for chunk in fulgora_surface.get_chunks() do
        local x, y = chunk.x, chunk.y
		chunk_count = chunk_count + 1

		if x < min_x_charted - 32 then fulgora_surface.delete_chunk({x, y}) delete_count = delete_count + 1 
		elseif y < min_y_charted - 32 then fulgora_surface.delete_chunk({x, y}) delete_count = delete_count + 1 
		elseif x > max_x_charted + 32 then fulgora_surface.delete_chunk({x, y}) delete_count = delete_count + 1 
		elseif y > max_y_charted + 32 then fulgora_surface.delete_chunk({x, y}) delete_count = delete_count + 1
		end

    end

    -- 左上と右下のチャンク座標を表示
    -- game.print("chunk_count = " .. chunk_count)
    -- game.print("Generated Top-left, Bottom-right  chunk: (" .. min_x_generated .. ", " .. min_y_generated .. "), (" .. max_x_generated .. ", " .. max_y_generated .. ")")
    -- game.print("Charted Top-left, Bottom-right  chunk: (" .. min_x_charted .. ", " .. min_y_charted .. "), (" .. max_x_charted .. ", " .. max_y_charted .. ")")
    -- game.print("deleted chunk = " .. delete_count)
end