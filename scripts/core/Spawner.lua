-- ----------------------------
-- スポナーに関する処理
-- ----------------------------
local Spawner = {}

-- スポナー数のキャッシュ(30分更新)
local cached_spawner_count = 0  -- 初期値を 0 に設定

-- ----------------------------
-- 最新のスポナー数の取得
-- ----------------------------
function Spawner.count_spawners_now(surface)
    if not surface then
        log("Warning: count_spawners_now() was called with nil surface")
        return cached_spawner_count
    end

    local spawner_count = #surface.find_entities_filtered{type = "unit-spawner"}
    cached_spawner_count = spawner_count
    return spawner_count
end

-- ----------------------------
-- キャッシュ取得
-- ----------------------------
function Spawner.get_cached_spawner_count(surface)
    if cached_spawner_count == nil then
        return Spawner.count_spawners_now(surface)
    end
    return cached_spawner_count
end

return Spawner
