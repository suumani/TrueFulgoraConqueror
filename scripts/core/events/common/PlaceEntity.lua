-- ----------------------------
-- SharedEventの定義
-- file path: scripts/core/events/common/PlaceEntity.lua
-- ----------------------------
local PlaceEntity = {}
local DRand = require("scripts.util.DeterministicRandom")
-- region
-- デモリッシャーサイズの選定関数
local ChooseDemolisherSize = require("scripts.core.events.common.ChooseDemolisherSize")
local choose_demolisher_size = ChooseDemolisherSize.choose_demolisher_size

-- ワームサイズの選定関数
local ChooseWormSize = require("scripts.core.events.common.ChooseWormSize")
local choose_worm_size = ChooseWormSize.choose_worm_size

-- endregion

-- ----------------------------
-- 周辺座標にワームを配置する
-- ----------------------------
function place_worm(fulgora_surface, evolution_factor, name, spawn_position)
	local quality = QualityRoller.choose_quality(queued.evolution_factor, Drand.random())
	fulgora_surface.create_entity{name = name, position = spawn_position, quality = quality, force = "enemy"}
end

-- ----------------------------
-- 指定座標にバイターかスピッターの巣を配置する
-- ----------------------------
function place_spawner(fulgora_surface, evolution_factor, spawn_position)
	local quality = QualityRoller.choose_quality(queued.evolution_factor, Drand.random())
	local r = DRand.random()
	if(r < 0.5) then
		fulgora_surface.create_entity{name = "biter-spawner", position = spawn_position, quality = quality, force = "enemy"}
	else
		fulgora_surface.create_entity{name = "spitter-spawner", position = spawn_position, quality = quality, force = "enemy"}
	end
end


