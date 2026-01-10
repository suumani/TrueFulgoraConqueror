-- __TrueFulgoraConqueror__/scripts/events/on_rocket_launched.lua
local RocketLaunchHistoryStore = require("__Manis_lib__/scripts/domain/demolisher/move/RocketLaunchHistoryStore")
local util        = require("scripts.common.util")

script.on_event(defines.events.on_rocket_launched, function(event)
  util.debug("__TrueFulgoraConqueror__ defines.events.on_rocket_launched")
  local silo = event.rocket_silo
  if not silo or not silo.valid then return end

  local surface = silo.surface
  if not surface or not surface.valid or surface.name ~= "fulgora" then return end

  RocketLaunchHistoryStore.add(surface.name, silo.position, event.tick)
end)