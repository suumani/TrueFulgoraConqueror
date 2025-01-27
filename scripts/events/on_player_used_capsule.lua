

local itemTbl = {
	["biter_locator_easy"] = {{"small-biter","medium-biter","big-biter","behemoth-biter"}, 75, false}, 
	["biter_locator"] ={{"small-biter","medium-biter","big-biter","behemoth-biter"}, 100, false}, 
	["spitter_locator_easy"] = {{"small-spitter"}, 75, false}, 
	["spitter_locator"] = {{"small-spitter","medium-spitter","big-spitter","behemoth-spitter"}, 100, false}, 
	["worm_locator"] = {{CONST_ENTITY_NAME.SMALL_WORM,CONST_ENTITY_NAME.MEDIUM_WORM,CONST_ENTITY_NAME.BIG_WORM,CONST_ENTITY_NAME.BEHEMOTH_WORM}, 100, false}, 
	["nauvis_nest_locator"] = {{"biter_nest","spitter_nest"}, 125, false}, 
	["demolisher_locator"] = {{"small-demolisher","medium-demolisher","big-demolisher"}, 125, false}, 
	["wriggler_locator"] = {{"small-wriggler","medium-wriggler","big-wriggler"}, 100, false}, 
	["strafer_locator"] = {{"small-strafer","medium-strafer","big-strafer"}, 100, false}, 
	["stomper_locator"] = {{"small-stomper","medium-stomper","big-stomper"}, 100, false}, 
	["gleba_nest_locator"] = {{"gleba-spawner-slime","gleba-spawner-corpse","gleba-spawner-corpse-small"}, 125, false}, 
	["master_locator"] = {{"biter_nest","spitter_nest","gleba-spawner-slime","gleba-spawner-corpse","gleba-spawner-corpse-small"}, 200, false}, 
}

-- ----------------------------
-- 投擲イベント
-- ----------------------------
script.on_event(defines.events.on_player_used_capsule, function(event)

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

	local entity = result_entities[math.random(1,#result_entities)]
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
	if math.random() < rate then
		return entities
	else
		return {}
	end

end