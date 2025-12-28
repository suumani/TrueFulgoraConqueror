--[[
責務:
- ロケット打ち上げ座標履歴をもとに、条件を満たすデモリッシャーをサイロ方向へ移動させる。
- teleportが無効なため、create_entity + destroy によるワープで実現する。
]]

local DRand = require("scripts.util.DeterministicRandom")
local Geometry = require("scripts.util.Geometry")
local BUILDING_CHECK_RADIUS = 10

local DemolisherMigrationService = {}

local function can_move_by_evolution(name, evo)
  if name == "small-demolisher" then return evo > 0.4 end
  if name == "medium-demolisher" then return evo > 0.7 end
  if name == "big-demolisher" then return evo > 0.9 end
  return false
end

local function calc_move_rate(rocket_histories)
  local rate = #rocket_histories
  if rate > 3 then rate = 3 end
  return rate
end

local function calc_max_distance(evo, move_rate)
  local maxd = math.floor(20 * evo * move_rate) + 1
  return DRand.random(0, maxd)
end

local function find_nearest_target(pos, targets)
  local best, best_d2 = nil, nil
  for _, t in pairs(targets) do
    local d2 = Geometry.squared_distance(pos, t)
    if best_d2 == nil or d2 < best_d2 then
      best_d2 = d2
      best = t
    end
  end
  return best
end

local function choose_cardinal_direction(from_pos, to_pos)
  local dx = to_pos.x - from_pos.x
  local dy = to_pos.y - from_pos.y
  if math.abs(dx) >= math.abs(dy) then
    return (dx >= 0) and defines.direction.east or defines.direction.west
  else
    return (dy >= 0) and defines.direction.south or defines.direction.north
  end
end

-- ----------------------------
-- player建物（エンティティ）が近いか？
-- AABB(±radius)内に player force のエンティティが1つでもあれば true
-- ----------------------------
local function has_player_building_near(surface, pos, radius)
  local area = {
    { x = pos.x - radius, y = pos.y - radius },
    { x = pos.x + radius, y = pos.y + radius }
  }

  local entities = surface.find_entities_filtered{ area = area, force = PLAYER_FORCE_NAME }
  if not entities or #entities == 0 then
    return false
  end

  -- player force のエンティティは基本「建物扱い」で良い、という仕様に基づき即true
  return true
end

local function warp_entity_toward(entity, target_pos, max_distance)
  local move_pos = Geometry.calculate_next_position(entity.position, target_pos, max_distance)

  -- 同一地点なら移動中止
  if entity.position.x == target_pos.x and entity.position.y == target_pos.y then
    return false 
  end

  -- player建物が近いなら移動中止
  if has_player_building_near(entity.surface, move_pos, BUILDING_CHECK_RADIUS) then
    return false
  end

  local dir = choose_cardinal_direction(entity.position, move_pos)
  if move_pos.x == entity.position.x and move_pos.y == entity.position.y then
    dir = entity.direction
  end

  local new_entity = entity.surface.create_entity{
    name = entity.name,
    position = move_pos,
    force = entity.force,
    quality = entity.quality,
    direction = dir
  }
  entity.destroy()
  return new_entity
end

function DemolisherMigrationService.move_to_silo_if_needed(surface, demolishers, evolution_factor, rocket_histories)
  if #demolishers == 0 or #rocket_histories == 0 then
    return 0
  end

  local move_rate = calc_move_rate(rocket_histories)
  local moved = 0

  for _, d in pairs(demolishers) do
    if can_move_by_evolution(d.name, evolution_factor) then
      -- 進化度の50% の確率
      if DRand.random() < (evolution_factor / 2) then
        local target = find_nearest_target(d.position, rocket_histories)
        if target ~= nil then
          local max_distance = calc_max_distance(evolution_factor, move_rate)
          warp_entity_toward(d, target, max_distance)
          moved = moved + 1
        end
      end
    end
  end

  return moved
end

return DemolisherMigrationService