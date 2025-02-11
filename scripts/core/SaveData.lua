-- ----------------------------
-- セーブデータ管理モジュール
-- ----------------------------
local SaveData = {}


-- ----------------------------
-- 初期化
-- ----------------------------
function SaveData.init()

	storage = storage or {}
    storage.suumani_tfc = storage.suumani_tfc or {}

    storage.suumani_tfc["ruins_queue"] = storage.suumani_tfc["ruins_queue"] or {}
    storage.suumani_tfc["ruins_queue_size"] = storage.suumani_tfc["ruins_queue_size"] or 0

    storage.suumani_tfc["fulgora_no_charted_chunk_queue"] = storage.suumani_tfc["fulgora_no_charted_chunk_queue"] or {}
    storage.suumani_tfc["fulgora_no_charted_chunks"] = storage.suumani_tfc["fulgora_no_charted_chunks"] or {}
    storage.suumani_tfc["fulgora_no_charted_chunk_queue_size"] = storage.suumani_tfc["fulgora_no_charted_chunk_queue_size"] or 0

    storage.suumani_tfc["fulgora_no_visible_chunk_queue"] = storage.suumani_tfc["fulgora_no_visible_chunk_queue"] or {}
    storage.suumani_tfc["fulgora_no_visible_chunks"] = storage.suumani_tfc["fulgora_no_visible_chunks"] or {}
    storage.suumani_tfc["fulgora_no_visible_chunk_queue_size"] = storage.suumani_tfc["fulgora_no_visible_chunk_queue_size"] or 0

    storage.suumani_tfc["latest_fulgora_rocket_histories"] = storage.suumani_tfc["latest_fulgora_rocket_histories"] or {}

	-- 強制チャート
	storage.fulgora_forced_charted_area = storage.fulgora_forced_charted_area or 0

	-- ver.0.1.3以前対応
	if storage.fulgora_chunk_queue ~= nil then
		if storage.fulgora_no_charted_chunk_queue == nil then storage.fulgora_no_charted_chunk_queue = {} end
		for key, value in pairs(storage.fulgora_chunk_queue) do
			table.insert(storage.fulgora_no_charted_chunk_queue, value)
		end
	end
	storage.fulgora_chunk_queue = nil
	storage.fulgora_chunk_queue_size = nil

	-- ver.0.1.4以前対応
	if storage.ruins_queue ~= nil then
		for key, value in pairs(storage.ruins_queue) do
			table.insert(storage.suumani_tfc["ruins_queue"], value)
		end
		storage.suumani_tfc["ruins_queue_size"] = #storage.suumani_tfc["ruins_queue"]
		storage.ruins_queue = nil
		storage.ruins_queue_size = nil
	end

	if storage.fulgora_no_charted_chunk_queue ~= nil then
		for key, value in pairs(storage.fulgora_no_charted_chunk_queue) do
			table.insert(storage.suumani_tfc["fulgora_no_charted_chunk_queue"], value)
		end
		storage.suumani_tfc["fulgora_no_charted_chunk_queue_size"] = #storage.suumani_tfc["fulgora_no_charted_chunk_queue"]
		storage.fulgora_no_charted_chunk_queue = nil
		storage.fulgora_no_charted_chunk_queue_size = nil
	end

	if storage.fulgora_no_visible_chunk_queue ~= nil then
		for key, value in pairs(storage.fulgora_no_visible_chunk_queue) do
			table.insert(storage.suumani_tfc["fulgora_no_visible_chunk_queue"], value)
		end
		storage.suumani_tfc["fulgora_no_visible_chunk_queue_size"] = #storage.suumani_tfc["fulgora_no_visible_chunk_queue"]
		storage.fulgora_no_visible_chunk_queue = nil
		storage.fulgora_no_visible_chunk_queue_size = nil
	end

	if storage.latest_fulgora_rocket_histories ~= nil then
		for key, value in pairs(storage.latest_fulgora_rocket_histories) do
			table.insert(storage.suumani_tfc["latest_fulgora_rocket_histories"], value)
		end
		storage.latest_fulgora_rocket_histories = nil
	end

end

-- ----------------------------
-- データの保存
-- ----------------------------
function SaveData.set(key, value)
    storage.mod_data[key] = value
end

-- ----------------------------
-- データの取得
-- ----------------------------
function SaveData.get(key, default)
    return storage.mod_data[key] or default
end

-- ----------------------------
-- データの削除
-- ----------------------------
function SaveData.remove(key)
    storage.mod_data[key] = nil
end

-- ----------------------------
-- 開始
-- ----------------------------
script.on_init(function()
	SaveData.init()
end)

-- ----------------------------
-- ロード
-- ----------------------------
script.on_load(function()
end)

-- ----------------------------
-- 構成変更
-- ----------------------------
script.on_configuration_changed(function(event)
	SaveData.init()
end)

return SaveData