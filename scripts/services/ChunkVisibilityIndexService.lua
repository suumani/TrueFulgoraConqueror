-- __TrueFulgoraConqueror__/scripts/services/ChunkVisibilityIndexService.lua
--[[
責務:
- 現在のchunk_listを走査し、プレイヤー視点で
  - 未可視チャンク群 (fulgora_no_visible_*)
  - 未チャートチャンク群 (fulgora_no_charted_*)
  を storage.suumani_tfc に再構築する。
- Controller側は「chunk_listを渡す」だけにして、storageキー詳細を隠蔽する。
]]

local ChunkVisibilityIndexService = {}

function ChunkVisibilityIndexService.rebuild_queues(surface, player_force, chunk_list)
  if storage.suumani_tfc == nil then storage.suumani_tfc = {} end

  -- queueのリセット（元コード踏襲）
  storage.suumani_tfc["fulgora_no_visible_chunk_queue"] = {}
  storage.suumani_tfc["fulgora_no_visible_chunks"] = {}
  storage.suumani_tfc["fulgora_no_charted_chunk_queue"] = {}
  storage.suumani_tfc["fulgora_no_charted_chunks"] = {}

  for _, chunk in ipairs(chunk_list) do
    if not player_force.is_chunk_visible(surface, {chunk.x, chunk.y}) then
      table.insert(storage.suumani_tfc["fulgora_no_visible_chunk_queue"], chunk)
      table.insert(storage.suumani_tfc["fulgora_no_visible_chunks"], chunk)
    end

    if not player_force.is_chunk_charted(surface, {chunk.x, chunk.y}) then
      table.insert(storage.suumani_tfc["fulgora_no_charted_chunk_queue"], chunk)
      table.insert(storage.suumani_tfc["fulgora_no_charted_chunks"], chunk)
    end
  end

  storage.suumani_tfc["fulgora_no_visible_chunk_queue_size"] =
    #storage.suumani_tfc["fulgora_no_visible_chunk_queue"]

  storage.suumani_tfc["fulgora_no_charted_chunk_queue_size"] =
    #storage.suumani_tfc["fulgora_no_charted_chunk_queue"]
end

return ChunkVisibilityIndexService