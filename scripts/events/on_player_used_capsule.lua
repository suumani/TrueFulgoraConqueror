local DRand = require("scripts.util.DeterministicRandom")

local itemTbl = {
	["biter_locator_easy"] = {{"small-biter","medium-biter","big-biter","behemoth-biter"}, 75, false}, 
	["biter_locator"] ={{"small-biter","medium-biter","big-biter","behemoth-biter"}, 100, false}, 
	["spitter_locator_easy"] = {{"small-spitter"}, 75, false}, 
	["spitter_locator"] = {{"small-spitter","medium-spitter","big-spitter","behemoth-spitter"}, 100, false}, 
	["worm_locator"] = {{CONST_ENTITY_NAME.SMALL_WORM,CONST_ENTITY_NAME.MEDIUM_WORM,CONST_ENTITY_NAME.BIG_WORM,CONST_ENTITY_NAME.BEHEMOTH_WORM}, 100, false}, 
	["nauvis_nest_locator"] = {{"biter-spawner","spitter-spawner"}, 125, false}, 
	["demolisher_locator"] = {{"small-demolisher","medium-demolisher","big-demolisher"}, 125, false}, 
	["wriggler_locator"] = {{"small-wriggler-pentapod","medium-wriggler-pentapod","big-wriggler-pentapod"}, 100, false}, 
	["strafer_locator"] = {{"small-strafer-pentapod","medium-strafer-pentapod","big-strafer-pentapod"}, 100, false}, 
	["stomper_locator"] = {{"small-stomper-pentapod","medium-stomper-pentapod","big-stomper-pentapod"}, 100, false}, 
	["gleba_nest_locator"] = {{"gleba-spawner","gleba-spawner-corpse","gleba-spawner-corpse-small"}, 125, false}, 
	["master_locator"] = {{"biter-spawner","spitter-spawner","gleba-spawner","gleba-spawner-corpse","gleba-spawner-corpse-small"}, 200, false}, 
}

local function find_all_demolishers_in_surface(surface)
	return surface.find_entities_filtered{force = "enemy", name = {"small-demolisher","medium-demolisher","big-demolisher"}}
end
local function find_all_biters_and_pentapod_in_surface(surface)
	return surface.find_entities_filtered{force = "enemy", name = {
		"small-biter","medium-biter","big-biter","behemoth-biter",
		"small-spitter","medium-spitter","big-spitter","behemoth-spitter",
		CONST_ENTITY_NAME.SMALL_WORM,CONST_ENTITY_NAME.MEDIUM_WORM,CONST_ENTITY_NAME.BIG_WORM,CONST_ENTITY_NAME.BEHEMOTH_WORM,
		"small-wriggler-pentapod","medium-wriggler-pentapod","big-wriggler-pentapod",
		"small-strafer-pentapod","medium-strafer-pentapod","big-strafer-pentapod",
		"small-stomper-pentapod","medium-stomper-pentapod","big-stomper-pentapod",
	}}
end
local function find_all_nests_in_surface(surface)
	return surface.find_entities_filtered{force = "enemy", name = {
		"biter-spawner","spitter-spawner","gleba-spawner","gleba-spawner-corpse","gleba-spawner-corpse-small"
	}}
end

local function show_all_evolution()

	local text = nil
	for key, value in pairs(game.surfaces) do
		if not value.name:find("platform") then
			text = 
				(text and text .. ", " or "") .. 
				value.name .. ": " .. 
				(math.floor(1000 * game.forces["enemy"].get_evolution_factor(value)) / 1000 )
		end
	end
	
	game_print.message ("evolution = (" .. text .. ")")
end

local function show_all_biters()

	local text = nil
	for key, value in pairs(game.surfaces) do
		if not value.name:find("platform") then
			text = (text and text .. ", " or "") .. value.name .. ": " .. #(find_all_biters_and_pentapod_in_surface(value))
		end
	end
	
	game_print.message ("small creature = (" .. text .. ")")
	
end


local function show_all_nests()

	local text = nil
	for key, value in pairs(game.surfaces) do
		if not value.name:find("platform") then
			text = (text and text .. ", " or "") .. value.name .. ": " .. #(find_all_nests_in_surface(value))
		end
	end
	
	game_print.message ("nests = (" .. text .. ")")
	
end


local function show_all_demolishers()

	local text = nil
	for key, value in pairs(game.surfaces) do
		if not value.name:find("platform") then
			text = (text and text .. ", " or "") .. value.name .. ": " .. #(find_all_demolishers_in_surface(value))
		end
	end
	
	game_print.message ("demolishers = (" .. text .. ")")
	
end


-- ----------------------------
-- 秘書サービス
-- ----------------------------
function item_used_secretary_normal()

	game_print.message ("Initializing secretary service. Aggregating known information from each planet...")
	show_all_evolution()
	show_all_biters()
	show_all_nests()
	show_all_demolishers()

end

-- ----------------------------
-- 投擲イベント
-- ----------------------------
script.on_event(defines.events.on_player_used_capsule, function(event)

	if event.item.name == "secretary_normal" then
		item_used_secretary_normal()
	end

	if itemTbl[event.item.name] == nil then
		return
	end

	local player = game.get_player(event.player_index)
	local surface = player.surface
	local position = event.position
	local distance_rate = 2 -- 手持ち投擲は半径２倍
	local result_entities = throw_locator(itemTbl[event.item.name], surface, position, distance_rate)

	if #result_entities == 0 then
		game.print("no entity found...")
		return
	end

	local entity = result_entities[DRand.random(1,#result_entities)]
	game.print("found at (x,y) = " ..math.floor(entity.position.x).. ","..math.floor(entity.position.y)..")")

end)

function throw_locator(param, surface, position, distance_rate)
	-- entityの検索
	local distance = param[2] * distance_rate
	local entities = surface.find_entities_filtered{
		force = "enemy",
		area = {{position.x - distance, position.y - distance}, {position.x + distance, position.y + distance}},
		 name = param[1]
		}
	-- 精度
	if param[3] == true then
		rate = 0.8
	else
		rate = 0.5
	end

	rate = 1
	if DRand.random() < rate then
		return entities
	else
		return {}
	end

end