-- ----------------------------
-- デモリッシャー配置トライ(スポナー＊0.8＋ワーム*0.5) * (1 + evolution_factor * 0.5)＞10でデモリッシャー発生可
-- ----------------------------
function PlaceEntity.try_place_demolisher(fulgora_surface, evolution_factor, center_position, demolisher_count)
	-- デモリッシャーがマップに多すぎで終了
	if demolisher_count > 200 then
		return
	end

	-- デモリッシャーが近くに3匹以上居たら終了
	local nearby_demolishers = fulgora_surface.find_entities_filtered{
		force = "enemy", 
		name = {"small-demolisher","medium-demolisher","big-demolisher"},
		area = {{center_position.x - 100, center_position.y - 100}, {center_position.x + 100, center_position.y + 100}}
	}
	if #nearby_demolishers > 2 then
		return false
	end

	-- デモリッシャー発生条件未達成で終了
	local spawners = fulgora_surface.find_entities_filtered{
		type = "unit-spawner",
		area = {{center_position.x - 20, center_position.y - 20}, {center_position.x + 20, center_position.y + 20}}
	}
	local worms = fulgora_surface.find_entities_filtered{
		name = {CONST_ENTITY_NAME.SMALL_WORM, CONST_ENTITY_NAME.MEDIUM_WORM, CONST_ENTITY_NAME.BIG_WORM, CONST_ENTITY_NAME.BEHEMOTH_WORM},
		area = {{center_position.x - 20, center_position.y - 20}, {center_position.x + 20, center_position.y + 20}}
	}
	if ((#spawners * 0.8 + #worms * 0.5) * (1 + evolution_factor * 0.5)) < 10 then
		return false
	end

	game_print.debug("[fulgora] demolishers = " .. demolisher_count)
	game.print({"item-description.demolisher-spawn"})
	game_print.debug("at (x, y) = (" .. center_position.x .. ", " .. center_position.y .. ")")

	fulgora_surface.create_entity{name = choose_demolisher_size(evolution_factor), position = center_position, quality = choose_quality(evolution_factor),force = "enemy"}
	return true
end



-- ----------------------------
-- 周辺座標にバイターかスピッターの巣を配置する
-- ----------------------------
local function place_spawner_around(fulgora_surface, evolution_factor, center_position)
	local spawn_position = {x = center_position.x + DRand.random(-20, 20), y = center_position.y + DRand.random(-20, 20)}

	-- チャンク未生成は終了
	if fulgora_surface.is_chunk_generated({x = math.floor(spawn_position.x / 32), y = math.floor(spawn_position.y / 32)}) == false then
		return "failed"
	end

	if fulgora_surface.can_place_entity{name = "spitter-spawner", position = spawn_position} then
		place_spawner(fulgora_surface, evolution_factor, spawn_position)
		return "success"
	else 
		return "failed"
	end
end

-- ----------------------------
-- 周辺座標にワームを配置する
-- ----------------------------
local function place_worm_around(fulgora_surface, evolution_factor, center_position)
	local spawn_position = {x = center_position.x + DRand.random(-20, 20), y = center_position.y + DRand.random(-20, 20)}

	-- チャンク未生成は終了
	if fulgora_surface.is_chunk_generated({x = math.floor(spawn_position.x / 32), y = math.floor(spawn_position.y / 32)}) == false then
		return "failed"
	end

	local name = choose_worm_size(evolution_factor)
	if fulgora_surface.can_place_entity{name = name, position = spawn_position} then
		place_worm(fulgora_surface, evolution_factor, name, spawn_position)
		return "success"
	else 
		return "failed"
	end
end

-- ----------------------------
-- フルゴラの巨大な遺跡からは30分おき10%の確率でバイターの巣とワームが発生する
-- ----------------------------
function PlaceEntity.try_fulgoran_ruin_huge(fulgora_surface, evolution_factor, position, demolisher_count)
	-- game_print.debug("[debug] try_fulgoran_ruin_huge")

	-- 90%の確率で終了
	if DRand.random() < 0.9 then
		return
	end

	local result = "success"
	if DRand.random() < 0.5 then
		result = place_spawner_around(fulgora_surface, evolution_factor, position)
	else
		result = place_worm_around(fulgora_surface, evolution_factor, position)
	end

	if(result == "failed") then
		-- デモリッシャー配置トライ(スポナー10個でデモリッシャー発生)
		PlaceEntity.try_place_demolisher(fulgora_surface, evolution_factor, position, demolisher_count)
	end
end

-- ----------------------------
-- フルゴラのフルゴラの貯蔵庫の遺構からは30分おきに100%の確率でバイターの巣とワームが3個発生する、発生できない場合はデモリッシャー判定がある
-- ----------------------------
function PlaceEntity.try_fulgoran_ruin_vault(fulgora_surface, evolution_factor, position, demolisher_count)
	-- game_print.debug("[debug] try_fulgoran_ruin_vault")
	-- 設置が成功すると仮定
	local result = "success"

	for i = 0, 3, 1 do
		if DRand.random() < 0.5 then
			local result2 = place_spawner_around(fulgora_surface, evolution_factor, position)
			-- 設置が一度でも失敗したら、最終失敗判定
			if result2 == "failed" then
				result = "failed"
			end
		else
			local result2 = place_worm_around(fulgora_surface, evolution_factor, position)
			-- 設置が一度でも失敗したら、最終失敗判定
			if result2 == "failed" then
				result = "failed"
			end
		end
	end

	-- 設置に成功したら終了
	if result == "success" then
		return
	end

	-- デモリッシャー配置
	PlaceEntity.try_place_demolisher(fulgora_surface, evolution_factor, position, demolisher_count)

end

-- ----------------------------
-- フルゴラの超巨大な遺跡からは30分おき100%の確率でバイターの巣とワームが1個発生する
-- ----------------------------
function PlaceEntity.try_fulgoran_ruin_colossal(fulgora_surface, evolution_factor, position, demolisher_count)
	-- game_print.debug("[debug] try_fulgoran_ruin_colossal")
	local result = "success"
	if DRand.random() < 0.5 then
		result = place_spawner_around(fulgora_surface, evolution_factor, position)
	else
		result = place_worm_around(fulgora_surface, evolution_factor, position)
	end

	if(result == "failed") then
		-- デモリッシャー配置トライ(スポナー10個でデモリッシャー発生)
		PlaceEntity.try_place_demolisher(fulgora_surface, evolution_factor, position, demolisher_count)
	end
end

return PlaceEntity
