-- __TrueFulgoraConqueror__/scripts/events/on_nth_tick_30min.lua
local FulgoraRushController = require("scripts.control.FulgoraRushController")

script.on_nth_tick(108000, function()
  FulgoraRushController.run()
end)