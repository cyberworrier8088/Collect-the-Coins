local Players = game:GetService("Players")

local checkpointFolder = workspace:WaitForChild("Checkpoints")

Players.PlayerAdded:Connect(function(player)

	local checkpoint = Instance.new("IntValue")
	checkpoint.Name = "Checkpoint"
	checkpoint.Value = 0
	checkpoint.Parent = player

	player.CharacterAdded:Connect(function(character)

		local root = character:WaitForChild("HumanoidRootPart")

		if checkpoint.Value > 0 then
			local checkpointPart = checkpointFolder:FindFirstChild(tostring(checkpoint.Value))

			if checkpointPart then
				root.CFrame = checkpointPart.CFrame + Vector3.new(0, 5, 0)
			end
		end

	end)

end)

for _, checkpointPart in ipairs(checkpointFolder:GetChildren()) do

	checkpointPart.Touched:Connect(function(hit)

		local character = hit.Parent
		local player = Players:GetPlayerFromCharacter(character)

		if not player then
			return
		end

		local checkpointNumber = tonumber(checkpointPart.Name)

		if checkpointNumber and player.Checkpoint.Value < checkpointNumber then
			player.Checkpoint.Value = checkpointNumber
			print(player.Name .. " reached checkpoint " .. checkpointNumber)
		end

	end)

end