-- __TrueFulgoraConqueror__/scripts/services/FulgoraDemolisherMoveOrchestrator.lua
local Orchestrator = {}

local RocketLaunchHistoryStore = require("__Manis_lib__/scripts/domain/demolisher/move/RocketLaunchHistoryStore")
local MovePlanner = require("__Manis_lib__/scripts/domain/demolisher/move/DemolisherMovePlanner")
local DemolisherQuery = require("__Manis_lib__/scripts/queries/DemolisherQuery")

local MovePlanStore = require("scripts.services.FulgoraDemolisherMovePlanStore")
local ModRandomProvider = require("scripts.services.ModRandomProvider")

local SURFACE_NAME = "fulgora"
local MAX_PLANNED_TOTAL = 100

function Orchestrator.run_once()
  local surface = game.surfaces[SURFACE_NAME]
  if not (surface and surface.valid) then return 0 end

  local rocket_positions = RocketLaunchHistoryStore.get_positions(SURFACE_NAME, game.tick)
  if not rocket_positions or #rocket_positions == 0 then return 0 end

  local demolishers = DemolisherQuery.find_demolishers(surface)
  local evo = game.forces.enemy.get_evolution_factor(surface)

  local planned_total = math.floor(#demolishers * evo * 0.5)
  if planned_total > MAX_PLANNED_TOTAL then planned_total = MAX_PLANNED_TOTAL end
  if planned_total <= 0 then return 0 end

  local rng = ModRandomProvider.get()
  local plan = MovePlanner.build_plan(SURFACE_NAME, planned_total, rocket_positions, rng)
  if not plan then return 0 end

  MovePlanStore.set(plan)
  return planned_total
end

return Orchestrator