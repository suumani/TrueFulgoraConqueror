-- __TrueFulgoraConqueror__/scripts/services/FulgoraDemolisherMovePlanStore.lua
local S = {}
local KEY = "tfc_fulgora_move_plan"

function S.get()
  return storage.suumani_tfc and storage.suumani_tfc[KEY] or nil
end

function S.set(plan)
  storage.suumani_tfc = storage.suumani_tfc or {}
  storage.suumani_tfc[KEY] = plan
end

function S.clear()
  if storage.suumani_tfc then
    storage.suumani_tfc[KEY] = nil
  end
end

return S