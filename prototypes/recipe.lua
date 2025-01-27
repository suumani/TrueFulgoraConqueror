
data:extend({
	{
		type = "recipe",
		name = "nauvis_sap",
		category = "chemistry",
		enabled = true,
		energy_required = 12,
		ingredients =
		{
			{type = "item", name = "wood", amount = 15},
			{type = "item", name = "raw-fish", amount = 2},
			{type = "fluid", name = "water", amount = 100}
		},
		results =
		{
			{type = "fluid", name = "nauvis_sap", amount = 10}
		},
		allow_productivity = true,
		subgroup = "fluid-recipes",
		order = "c[oil-products]-z[nauvis_sap]",
		crafting_machine_tint =
		{
			primary = {r = 0.268, g = 0.723, b = 0.223, a = 1.000}, -- #44b838ff
			secondary = {r = 0.432, g = 0.793, b = 0.386, a = 1.000}, -- #6eca62ff
			tertiary = {r = 0.647, g = 0.471, b = 0.396, a = 1.000}, -- #a57865ff
			quaternary = {r = 1.000, g = 0.395, b = 0.127, a = 1.000}, -- #ff6420ff
		},
		surface_conditions =
		{
		  {
			property = "pressure",
			min = 1000,
			max = 1000
		  }
		},
	}
	,
	{
		type = "recipe",
		name = "biter_locator_easy",
		enabled = true,
		energy_required = 3,
		ingredients =
		{
		{type = "item", name = "iron-gear-wheel", amount = 2},
		{type = "item", name = "electronic-circuit", amount = 2},
		{type = "item", name = "wood", amount = 8},
		{type = "item", name = "raw-fish", amount = 4}
		},
		results = {{type="item", name="biter_locator_easy", amount=1}}
	}
	,
	{
		type = "recipe",
		name = "biter_locator",
		category = "crafting-with-fluid",
		enabled = true,
		energy_required = 10,
		ingredients =
		{
			{type = "item", name = "electronic-circuit", amount = 2},
			{type = "item", name = "advanced-circuit", amount = 2},
			{type = "item", name = "biter_locator_easy", amount = 2},
			{type = "fluid", name = "nauvis_sap", amount = 20}
		},
		results = {{type="item", name="biter_locator", amount=1}}
	}
	,
	{
		type = "recipe",
		name = "spitter_locator_easy",
		enabled = true,
		energy_required = 3,
		ingredients =
		{
		{type = "item", name = "iron-gear-wheel", amount = 2},
		{type = "item", name = "electronic-circuit", amount = 2},
		{type = "item", name = "wood", amount = 4},
		{type = "item", name = "raw-fish", amount = 8}
		},
		results = {{type="item", name="spitter_locator_easy", amount=1}}
	}
	,
	{
		type = "recipe",
		name = "spitter_locator",
		category = "crafting-with-fluid",
		enabled = true,
		energy_required = 10,
		ingredients =
		{
			{type = "item", name = "electronic-circuit", amount = 2},
			{type = "item", name = "advanced-circuit", amount = 2},
			{type = "item", name = "spitter_locator_easy", amount = 2},
			{type = "fluid", name = "nauvis_sap", amount = 20}
		},
		results = {{type="item", name="spitter_locator", amount=1}}
	}
	,
	{
		type = "recipe",
		name = "worm_locator",
		category = "crafting-with-fluid",
		enabled = true,
		energy_required = 12,
		ingredients =
		{
			{type = "item", name = "advanced-circuit", amount = 2},
			{type = "item", name = "processing-unit", amount = 2},
			{type = "item", name = "biter_locator_easy", amount = 1},
			{type = "item", name = "spitter_locator_easy", amount = 1},
			{type = "fluid", name = "nauvis_sap", amount = 20}
		},
		results = {{type="item", name="worm_locator", amount=1}}
	}
	,
	{
		type = "recipe",
		name = "nauvis_nest_locator",
		category = "crafting-with-fluid",
		enabled = true,
		energy_required = 15,
		ingredients =
		{
			{type = "item", name = "processing-unit", amount = 2},
			{type = "item", name = "biter_locator", amount = 1},
			{type = "item", name = "spitter_locator", amount = 1},
			{type = "item", name = "worm_locator", amount = 1},
			{type = "item", name = "biter-egg", amount = 2},
			{type = "fluid", name = "nauvis_sap", amount = 20}
		},
		results = {{type="item", name="nauvis_nest_locator", amount=1}}
	}
	,
	{
		type = "recipe",
		name = "demolisher_locator",
		category = "metallurgy",
		enabled = true,
		energy_required = 22,
		ingredients =
		{
			{type = "item", name = "processing-unit", amount = 4},
			{type = "item", name = "nauvis_nest_locator", amount = 4},
			{type = "item", name = "tungsten-plate", amount = 10},
			{type = "fluid", name = "sulfuric-acid", amount = 40},
		},
		results = {{type="item", name="demolisher_locator", amount=1}},
		surface_conditions =
		{
			{
				property = "pressure",
				min = 4000,
				max = 4000
			}
		}
	}
	,
	{
		type = "recipe",
		name = "gleba_sap",
		category = "organic",
		enabled = true,
		energy_required = 12,
		ingredients =
		{
			{type = "item", name = "wood", amount = 15},
			{type = "item", name = "pentapod-egg", amount = 1},
			{type = "fluid", name = "water", amount = 100}
		},
		results =
		{
			{type = "fluid", name = "gleba_sap", amount = 10}
		},
		allow_productivity = true,
		subgroup = "fluid-recipes",
		order = "c[oil-products]-z[gleba_sap]",
		crafting_machine_tint =
		{
			primary = {r = 0.268, g = 0.723, b = 0.223, a = 1.000}, -- #44b838ff
			secondary = {r = 0.432, g = 0.793, b = 0.386, a = 1.000}, -- #6eca62ff
			tertiary = {r = 0.647, g = 0.471, b = 0.396, a = 1.000}, -- #a57865ff
			quaternary = {r = 1.000, g = 0.395, b = 0.127, a = 1.000}, -- #ff6420ff
		},
		surface_conditions =
		{
		  {
			property = "pressure",
			min = 2000,
			max = 2000
		  }
		},
	}
	,
	{
		type = "recipe",
		name = "wriggler_locator",
		category = "organic",
		enabled = true,
		energy_required = 16,
		ingredients =
		{
			{type = "item", name = "iron-gear-wheel", amount = 4},
			{type = "item", name = "electronic-circuit", amount = 2},
			{type = "item", name = "advanced-circuit", amount = 2},
			{type = "item", name = "yumako-mash", amount = 2},
			{type = "item", name = "pentapod-egg", amount = 1},
			{type = "fluid", name = "gleba_sap", amount = 20}
		},
		results = {{type="item", name="wriggler_locator", amount=1}},
		surface_conditions =
		{
		  {
			property = "pressure",
			min = 2000,
			max = 2000
		  }
		},
	}
	,
	{
		type = "recipe",
		name = "strafer_locator",
		category = "organic",
		enabled = true,
		energy_required = 16,
		ingredients =
		{
			{type = "item", name = "iron-gear-wheel", amount = 4},
			{type = "item", name = "electronic-circuit", amount = 2},
			{type = "item", name = "advanced-circuit", amount = 2},
			{type = "item", name = "jelly", amount = 2},
			{type = "item", name = "pentapod-egg", amount = 1},
			{type = "fluid", name = "gleba_sap", amount = 20}
		},
		results = {{type="item", name="strafer_locator", amount=1}},
		surface_conditions =
		{
		  {
			property = "pressure",
			min = 2000,
			max = 2000
		  }
		},
	}
	,
	{
		type = "recipe",
		name = "stomper_locator",
		category = "organic",
		enabled = true,
		energy_required = 16,
		ingredients =
		{
			{type = "item", name = "iron-gear-wheel", amount = 4},
			{type = "item", name = "electronic-circuit", amount = 2},
			{type = "item", name = "advanced-circuit", amount = 2},
			{type = "item", name = "bioflux", amount = 2},
			{type = "item", name = "pentapod-egg", amount = 1},
			{type = "fluid", name = "gleba_sap", amount = 20}
		},
		results = {{type="item", name="stomper_locator", amount=1}},
		surface_conditions =
		{
		  {
			property = "pressure",
			min = 2000,
			max = 2000
		  }
		},
	}
	,
	{
		type = "recipe",
		name = "gleba_nest_locator",
		category = "organic",
		enabled = true,
		energy_required = 22,
		ingredients =
		{
			{type = "item", name = "processing-unit", amount = 4},
			{type = "item", name = "wriggler_locator", amount = 2},
			{type = "item", name = "strafer_locator", amount = 2},
			{type = "item", name = "stomper_locator", amount = 2},
			{type = "item", name = "pentapod-egg", amount = 1},
			{type = "fluid", name = "gleba_sap", amount = 20}
		},
		results = {{type="item", name="gleba_nest_locator", amount=1}},
		surface_conditions =
		{
		  {
			property = "pressure",
			min = 2000,
			max = 2000
		  }
		},
	}
	,
	{
		type = "recipe",
		name = "master_locator",
		category = "cryogenics",
		enabled = true,
		energy_required = 25,
		ingredients =
		{
			{type = "item", name = "quantum-processor", amount = 2},
			{type = "item", name = "nauvis_nest_locator", amount = 1},
			{type = "item", name = "demolisher_locator", amount = 1},
			{type = "item", name = "gleba_nest_locator", amount = 1},
			{type = "item", name = "captive-biter-spawner", amount = 1},
			{type = "item", name = "bioflux", amount = 4},
			{type = "fluid", name = "nauvis_sap", amount = 20},
			{type = "fluid", name = "gleba_sap", amount = 20},
		},
		results = {{type="item", name="master_locator", amount=1}},
		surface_conditions =
		{
		  {
			property = "pressure",
			min = 0,
			max = 0
		  }
		},
	}
})
