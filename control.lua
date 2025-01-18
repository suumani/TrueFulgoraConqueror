-- ----------------------------
-- �t���S���̋���Ȉ�Ղ���́A���܂Ƀo�C�^�[�̑���f�����b�V���[����������
-- ----------------------------

-- ----------------------------
-- �^�C�}�[�C�x���g
-- ----------------------------
script.on_event(defines.events.on_tick, function(event)

	-- �t���S�����b�V���̎��s
	-- if(game.tick % 3600 == 0) then --1��
	if(game.tick % 108000 == 0) then --30��
		local fulgora_surface = game.surfaces["fulgora"]
		if fulgora_surface ~= nil then
			local evolution_factor = game.forces["enemy"].get_evolution_factor(fulgora_surface)
			fulgora_rush(fulgora_surface, evolution_factor)
		end
	end
	
end)

-- ----------------------------
-- �t���S�����b�V��
-- ----------------------------
function fulgora_rush(fulgora_surface, evolution_factor)
	-- �f�����b�V���[�̐�
	local demolisher_count = #(fulgora_surface.find_entities_filtered{force = "enemy", name = {"small-demolisher","medium-demolisher","big-demolisher"}})
	
	-- �t���S���̃t���S���̒����ɂ̈�\�����30��������100%�̊m���Ńo�C�^�[�̑��ƃ��[����3��������A�����ł��Ȃ��ꍇ�̓f�����b�V���[���肪����
	fulgora_rush_vault(fulgora_surface, evolution_factor, demolisher_count)
	
	-- �t���S���̒�����Ȉ�Ղ����30������100%�̊m���Ńo�C�^�[�̑��ƃ��[����1��������A�����ł��Ȃ��ꍇ�̓f�����b�V���[���肪����
	fulgora_rush_colossal(fulgora_surface, evolution_factor, demolisher_count)
	
	-- �t���S���̋���Ȉ�Ղ����30������10%�̊m���Ńo�C�^�[�̑��ƃ��[������������A�����ł��Ȃ��ꍇ�̓f�����b�V���[���肪����
	fulgora_rush_huge(fulgora_surface, evolution_factor, demolisher_count)
	
	-- �o�C�^�[�̑�
	-- local spawners = fulgora_surface.find_entities_filtered{name = "biter-spawner"}
	-- local spitterspawners = fulgora_surface.find_entities_filtered{name = "spitter-spawner"}
	-- game.print("total = " .. (#spawners+#spitterspawners))
end

-- ----------------------------
-- �t���S���̃t���S���̒����ɂ̈�\�����30��������100%�̊m���Ńo�C�^�[�̑��ƃ��[����3��������A�����ł��Ȃ��ꍇ�̓f�����b�V���[���肪����
-- ----------------------------
function fulgora_rush_vault(fulgora_surface, evolution_factor, demolisher_count)
	local ruins = fulgora_surface.find_entities_filtered{name = "fulgoran-ruin-vault"}
	-- game.print("#vaults = "..#ruins)
	if ruins ~= nil and #ruins ~= 0 then
		for _, ruin in pairs(ruins) do
			local result = "success"
			for i = 0, 3, 1 do
				local result2 = place_spawner_around(fulgora_surface, evolution_factor, ruin.position)
				if result2 == "failed" then
					result = "failed"
				end
			end
			if(result == "failed") then
				-- �f�����b�V���[�z�u�g���C(�X�|�i�[10�Ńf�����b�V���[����)
				try_place_demolisher(fulgora_surface, evolution_factor, ruin.position, demolisher_count)
			end
		end
	end
end

-- ----------------------------
-- �f�����b�V���[�z�u�g���C(�X�|�i�[10�Ńf�����b�V���[����)
-- ----------------------------
function try_place_demolisher(fulgora_surface, evolution_factor, center_position, demolisher_count)
	local biter_spawners = fulgora_surface.find_entities_filtered{
		name = "biter-spawner", 
		area = {{center_position.x - 20, center_position.y - 20}, {center_position.x + 20, center_position.y + 20}}
	}
	local spitter_spawners = fulgora_surface.find_entities_filtered{
		name = "spitter-spawner", 
		area = {{center_position.x - 20, center_position.y - 20}, {center_position.x + 20, center_position.y + 20}}
	}
	local spawner_count = #biter_spawners + #spitter_spawners
	if spawner_count >= 10 and demolisher_count < 100 then
		game.print("Demolishers have emerged from the depths beneath Fulgora...")
		fulgora_surface.create_entity{name = demolisher_name(evolution_factor), position = center_position, quality = choose_quality(evolution_factor),force = "enemy"}
	end
end


-- ----------------------------
-- �f�����b�V���[�̃T�C�Y����
-- ----------------------------
function demolisher_name(evolution_factor)
	local r = math.random()
	-- �i��0.3����
	if evolution_factor < 0.3 then
		return "small-demolisher"
	-- �i��0.5����
	elseif evolution_factor < 0.5 then
		if r < 0.5 then
			return "small-demolisher"
		else
			return "medium-demolisher"
		end
	-- �i��0.9����
	elseif evolution_factor < 0.9 then
		if r < 0.5 then
			return "medium-demolisher"
		else
			return "big-demolisher"
		end
	-- �i��0.9�ȏ�
	else
		return "big-demolisher"
	end
end

-- ----------------------------
-- �t���S���̒�����Ȉ�Ղ����30������100%�̊m���Ńo�C�^�[�̑��ƃ��[����1��������
-- ----------------------------
function fulgora_rush_colossal(fulgora_surface, evolution_factor, demolisher_count)
	local ruins = fulgora_surface.find_entities_filtered{name = "fulgoran-ruin-colossal"}
	-- game.print("#colossals = "..#ruins)
	if ruins ~= nil and #ruins ~= 0 and math.random() < 0.1 then
		for _, ruin in pairs(ruins) do
			local result = place_spawner_around(fulgora_surface, evolution_factor, ruin.position)
			if(result == "failed") then
				-- �f�����b�V���[�z�u�g���C(�X�|�i�[10�Ńf�����b�V���[����)
				try_place_demolisher(fulgora_surface, evolution_factor, ruin.position, demolisher_count)
			end
		end
	end
end

-- ----------------------------
-- �t���S���̋���Ȉ�Ղ����30������10%�̊m���Ńo�C�^�[�̑��ƃ��[������������
-- ----------------------------
function fulgora_rush_huge(fulgora_surface, evolution_factor, demolisher_count)
	local ruins = fulgora_surface.find_entities_filtered{name = "fulgoran-ruin-huge"}
	-- game.print("#huges = "..#ruins)
	if ruins ~= nil and #ruins ~= 0 then
		for _, ruin in pairs(ruins) do
			local result = place_spawner_around(fulgora_surface, evolution_factor, ruin.position)
			if(result == "failed") then
				-- �f�����b�V���[�z�u�g���C(�X�|�i�[10�Ńf�����b�V���[����)
				try_place_demolisher(fulgora_surface, evolution_factor, ruin.position, demolisher_count)
			end
		end
	end
end

-- ----------------------------
-- ���Ӎ��W�Ƀo�C�^�[���X�s�b�^�[�̑���z�u����
-- ----------------------------
function place_spawner_around(fulgora_surface, evolution_factor, center_position)
	local spawn_position = {x = center_position.x + math.random(-20, 20), y = center_position.y + math.random(-20, 20)}
	if fulgora_surface.can_place_entity{name = "spitter-spawner", position = spawn_position} then
		place_spawner(fulgora_surface, evolution_factor, spawn_position)
		return "success"
	else 
		return "failed"
	end
end

-- ----------------------------
-- �w����W�Ƀo�C�^�[���X�s�b�^�[�̑���z�u����
-- ----------------------------
function place_spawner(fulgora_surface, evolution_factor, spawn_position)
	local quality = choose_quality(evolution_factor)
	local r = math.random()
	if(r < 0.5) then
		fulgora_surface.create_entity{name = "biter-spawner", position = spawn_position, quality = quality, force = "enemy"}
	else
		fulgora_surface.create_entity{name = "spitter-spawner", position = spawn_position, quality = quality, force = "enemy"}
	end
end

-- ----------------------------
-- �i���̌���
-- ----------------------------
function choose_quality(evolution_factor)
	-- �ύX�Ȃ����normal
	local quality = "normal"
	local r = math.random()
	
	if evolution_factor < 0.1 then
		if r < 0.01 then
			-- ���A1��
			return "rare"
		elseif r < 0.1 then
			-- �A���R����9��
			return "uncommon"
		end
		
	elseif evolution_factor < 0.2 then
		if r < 0.05 then
			-- ���A5��
			return "rare"
		elseif r < 0.2 then
			-- �A���R����15��
			return "uncommon"
		end
	
	elseif evolution_factor < 0.3 then
		if r < 0.1 then
			-- ���A10��
			return "rare"
		elseif r < 0.3 then
			-- �A���R����20��
			return "uncommon"
		end
	
	elseif evolution_factor < 0.4 then
		if r < 0.01 then
			-- �G�s�b�N1��
			return "epic"
		elseif r < 0.16 then
			-- ���A15��
			return "rare"
		elseif r < 0.4 then
			-- �A���R����24��
			return "uncommon"
		end
	
	elseif evolution_factor < 0.5 then
		if r < 0.05 then
			-- �G�s�b�N5��
			return "epic"
		elseif r < 0.25 then
			-- ���A20��
			return "rare"
		elseif r < 0.5 then
			-- �A���R����25��
			return "uncommon"
		end
	
	elseif evolution_factor < 0.6 then
		if r < 0.10 then
			-- �G�s�b�N10��
			return "epic"
		elseif r < 0.3 then
			-- ���A20��
			return "rare"
		elseif r < 0.6 then
			-- �A���R����30��
			return "uncommon"
		end
	
	elseif evolution_factor < 0.7 then
		if r < 0.01 then
			-- ���W�F���h
			return "legendary"
		elseif r < 0.16 then
			-- �G�s�b�N15��
			return "epic"
		elseif r < 0.41 then
			-- ���A25��
			return "rare"
		elseif r < 0.7 then
			-- �A���R����29��
			return "uncommon"
		end
	
	elseif evolution_factor < 0.8 then
		if r < 0.05 then
			-- ���W�F���h5%
			return "legendary"
		elseif r < 0.25 then
			-- �G�s�b�N20��
			return "epic"
		elseif r < 0.55 then
			-- ���A30��
			return "rare"
		elseif r < 0.8 then
			-- �A���R����25��
			return "uncommon"
		end
	
	elseif evolution_factor < 0.9 then
		if r < 0.1 then
			-- ���W�F���h10%
			return "legendary"
		elseif r < 0.35 then
			-- �G�s�b�N25��
			return "epic"
		elseif r < 0.65 then
			-- ���A30��
			return "rare"
		elseif r < 0.9 then
			-- �A���R����25��
			return "uncommon"
		end
	
	elseif evolution_factor < 0.95 then
		if r < 0.2 then
			-- ���W�F���h20%
			return "legendary"
		elseif r < 0.5 then
			-- �G�s�b�N30��
			return "epic"
		elseif r < 0.75 then
			-- ���A25��
			return "rare"
		elseif r < 0.95 then
			-- �A���R����20��
			return "uncommon"
		end
	
	elseif evolution_factor < 0.98 then
		if r < 0.34 then
			-- ���W�F���h34%
			return "legendary"
		elseif r < 0.64 then
			-- �G�s�b�N30��
			return "epic"
		elseif r < 0.84 then
			-- ���A20��
			return "rare"
		elseif r < 0.99 then
			-- �A���R����15��
			return "uncommon"
		end
	
	else
		if r < 0.5 then
			-- ���W�F���h50%
			return "legendary"
		elseif r < 0.85 then
			-- �G�s�b�N35��
			return "epic"
		elseif r < 0.95 then
			-- ���A10��
			return "rare"
		else
			-- �A���R����5��
			return "uncommon"
		end
	
	end
	return "normal"
end