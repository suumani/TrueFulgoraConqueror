-- ----------------------------
-- 汎用テーブル長用
-- ----------------------------
function table_length(tbl)
    local count = 0
    for _ in pairs(tbl) do
        count = count + 1
    end
    return count
end

-- scripts.common.util.lua
local util = {}

-- デバッグ出力フラグ
util.DEBUG_ENABLED = false

function util.print(msg)
  if game and msg then
    game.print(msg)
  end
end

function util.debug(msg)
  if not util.DEBUG_ENABLED then return end
  if game and msg then
    game.print(msg)
  end
end

return util