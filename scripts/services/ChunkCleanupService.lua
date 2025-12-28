--[[
責務:
- 生成済みチャンクのうち、プレイヤーがチャートしている範囲から遠すぎるものを削除する。
- チャート範囲のmin/maxを取得し、そこから一定距離(±32チャンク)を超えた生成済みチャンクを delete_chunk する。
- 「どこまで遠いと削除するか」というルールはこのServiceに閉じ込める。
]]

local ChunkCleanupService = {}

function ChunkCleanupService.delete_generated_chunks_too_far(surface, player_force)
  -- generated chunk coordinate
  local min_x_generated, min_y_generated, max_x_generated, max_y_generated
  -- charted chunk coordinate
  local min_x_charted, min_y_charted, max_x_charted, max_y_charted

  -- すべての生成済みチャンクを走査して、生成範囲とチャート範囲を取得
  for chunk in surface.get_chunks() do
    local x, y = chunk.x, chunk.y

    -- generated bbox
    if not min_x_generated then
      min_x_generated, min_y_generated, max_x_generated, max_y_generated = x, y, x, y
    else
      if x < min_x_generated then min_x_generated = x end
      if y < min_y_generated then min_y_generated = y end
      if x > max_x_generated then max_x_generated = x end
      if y > max_y_generated then max_y_generated = y end
    end

    -- charted bbox
    if player_force.is_chunk_charted(surface, {x, y}) then
      if not min_x_charted then
        min_x_charted, min_y_charted, max_x_charted, max_y_charted = x, y, x, y
      else
        if x < min_x_charted then min_x_charted = x end
        if y < min_y_charted then min_y_charted = y end
        if x > max_x_charted then max_x_charted = x end
        if y > max_y_charted then max_y_charted = y end
      end
    end
  end

  -- チャート済みチャンクが存在しない場合、削除基準が作れないので何もしない（安全側）
  if not min_x_charted then
    return
  end

  local chunk_count = 0
  local delete_count = 0

  -- すべての生成済みチャンクを走査して、遠すぎるものを削除
  for chunk in surface.get_chunks() do
    local x, y = chunk.x, chunk.y
    chunk_count = chunk_count + 1

    if x < min_x_charted - 32 then
      surface.delete_chunk({x, y}) ; delete_count = delete_count + 1
    elseif y < min_y_charted - 32 then
      surface.delete_chunk({x, y}) ; delete_count = delete_count + 1
    elseif x > max_x_charted + 32 then
      surface.delete_chunk({x, y}) ; delete_count = delete_count + 1
    elseif y > max_y_charted + 32 then
      surface.delete_chunk({x, y}) ; delete_count = delete_count + 1
    end
  end

  -- game_print.debug("deleted chunk = " .. delete_count)
end

return ChunkCleanupService