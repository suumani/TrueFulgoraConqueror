--[[
責務:
- 座標計算の純粋関数を提供する（距離、補間移動など）。
- storageやgameに依存しない。
]]

local Geometry = {}

function Geometry.squared_distance(pos1, pos2)
  return (pos1.x - pos2.x)^2 + (pos1.y - pos2.y)^2
end

function Geometry.calculate_next_position(pos1, pos2, max_distance)
  local dx = pos2.x - pos1.x
  local dy = pos2.y - pos1.y
  local distance = math.sqrt(dx * dx + dy * dy)

  if distance <= max_distance then
    return {x = pos2.x, y = pos2.y}
  end

  local ratio = max_distance / distance
  return {x = pos1.x + dx * ratio, y = pos1.y + dy * ratio}
end

return Geometry