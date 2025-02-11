-- ----------------------------
-- RuinsEventの定義
-- file path: scripts/core/events/RuinsEvent.lua
-- ----------------------------
local RuinsEvent = {}

local SharedEvent = require("scripts.core.events.SharedEvent")
local PlaceEntity = require("scripts.core.events.common.PlaceEntity")

-- ----------------------------
-- 遺跡イベントの実行
-- ----------------------------
function RuinsEvent.execute(fulgora_surface, fulgora_demolisher_count)
    -- キューが存在しなければ終了
    if storage.suumani_tfc["ruins_queue"] == nil or #storage.suumani_tfc["ruins_queue"] == 0 then
        -- game_print.debug("[debug] #storage.ruins_queue, storage.suumani_tfc["ruins_queue_size"] = " .. #storage.ruins_queue .. ", " .. storage.suumani_tfc["ruins_queue_size"])
        return
    end

    -- 進化度の取得
    local evolution_factor = game.forces["enemy"].get_evolution_factor(fulgora_surface)
    
    -- 今回の実行数
    local target_count = math.floor((storage.suumani_tfc["ruins_queue_size"] or 0) / 180) + 1

    local ruins_queue_size = #storage.suumani_tfc["ruins_queue"]

    -- game_print.debug("([debug] ruins_queue_size, ruins_queue_size - target_count) = ( " .. ruins_queue_size .. ", " .. ruins_queue_size - target_count .. ")" )
    for i = ruins_queue_size, ruins_queue_size - target_count, -1 do
        -- 対象がなくなったら終了
        if i < 1 then
            -- game_print.debug("[debug] on_nth_tick 600 finish")
            return
        end

        -- 対象が既になければ除去して終了
        if storage.suumani_tfc["ruins_queue"][i].valid == false then
            table.remove(storage.suumani_tfc["ruins_queue"], i)
        else

            if storage.suumani_tfc["ruins_queue"][i].name == "fulgoran-ruin-vault" then
                -- フルゴラのフルゴラの貯蔵庫の遺構からは30分おきに100%の確率でバイターの巣とワームが3個発生する、発生できない場合はデモリッシャー判定がある
                PlaceEntity.try_fulgoran_ruin_vault(fulgora_surface, evolution_factor, storage.suumani_tfc["ruins_queue"][i].position, fulgora_demolisher_count)
            elseif storage.suumani_tfc["ruins_queue"][i].name == "fulgoran-ruin-colossal" then
                -- フルゴラの超巨大な遺跡からは30分おき100%の確率でバイターの巣とワームが1個発生する
                PlaceEntity.try_fulgoran_ruin_colossal(fulgora_surface, evolution_factor, storage.suumani_tfc["ruins_queue"][i].position, fulgora_demolisher_count)
            elseif storage.suumani_tfc["ruins_queue"][i].name == "fulgoran-ruin-huge" then
                -- フルゴラの巨大な遺跡からは30分おき10%の確率でバイターの巣とワームが発生する
                PlaceEntity.try_fulgoran_ruin_huge(fulgora_surface, evolution_factor, storage.suumani_tfc["ruins_queue"][i].position, fulgora_demolisher_count)
            end
    
            -- 操作終了したら除去
            table.remove(storage.suumani_tfc["ruins_queue"], i)
        end
        
    end
end

return RuinsEvent
