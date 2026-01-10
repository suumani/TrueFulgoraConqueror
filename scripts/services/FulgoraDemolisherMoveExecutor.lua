-- __TrueFulgoraConqueror__/scripts/services/FulgoraDemolisherMoveExecutor.lua
local E = {}

local StepExecutor = require("__Manis_lib__/scripts/domain/demolisher/move/DemolisherMoveStepExecutor")
local DemolisherQuery = require("__Manis_lib__/scripts/queries/DemolisherQuery")
local MovePolicy = require("scripts.policies.fulgora_demolisher_move_policy")
local ModRandomProvider = require("scripts.services.ModRandomProvider")

local function build_move_targets(surface, area, ctx)
  return DemolisherQuery.find_demolishers_range(surface, area) or {}
end

local function get_rocket_positions(plan)
  return plan.rocket_positions or plan.positions
end

function E.execute_one_step(plan)
  return StepExecutor.execute_one_step(plan, {
    get_surface = function(surface_name) return game.surfaces[surface_name] end,
    get_rocket_positions = get_rocket_positions,
    build_move_targets = build_move_targets,
    compute_move_rate = MovePolicy.compute_move_rate,
    can_move = MovePolicy.can_move,
    get_rng = function() return ModRandomProvider.get() end,
  })
end

return E