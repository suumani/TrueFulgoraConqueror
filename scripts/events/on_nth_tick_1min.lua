-- __TrueFulgoraConqueror__/scripts/events/on_nth_tick_1min.lua
local FulgoraDemolisherMovePlanRunner = require("scripts.services.FulgoraDemolisherMovePlanRunner")

script.on_nth_tick(3600, function()
  FulgoraDemolisherMovePlanRunner.run_one_step_if_present()
end)