-- ----------------------------
-- 打ち上げイベント
-- ----------------------------
script.on_event(defines.events.on_rocket_launched, function(event)
	-- 打ち上げたサイロの情報を取得
	local silo = event.rocket_silo

	-- サイロ情報取得できず(発射直後に壊れたとかありそう)
	if not silo then
		game.print("Rocket launched, but no silo information available.")
		return
	end

	-- fulgora以外は管理対象外
	if silo.surface.name ~= "fulgora" then
		return
	end

	if storage.latest_fulgora_rocket_histories == nil then storage.latest_fulgora_rocket_histories = {} end
	table.insert(storage.latest_fulgora_rocket_histories, silo.position)

end)
