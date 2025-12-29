-- __TrueFulgoraConqueror__/scripts/control/FulgoraRushController.lua
-- Responsibility:
--   30分ごとのFulgora定期処理のオーケストレーションを行う。
--   具体ロジックは各Serviceへ委譲し、このファイルには極力ロジックを置かない。
--
-- Notes:
--   - デモリッシャー移動は「30分で計画作成 → 1分で分割実行」へ移行済み。
--     ロケット履歴は Lib(RocketLaunchHistoryStore) が TTL 管理するため、
--     ここでは履歴の初期化や一括移動は行わない。
local ChunkCleanupService = require("scripts.services.ChunkCleanupService")
local FulgoraExplorationService = require("scripts.services.FulgoraExplorationService")
local RuinsQueueService = require("scripts.services.RuinsQueueService")
local ChunkVisibilityIndexService = require("scripts.services.ChunkVisibilityIndexService")

local Chunk = require("scripts.core.Chunk")
local Spawner = require("scripts.core.Spawner")
local Demolisher = require("scripts.core.Demolisher")

-- 新：移動計画作成（30分）
local FulgoraDemolisherMoveOrchestrator = require("scripts.services.FulgoraDemolisherMoveOrchestrator")

local FulgoraRushController = {}

function FulgoraRushController.run()
  if game_debug ~= nil and game_debug == true then
    item_used_secretary_normal()
  end

  local fulgora_surface = game.surfaces["fulgora"]
  if fulgora_surface == nil then
    return
  end

  local evolution_factor = game.forces["enemy"].get_evolution_factor(fulgora_surface)
  local player_force = game.forces["player"]

  -- 探索拡張
  FulgoraExplorationService.expand_forced_charting_if_needed(fulgora_surface, player_force, evolution_factor)

  -- 遠すぎるチャンクが生成されている場合に削除
  ChunkCleanupService.delete_generated_chunks_too_far(fulgora_surface, player_force)

  -- 遺跡キュー更新
  RuinsQueueService.refresh_ruins_queue(fulgora_surface)

  -- 最新のチャンク情報
  local chunk_list = Chunk.get_chunk_list_now(fulgora_surface)

  -- 可視/未チャート集計
  ChunkVisibilityIndexService.rebuild_queues(fulgora_surface, player_force, chunk_list)

  -- 現在の敵情報
  local demolishers = Demolisher.get_demolishers_now(fulgora_surface)
  local spawners_count = Spawner.count_spawners_now(fulgora_surface)
  local demolishers_count = #demolishers

  game_print.debug(
    "(evolution_factor, ruins, spawners, demolishers, no visible chunk, no charted chunk, all chunk) = ("
    .. math.floor(100 * evolution_factor) / 100 .. ", "
    .. storage.suumani_tfc["ruins_queue_size"] .. ", "
    .. spawners_count .. ", "
    .. demolishers_count .. ", "
    .. storage.suumani_tfc["fulgora_no_visible_chunk_queue_size"] .. ", "
    .. storage.suumani_tfc["fulgora_no_charted_chunk_queue_size"] .. ", "
    .. #chunk_list .. ")"
  )

  -- デモリッシャー移動（30分：計画作成のみ）
  -- 実際の移動は on_nth_tick_1min 側で FulgoraDemolisherMovePlanRunner が分割実行する
  FulgoraDemolisherMoveOrchestrator.run_once()
end

return FulgoraRushController