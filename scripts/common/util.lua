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
