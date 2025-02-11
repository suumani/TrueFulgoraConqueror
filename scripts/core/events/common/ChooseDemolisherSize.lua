-- ----------------------------
-- デモリッシャーサイズの選定
-- file path: scripts/core/events/common/ChooseDemolisherSize.lua
-- ----------------------------

local ChooseDemolisherSize = {}

-- ----------------------------
-- デモリッシャーサイズの選定関数
-- ----------------------------
function ChooseDemolisherSize.choose_demolisher_size(evolution_factor)
	local r = math.random()
	-- 進化0.3未満
	if evolution_factor < 0.3 then
		return "small-demolisher"
	-- 進化0.5未満
	elseif evolution_factor < 0.4 then
		if r < 0.95 then
			return "small-demolisher"
		else
			return "medium-demolisher"
		end
	elseif evolution_factor < 0.5 then
		if r < 0.9 then
			return "small-demolisher"
		else
			return "medium-demolisher"
		end
	elseif evolution_factor < 0.6 then
		if r < 0.85 then
			return "small-demolisher"
		else
			return "medium-demolisher"
		end
	elseif evolution_factor < 0.7 then
		if r < 0.80 then
			return "small-demolisher"
		elseif r < 0.98 then
			return "medium-demolisher"
		else
			return "big-demolisher"
		end
	elseif evolution_factor < 0.8 then
		if r < 0.75 then
			return "small-demolisher"
		elseif r < 0.96 then
			return "medium-demolisher"
		else
			return "big-demolisher"
		end
	elseif evolution_factor < 0.9 then
		if r < 0.7 then
			return "small-demolisher"
		elseif r < 0.94 then
			return "medium-demolisher"
		else
			return "big-demolisher"
		end
	elseif evolution_factor < 0.95 then
		if r < 0.65 then
			return "small-demolisher"
		elseif r < 0.92 then
			return "medium-demolisher"
		else
			return "big-demolisher"
		end
	elseif evolution_factor < 0.98 then
		if r < 0.6 then
			return "small-demolisher"
		elseif r < 0.9 then
			return "medium-demolisher"
		else
			return "big-demolisher"
		end
	else
		if r < 0.55 then
			return "small-demolisher"
		elseif r < 0.8 then
			return "medium-demolisher"
		else
			return "big-demolisher"
		end
	end
end

return ChooseDemolisherSize
