
data:extend({
	{
		type = "capsule",
		name = "biter_locator_easy",
		localised_name = {"item-name.biter_locator_easy"},
		localised_description = {"item-description.biter_locator_easy"},
		icon = "__TrueFulgoraConqueror__/graphics/icons/biter_locator_easy.png",
		icon_size = 128,
		subgroup = "capsule",
		order = "m[machine]-a[_010-biter_locator_easy]",
		stack_size = 100,
		weight = 1000,
		capsule_action = {
			type = "throw",
			attack_parameters = {
				type = "projectile",
				ammo_category = "capsule",
				cooldown = 30, -- クールダウンタイム
				range = 15, -- 投擲可能距離
				ammo_type = {
					category = "capsule",
					target_type = "position",
					action = {
						{
							type = "direct",
							action_delivery = {
								type = "instant"
							}
						}
					}
				}
			}
		}
	}
	,
	{
		type = "capsule",
		name = "biter_locator",
		localised_name = {"item-name.biter_locator"},
		localised_description = {"item-description.biter_locator"},
		icon = "__TrueFulgoraConqueror__/graphics/icons/biter_locator.png",
		icon_size = 128,
		subgroup = "capsule",
		order = "m[machine]-a[_011-biter_locator]",
		stack_size = 100,
		weight = 1000,
		capsule_action = {
			type = "throw",
			attack_parameters = {
				type = "projectile",
				ammo_category = "capsule",
				cooldown = 30, -- クールダウンタイム
				range = 15, -- 投擲可能距離
				ammo_type = {
					category = "capsule",
					target_type = "position",
					action = {
						{
							type = "direct",
							action_delivery = {
								type = "instant"
							}
						}
					}
				}
			}
		}
	}
	,
	{
		type = "capsule",
		name = "spitter_locator_easy",
		localised_name = {"item-name.spitter_locator_easy"},
		localised_description = {"item-description.spitter_locator_easy"},
		icon = "__TrueFulgoraConqueror__/graphics/icons/spitter_locator_easy.png",
		icon_size = 128,
		subgroup = "capsule",
		order = "m[machine]-a[_020-spitter_locator_easy]",
		stack_size = 100,
		weight = 1000,
		capsule_action = {
			type = "throw",
			attack_parameters = {
				type = "projectile",
				ammo_category = "capsule",
				cooldown = 30, -- クールダウンタイム
				range = 15, -- 投擲可能距離
				ammo_type = {
					category = "capsule",
					target_type = "position",
					action = {
						{
							type = "direct",
							action_delivery = {
								type = "instant"
							}
						}
					}
				}
			}
		}
	}
	,
	{
		type = "capsule",
		name = "spitter_locator",
		localised_name = {"item-name.spitter_locator"},
		localised_description = {"item-description.spitter_locator"},
		icon = "__TrueFulgoraConqueror__/graphics/icons/spitter_locator.png",
		icon_size = 128,
		subgroup = "capsule",
		order = "m[machine]-a[_021-spitter_locator]",
		stack_size = 100,
		weight = 1000,
		capsule_action = {
			type = "throw",
			attack_parameters = {
				type = "projectile",
				ammo_category = "capsule",
				cooldown = 30, -- クールダウンタイム
				range = 15, -- 投擲可能距離
				ammo_type = {
					category = "capsule",
					target_type = "position",
					action = {
						{
							type = "direct",
							action_delivery = {
								type = "instant"
							}
						}
					}
				}
			}
		}
	}
	,
	{
		type = "capsule",
		name = "worm_locator",
		localised_name = {"item-name.worm_locator"},
		localised_description = {"item-description.worm_locator"},
		icon = "__TrueFulgoraConqueror__/graphics/icons/worm_locator.png",
		icon_size = 128,
		subgroup = "capsule",
		order = "m[machine]-a[_031-worm_locator]",
		stack_size = 100,
		weight = 1000,
		capsule_action = {
			type = "throw",
			attack_parameters = {
				type = "projectile",
				ammo_category = "capsule",
				cooldown = 30, -- クールダウンタイム
				range = 15, -- 投擲可能距離
				ammo_type = {
					category = "capsule",
					target_type = "position",
					action = {
						{
							type = "direct",
							action_delivery = {
								type = "instant"
							}
						}
					}
				}
			}
		}
	}
	,
	{
		type = "capsule",
		name = "nauvis_nest_locator",
		localised_name = {"item-name.nauvis_nest_locator"},
		localised_description = {"item-description.nauvis_nest_locator"},
		icon = "__TrueFulgoraConqueror__/graphics/icons/nauvis_nest_locator.png",
		icon_size = 128,
		subgroup = "capsule",
		order = "m[machine]-a[_041-nauvis_nest_locator]",
		stack_size = 100,
		weight = 1000,
		capsule_action = {
			type = "throw",
			attack_parameters = {
				type = "projectile",
				ammo_category = "capsule",
				cooldown = 30, -- クールダウンタイム
				range = 15, -- 投擲可能距離
				ammo_type = {
					category = "capsule",
					target_type = "position",
					action = {
						{
							type = "direct",
							action_delivery = {
								type = "instant"
							}
						}
					}
				}
			}
		}
	}
	,
	{
		type = "capsule",
		name = "demolisher_locator",
		localised_name = {"item-name.demolisher_locator"},
		localised_description = {"item-description.demolisher_locator"},
		icon = "__TrueFulgoraConqueror__/graphics/icons/demolisher_locator.png",
		icon_size = 128,
		subgroup = "capsule",
		order = "m[machine]-a[_051-demolisher_locator]",
		stack_size = 100,
		weight = 1000,
		capsule_action = {
			type = "throw",
			attack_parameters = {
				type = "projectile",
				ammo_category = "capsule",
				cooldown = 30, -- クールダウンタイム
				range = 15, -- 投擲可能距離
				ammo_type = {
					category = "capsule",
					target_type = "position",
					action = {
						{
							type = "direct",
							action_delivery = {
								type = "instant"
							}
						}
					}
				}
			}
		}
	}
	,
	{
		type = "capsule",
		name = "wriggler_locator",
		localised_name = {"item-name.wriggler_locator"},
		localised_description = {"item-description.wriggler_locator"},
		icon = "__TrueFulgoraConqueror__/graphics/icons/wriggler_locator.png",
		icon_size = 128,
		subgroup = "capsule",
		order = "m[machine]-a[_061-wriggler_locator]",
		stack_size = 100,
		weight = 1000,
		capsule_action = {
			type = "throw",
			attack_parameters = {
				type = "projectile",
				ammo_category = "capsule",
				cooldown = 30, -- クールダウンタイム
				range = 15, -- 投擲可能距離
				ammo_type = {
					category = "capsule",
					target_type = "position",
					action = {
						{
							type = "direct",
							action_delivery = {
								type = "instant"
							}
						}
					}
				}
			}
		}
	}
	,
	{
		type = "capsule",
		name = "strafer_locator",
		localised_name = {"item-name.strafer_locator"},
		localised_description = {"item-description.strafer_locator"},
		icon = "__TrueFulgoraConqueror__/graphics/icons/strafer_locator.png",
		icon_size = 128,
		subgroup = "capsule",
		order = "m[machine]-a[_071-strafer_locator]",
		stack_size = 100,
		weight = 1000,
		capsule_action = {
			type = "throw",
			attack_parameters = {
				type = "projectile",
				ammo_category = "capsule",
				cooldown = 30, -- クールダウンタイム
				range = 15, -- 投擲可能距離
				ammo_type = {
					category = "capsule",
					target_type = "position",
					action = {
						{
							type = "direct",
							action_delivery = {
								type = "instant"
							}
						}
					}
				}
			}
		}
	}
	,
	{
		type = "capsule",
		name = "stomper_locator",
		localised_name = {"item-name.stomper_locator"},
		localised_description = {"item-description.stomper_locator"},
		icon = "__TrueFulgoraConqueror__/graphics/icons/stomper_locator.png",
		icon_size = 128,
		subgroup = "capsule",
		order = "m[machine]-a[_081-stomper_locator]",
		stack_size = 100,
		weight = 1000,
		capsule_action = {
			type = "throw",
			attack_parameters = {
				type = "projectile",
				ammo_category = "capsule",
				cooldown = 30, -- クールダウンタイム
				range = 15, -- 投擲可能距離
				ammo_type = {
					category = "capsule",
					target_type = "position",
					action = {
						{
							type = "direct",
							action_delivery = {
								type = "instant"
							}
						}
					}
				}
			}
		}
	}
	,
	{
		type = "capsule",
		name = "gleba_nest_locator",
		localised_name = {"item-name.gleba_nest_locator"},
		localised_description = {"item-description.gleba_nest_locator"},
		icon = "__TrueFulgoraConqueror__/graphics/icons/gleba_nest_locator.png",
		icon_size = 128,
		subgroup = "capsule",
		order = "m[machine]-a[_041-gleba_nest_locator]",
		stack_size = 100,
		weight = 1000,
		capsule_action = {
			type = "throw",
			attack_parameters = {
				type = "projectile",
				ammo_category = "capsule",
				cooldown = 30, -- クールダウンタイム
				range = 15, -- 投擲可能距離
				ammo_type = {
					category = "capsule",
					target_type = "position",
					action = {
						{
							type = "direct",
							action_delivery = {
								type = "instant"
							}
						}
					}
				}
			}
		}
	}
	,
	{
		type = "capsule",
		name = "master_locator",
		localised_name = {"item-name.master_locator"},
		localised_description = {"item-description.master_locator"},
		icon = "__TrueFulgoraConqueror__/graphics/icons/master_locator.png",
		icon_size = 128,
		subgroup = "capsule",
		order = "m[machine]-a[_041-master_locator]",
		stack_size = 100,
		weight = 1000,
		capsule_action = {
			type = "throw",
			attack_parameters = {
				type = "projectile",
				ammo_category = "capsule",
				cooldown = 30, -- クールダウンタイム
				range = 15, -- 投擲可能距離
				ammo_type = {
					category = "capsule",
					target_type = "position",
					action = {
						{
							type = "direct",
							action_delivery = {
								type = "instant"
							}
						}
					}
				}
			}
		}
	}
	,
})