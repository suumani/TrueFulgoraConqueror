-- ----------------------------
-- TfcModのカスタムイベント群の定義
-- file path: scripts/core/SuumaniTfcEvent.lua
-- ----------------------------

local SuumaniTfcEvent = {}

-- region 依存モジュールのロード
SuumaniTfcEvent.RuinsEvent = require("scripts.core.events.RuinsEvent")
SuumaniTfcEvent.NoChartedChunkEvent = require("scripts.core.events.NoChartedChunkEvent")
SuumaniTfcEvent.NoVisibleChunkEvent = require("scripts.core.events.NoVisibleChunkEvent")
-- endregion

return SuumaniTfcEvent
