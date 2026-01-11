-- ----------------------------
-- デモリッシャーサイズの選定
-- file path: scripts/core/events/common/ChooseDemolisherSize.lua
-- ----------------------------

local ChooseDemolisherSize = {}
local DRand = require("scripts.util.DeterministicRandom")
local DemolisherNames = require("__Manis_definitions__/scripts/definition/DemolisherNames")
-- ----------------------------
-- デモリッシャーサイズの選定関数
-- ----------------------------
function ChooseDemolisherSize.choose_demolisher_size(evolution_factor)
	local r = DRand.random()
	-- 進化0.3未満
	if evolution_factor < 0.3 then
		return DemolisherNames.MANIS_SMALL_ALT
	-- 進化0.5未満
	elseif evolution_factor < 0.4 then
		if r < 0.95 then
			return DemolisherNames.MANIS_SMALL_ALT
		else
			return DemolisherNames.MANIS_MEDIUM_ALT
		end
	elseif evolution_factor < 0.5 then
		if r < 0.9 then
			return DemolisherNames.MANIS_SMALL_ALT
		else
			return DemolisherNames.MANIS_MEDIUM_ALT
		end
	elseif evolution_factor < 0.6 then
		if r < 0.85 then
			return DemolisherNames.MANIS_SMALL_ALT
		else
			return DemolisherNames.MANIS_MEDIUM_ALT
		end
	elseif evolution_factor < 0.7 then
		if r < 0.80 then
			return DemolisherNames.MANIS_SMALL_ALT
		elseif r < 0.98 then
			return DemolisherNames.MANIS_MEDIUM_ALT
		else
			return DemolisherNames.MANIS_BIG_ALT
		end
	elseif evolution_factor < 0.8 then
		if r < 0.75 then
			return DemolisherNames.MANIS_SMALL_ALT
		elseif r < 0.96 then
			return DemolisherNames.MANIS_MEDIUM_ALT
		else
			return DemolisherNames.MANIS_BIG_ALT
		end
	elseif evolution_factor < 0.9 then
		if r < 0.7 then
			return DemolisherNames.MANIS_SMALL_ALT
		elseif r < 0.94 then
			return DemolisherNames.MANIS_MEDIUM_ALT
		else
			return DemolisherNames.MANIS_BIG_ALT
		end
	elseif evolution_factor < 0.95 then
		if r < 0.65 then
			return DemolisherNames.MANIS_SMALL_ALT
		elseif r < 0.92 then
			return DemolisherNames.MANIS_MEDIUM_ALT
		else
			return DemolisherNames.MANIS_BIG_ALT
		end
	elseif evolution_factor < 0.98 then
		if r < 0.6 then
			return DemolisherNames.MANIS_SMALL_ALT
		elseif r < 0.9 then
			return DemolisherNames.MANIS_MEDIUM_ALT
		else
			return DemolisherNames.MANIS_BIG_ALT
		end
	else
		if r < 0.55 then
			return DemolisherNames.MANIS_SMALL_ALT
		elseif r < 0.8 then
			return DemolisherNames.MANIS_MEDIUM_ALT
		else
			return DemolisherNames.MANIS_BIG_ALT
		end
	end
end

return ChooseDemolisherSize
