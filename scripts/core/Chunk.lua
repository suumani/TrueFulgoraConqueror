-- ----------------------------
-- チャンクに関する処理
-- ----------------------------
local Chunk = {}

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
