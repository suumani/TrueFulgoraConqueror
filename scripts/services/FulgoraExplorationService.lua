-- __TrueFulgoraConqueror__/scripts/services/FulgoraExplorationService.lua
--[[
責務:
- Fulgoraにおける「意図的な小規模開拓」対策として、進化度に応じた強制チャート範囲を拡張する。
- storage.fulgora_forced_charted_area を更新し、拡張時のみメッセージを出す。
- 具体的なチャート処理は Chunk.ensure_chunk_charted に委譲する。
]]

local Chunk = require("scripts.core.Chunk")

local FulgoraExplorationService = {}

function FulgoraExplorationService.expand_forced_charting_if_needed(surface, player_force, evolution_factor)
  -- 初期化（既存挙動を壊さない）
  if storage.fulgora_forced_charted_area == nil then
    storage.fulgora_forced_charted_area = 0
  end

  -- 意図的な小規模開拓への対応（元コード踏襲）
  local force_charted_span = math.floor(evolution_factor * 20) + 5

  if storage.fulgora_forced_charted_area < force_charted_span then
    for x = -1 * force_charted_span, force_charted_span, 1 do
      for y = -1 * force_charted_span, force_charted_span, 1 do
        if not player_force.is_chunk_charted(surface, {x, y}) then
          Chunk.ensure_chunk_charted(surface, x, y)
        end
      end
    end

    storage.fulgora_forced_charted_area = force_charted_span
    game_print.message(
      "The satellite vision data has been processed. The explored area in Fulgora has expanded. ("
      .. (force_charted_span * 32) .. "m radius)"
    )
  end
end

return FulgoraExplorationService