local Players = game:GetService("Players")

local checkpointFolder = workspace:WaitForChild("Checkpoints")
local checkpoint1 = checkpointFolder:WaitForChild("Checkpoint1")

-- craete a checkpint
Players.PlayerAdded:Connect(function(player)

	local checkpoint = Instance.new("IntValue")
	checkpoint.Name = "Checkpoint"
	checkpoint.Value = 0
	checkpoint.Parent = player

	-- checter spawn
	player.CharacterAdded:Connect(function(character)

		-- wait 
		local root = character:WaitForChild("HumanoidRootPart")

		-- if player reach in checkpoint check
		if player.Checkpoint.Value == 1 then
			root.CFrame = checkpoint1.CFrame + Vector3.new(0, 5, 0)
		end

	end)

end)

-- activate checkpoint1
checkpoint1.Touched:Connect(function(hit)

	local character = hit.Parent
	local player = Players:GetPlayerFromCharacter(character)

	if not player then
		return
	end

	if player.Checkpoint.Value < 1 then
		player.Checkpoint.Value = 1
		print(player.Name .. "activated Checkpoint 1")
	end

end)
