-- __TrueFulgoraConqueror__/scripts/services/ModRandomProvider.lua
local P = {}
local STORAGE_KEY = "_tfc_rng"
local DEFAULT_SEED = 1001001

function P.get()
  storage.suumani_tfc = storage.suumani_tfc or {}
  storage.suumani_tfc[STORAGE_KEY] = storage.suumani_tfc[STORAGE_KEY] or game.create_random_generator(DEFAULT_SEED)
  return storage.suumani_tfc[STORAGE_KEY]
end

return P