-- ----------------------------
-- 30分イベント
-- ----------------------------
script.on_nth_tick(108000, function()
	-- フルゴララッシュの実行
	local fulgora_surface = game.surfaces["fulgora"]
	if fulgora_surface == nil then
		return
	end

	-- 現在の遺跡情報の上書き
	storage.ruins_queue = fulgora_surface.find_entities_filtered{name = {"fulgoran-ruin-vault","fulgoran-ruin-colossal","fulgoran-ruin-huge"}}
	storage.ruins_queue_size = #storage.ruins_queue
	-- 現在のデモリッシャーの数の上書き
	storage.fulgora_demolisher_count = #(fulgora_surface.find_entities_filtered{force = "enemy", name = {"small-demolisher","medium-demolisher","big-demolisher"}})

	-- game.print("storage.fulgora_demolisher_count = " .. storage.fulgora_demolisher_count)

end)
-- ----------------------------
-- 生成済みのチャンクの削除
-- ----------------------------
function delete_genarated_chunks_too_far()

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