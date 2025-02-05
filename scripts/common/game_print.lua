game_print = {}

-- ----------------------------
-- debug文の表示
-- ----------------------------
local function debug_print(str)
	if game_debug ~= nil and game_debug == true then
		game.print("[debug] " .. str)
	end
end

-- ----------------------------
-- ユーザへの通知メッセージ
-- ----------------------------
local function game_message_print(str)
	game.print(str)
end

game_print.debug = debug_print
game_print.message = game_message_print