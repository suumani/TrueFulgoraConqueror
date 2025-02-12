-- ----------------------------
-- デモリッシャーに関する処理
-- ----------------------------
local Demolisher = {}

-- デモリッシャー数のキャッシュ(30分更新)
local cached_demolisher_count = 0  -- 初期値を 0 に設定

-- ----------------------------
-- 最新のデモリッシャーリストの取得
-- ----------------------------
function Demolisher.get_demolishers_now(surface)
    if not surface then
        game_print.debug("Warning: get_demolishers_now() was called with nil surface")
        return {}
    end

    local demolishers = surface.find_entities_filtered{force = "enemy", name = {"small-demolisher","medium-demolisher","big-demolisher"}}
    cached_demolisher_count = #demolishers
    return demolishers
end

-- ----------------------------
-- 最新のデモリッシャー数の取得
-- ----------------------------
function Demolisher.count_demolishers_now(surface)
    -- game_print.debug("Demolisher.count_demolishers_now")
    if not surface then
        -- game_print.debug("Warning: count_demolishers_now() was called with nil surface")
        return cached_demolisher_count
    end

    local demolisher_count = #surface.find_entities_filtered{force = "enemy", name = {"small-demolisher","medium-demolisher","big-demolisher"}}
    cached_demolisher_count = demolisher_count
    -- game_print.debug("demolisher_count = "..demolisher_count)
    return demolisher_count
end

-- ----------------------------
-- キャッシュ取得
-- ----------------------------
function Demolisher.get_cached_demolisher_count(surface)
    -- game_print.debug("Demolisher.get_cached_demolisher_count")
    if cached_demolisher_count == nil or cached_demolisher_count == 0 then
        return Demolisher.count_demolishers_now(surface)
    end
    return cached_demolisher_count
end

return Demolisher
