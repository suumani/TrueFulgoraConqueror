-- ----------------------------
-- チャンクに関する処理
-- ----------------------------
local Chunk = {}

local cached_chunk_count = 0
local cached_unvisible_chunk_count = 0

-- ----------------------------
-- 最新のチャンクの取得(キャッシュ化)
-- ----------------------------
function Chunk.get_chunk_list_now(surface)
    if not surface then
        game_print.debug("Warning: get_chunks_now() was called with nil surface")
        return {}
    end

	local chunks = surface.get_chunks()
    local chunk_list = {}
    local all_chunk_count = 0
    cached_unvisible_chunk_count = 0
    
	for chunk in chunks do
        all_chunk_count = all_chunk_count + 1
        chunk_list[all_chunk_count] = chunk
		if not game.forces["player"].is_chunk_visible(surface, {chunk.x, chunk.y}) then
            cached_unvisible_chunk_count = cached_unvisible_chunk_count + 1
		end
	end

    cached_chunk_count = all_chunk_count

    return chunk_list
end

-- ----------------------------
-- unvisibleキャッシュ取得
-- ----------------------------
function Chunk.get_cached_unvisible_chunk_count(surface)
    if cached_unvisible_chunk_count == nil or cached_unvisible_chunk_count == 0 then
        local chunk_list = Chunk.get_chunk_list_now(surface)
        return cached_unvisible_chunk_count
    end
    return cached_unvisible_chunk_count
end

-- ----------------------------
-- キャッシュ取得
-- ----------------------------
function Chunk.get_cached_chunk_count(surface)
    if cached_chunk_count == nil or cached_chunk_count == 0 then
        local chunk_list = Chunk.get_chunk_list_now(surface)
        return #chunk_list
    end
    return cached_chunk_count
end

-- ----------------------------
-- 強制チャート
-- ----------------------------
function Chunk.ensure_chunk_charted(surface, chunk_x, chunk_y)
    -- チャンクが生成されていなければ生成リクエスト
    if not surface.is_chunk_generated({x = chunk_x, y = chunk_y}) then
        surface.request_to_generate_chunks({x = chunk_x, y = chunk_y}, 1)
        surface.force_generate_chunk_requests()
    end

    -- チャンクが開拓済みでなければ、マップに表示
    if not game.forces["player"].is_chunk_charted(surface, {chunk_x, chunk_y}) then
        game.forces["player"].chart(surface, {{chunk_x * 32, chunk_y * 32}, {chunk_x * 32 + 31, chunk_y * 32 + 31}})
    end
end

-- ----------------------------
-- deprecated 強制開拓(chartedまで入れないと、機能しない)
-- ----------------------------
function Chunk.ensure_chunk_generated(surface, chunk_x, chunk_y)
    -- チャンクが生成されていなければ生成リクエスト
    if not surface.is_chunk_generated({x = chunk_x, y = chunk_y}) then
        surface.request_to_generate_chunks({x = chunk_x, y = chunk_y}, 1)
        surface.force_generate_chunk_requests()
    end
end

return Chunk
