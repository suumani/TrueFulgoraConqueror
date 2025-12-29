-- __TrueFulgoraConqueror__/scripts/services/MovePlanRunner.lua
local R = {}

local MovePlanStore = require("scripts.services.FulgoraDemolisherMovePlanStore")
local Executor = require("scripts.services.FulgoraDemolisherMoveExecutor")

local MAX_PLAN_AGE_TICKS = 60 * 60 * 60 -- 60•ª

local function is_plan_expired(plan)
  return plan.created_tick and (game.tick - plan.created_tick) > MAX_PLAN_AGE_TICKS
end

local function is_plan_finished(plan)
  local cell_count = plan.rows * plan.cols
  return (plan.moved_so_far >= plan.planned_total) or (plan.step > cell_count)
end

function R.run_one_step_if_present()
  local plan = MovePlanStore.get()
  if not plan then return 0 end

  if is_plan_expired(plan) or is_plan_finished(plan) then
    MovePlanStore.clear()
    return 0
  end

  local moved = Executor.execute_one_step(plan)

  if is_plan_finished(plan) then
    MovePlanStore.clear()
    return moved
  end

  MovePlanStore.set(plan)
  return moved
end

return R
