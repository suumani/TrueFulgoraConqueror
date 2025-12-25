-- ----------------------------
-- requires
-- ----------------------------
require("prototypes.item")
require("prototypes.fluid")
require("prototypes.recipe")
require("prototypes.technology")

data:extend({
    {
        type = "custom-input",
        name = "on_insert_ammo_to_turrets",
        key_sequence = "I",
        consuming = "none" -- イベントを消費しない
    }
})