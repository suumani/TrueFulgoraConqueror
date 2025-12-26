-- ----------------------------
-- ワームサイズの選定
-- file path: scripts/core/events/common/ChooseWormSize.lua
-- ----------------------------

local ChooseWormSize = {}
local DRand = require("scripts.util.DeterministicRandom")
-- ----------------------------
-- ワームサイズの決定
-- ----------------------------
function ChooseWormSize.choose_worm_size(evolution_factor)
	local r = DRand.random()
	if evolution_factor < 0.2 then -- small worm 100%
		return CONST_ENTITY_NAME.SMALL_WORM
	elseif evolution_factor < 0.5 then -- small 70% medium 30%
		if r < 0.7 then
			return CONST_ENTITY_NAME.SMALL_WORM
		else
			return CONST_ENTITY_NAME.MEDIUM_WORM
		end
	elseif evolution_factor < 0.9 then -- small 10% medium 50% big 40%
		if r < 0.1 then
			return CONST_ENTITY_NAME.SMALL_WORM
		elseif r < 0.6 then
			return CONST_ENTITY_NAME.MEDIUM_WORM
		else
			return CONST_ENTITY_NAME.BIG_WORM
		end
	elseif evolution_factor < 0.98 then -- small 0% medium 40% big 30% behemoth 30%
		if r < 0.4 then
			return CONST_ENTITY_NAME.MEDIUM_WORM
		elseif r < 0.5 then
			return CONST_ENTITY_NAME.BIG_WORM
		else
			return CONST_ENTITY_NAME.BEHEMOTH_WORM
		end
	else -- small 0% medium 20% big 40% behemoth 40%
		if r < 0.2 then
			return CONST_ENTITY_NAME.MEDIUM_WORM
		elseif r < 0.6 then
			return CONST_ENTITY_NAME.BIG_WORM
		else
			return CONST_ENTITY_NAME.BEHEMOTH_WORM
		end
	end
end

return ChooseWormSize
