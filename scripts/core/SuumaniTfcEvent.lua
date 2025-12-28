-- ----------------------------
-- TfcModのカスタムイベント群の定義
-- file path: scripts/core/SuumaniTfcEvent.lua
-- ----------------------------

local SuumaniTfcEvent = {}

SuumaniTfcEvent.RuinsEvent = require("scripts.core.events.RuinsEvent")
SuumaniTfcEvent.NoChartedChunkEvent = require("scripts.core.events.NoChartedChunkEvent")
SuumaniTfcEvent.NoVisibleChunkEvent = require("scripts.core.events.NoVisibleChunkEvent")

return SuumaniTfcEvent
