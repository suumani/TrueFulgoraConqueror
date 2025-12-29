-- __TrueFulgoraConqueror__/scripts/policies/fulgora_demolisher_move_policy.lua
local Policy = {}
local DemolisherNames = require("__Manis_lib__/scripts/definition/DemolisherNames")

local thresholds = {
  [DemolisherNames.SMALL]  = 0.4,
  [DemolisherNames.MEDIUM] = 0.7,
  [DemolisherNames.BIG]    = 0.9
}

function Policy.can_move(name, evo)
  local t = thresholds[name]
  return t ~= nil and evo > t
end

function Policy.compute_move_rate(rocket_positions)
  local n = rocket_positions and #rocket_positions or 0
  if n > 3 then n = 3 end
  return n
end

return Policy