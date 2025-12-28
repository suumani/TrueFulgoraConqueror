--[[
責務:
- Fulgora上の遺跡エンティティを再収集し、storage.suumani_tfc の ruins_queue / ruins_queue_size を更新する。
- 収集対象のエンティティ名リストはこのServiceに閉じ込める。
]]

local RuinsQueueService = {}

local RUINS_ENTITY_NAMES = {
  "fulgoran-ruin-vault",
  "fulgoran-ruin-colossal",
  "fulgoran-ruin-huge"
}

function RuinsQueueService.refresh_ruins_queue(surface)
  if storage.suumani_tfc == nil then storage.suumani_tfc = {} end

  storage.suumani_tfc["ruins_queue"] =
    surface.find_entities_filtered{ name = RUINS_ENTITY_NAMES }

  storage.suumani_tfc["ruins_queue_size"] =
    #storage.suumani_tfc["ruins_queue"]
end

return RuinsQueueService