-- checkpoint  system of the game :)

local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")

local checkpointStore = DataStoreService:GetDataStore("CheckpointData")
local checkpointFolder = workspace:WaitForChild("Checkpoints")

Players.PlayerAdded:Connect(function(player)

	-- leaderboard
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player

	local stage = Instance.new("IntValue")
	stage.Name = "Stage"
	stage.Value = 0
	stage.Parent = leaderstats

	-- checkpoint
	local checkpoint = Instance.new("IntValue")
	checkpoint.Name = "Checkpoint"
	checkpoint.Value = 0
	checkpoint.Parent = player

	-- load saved checkpoint
	local success, savedCheckpoint = pcall(function()
		return checkpointStore:GetAsync(player.UserId)
	end)

	if success and savedCheckpoint then
		checkpoint.Value = savedCheckpoint
		stage.Value = savedCheckpoint
		print("Loaded checkpoint:", savedCheckpoint)
	else
		print("No saved checkpoint found.")
	end

	-- respawn at saved checkpoint
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

-- checkpoint system
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
			player.leaderstats.Stage.Value = checkpointNumber

			checkpointPart.Color = Color3.fromRGB(0, 255, 0)

			print(player.Name .. " reached checkpoint " .. checkpointNumber)
		end

	end)

end

-- save checkpoint
Players.PlayerRemoving:Connect(function(player)

	local success, errorMessage = pcall(function()
		checkpointStore:SetAsync(player.UserId, player.Checkpoint.Value)
	end)

	if success then
		print("Checkpoint saved!")
	else
		warn("Failed to save checkpoint:", errorMessage)
	end

end)


-- finish System
local finishFolder = workspace:WaitForChild("Finish")

for _, finishPart in ipairs(finishFolder:GetChildren()) do

	finishPart.Touched:Connect(function(hit)

		local character = hit.Parent
		local player = Players:GetPlayerFromCharacter(character)

		if not player then
			return
		end

		-- prevent multiple wins while standing on the finish
		if finishPart:GetAttribute(player.UserId) then
			return
		end

		finishPart:SetAttribute(player.UserId, true)

		-- Give the player a win
		player.leaderstats.Wins.Value += 1

		-- Reset checkpoint
		player.Checkpoint.Value = 0
		player.leaderstats.Stage.Value = 0

		print("🎉 YAY! " .. player.Name .. " WON THE OBBY!")

		-- respawn at the start
		player:LoadCharacter()

		-- allow another win after 2 seconds
		task.wait(2)
		finishPart:SetAttribute(player.UserId, nil)

	end)

end