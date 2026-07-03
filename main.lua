local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local client = Players.LocalPlayer
local character = client.Character or client.CharacterAdded:Wait()
local deadZone = Vector3.new(14, 517, -26)
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/GitLucaI/SLib/refs/heads/main/automatic"))()
client.CharacterAdded:Connect(function(c)
	character = c
end)



local roles = {}
local esp = false
local notifyroles = false
local notifygundrop = false
local getgundrop = false
local instamurdererwin = false
local noclip = false
local murdereraimbot = false
local sheriffaimbot = false
local antifling = false
local Murderer = Instance.new("StringValue")
local Sheriff = Instance.new("StringValue")
local Hero = Instance.new("StringValue")
local camera = workspace.CurrentCamera
Murderer.Value = "#"
Sheriff.Value = "#"
Hero.Value = "#"

local shownames = Instance.new("BoolValue")
shownames.Value = false

local flinging = false
local flingConn = nil
local currentSpin = nil
local originalCFrame = nil


local function IsAlive(playerName)
	if roles[playerName] then
		return not roles[playerName].Killed and not roles[playerName].Dead
	end
	return false
end

local function UpdateCharacterRender()
	if character then
		for _, part in pairs(character:GetChildren()) do
			if part:IsA("BasePart") and (part.Name == "HumanoidRootPart" or part.Name == "Torso" or part.Name == "LowerTorso" or part.Name == "UpperTorso") then
				part.CanCollide = not noclip
			end
		end
	end
end

local function getTarget(input)
	if input == "" then return nil end 
	input = string.lower(input)
	for _, player in pairs(Players:GetPlayers()) do
		if player ~= client then
			local name = string.lower(player.Name)
			local displayName = string.lower(player.DisplayName)
			if string.sub(name, 1, #input) == input or string.sub(displayName, 1, #input) == input then
				return player	
			end
		end
	end
	return nil
end

local function UpdateHighlights()
	for _, v in pairs(Players:GetPlayers()) do
		if v ~= client and v.Character then
			local highlight = v.Character:FindFirstChild("Highlight")
			if esp then
				if not highlight then 
					highlight = Instance.new("Highlight", v.Character) 
				end
				highlight.Enabled = true

				if v.Name == Murderer.Value then
					highlight.FillColor = Color3.fromRGB(255, 0, 0)
				elseif v.Name == Sheriff.Value then
					highlight.FillColor = Color3.fromRGB(0, 0, 255)
				elseif v.Name == Hero.Value then
					highlight.FillColor = Color3.fromRGB(255, 255, 0)
				else
					highlight.FillColor = Color3.fromRGB(0, 255, 0)
				end
			elseif highlight then
				highlight.Enabled = false
			end

			local hum = v.Character:FindFirstChild("Humanoid")
			if hum then
				if shownames.Value == true then
					hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.Subject
					hum.NameDisplayDistance = math.huge
					hum.HealthDisplayDistance = math.huge
				else
					hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
				end
			end
		end
	end
end

	RunService.RenderStepped:Connect(function()
		UpdateHighlights()
		UpdateCharacterRender()
		task.spawn(function()
		for _, prplayer in pairs(Players:GetPlayers()) do
			if prplayer ~= client and prplayer.Character then
				for _, part in pairs(prplayer.Character:GetChildren()) do
					if part:IsA("BasePart") and part.Name == "HumanoidRootPart" or part.Name == "Torso" or part.Name == "LowerTorso" or part.Name == "UpperTorso" then
						part.CanCollide = not antifling.Value
					end
				end
			end
		end
		end)
		local camera = workspace.CurrentCamera
		local targetName = nil
		if murdereraimbot and Murderer.Value ~= "#" then
			targetName = Murderer.Value
		elseif sheriffaimbot then
			if Sheriff.Value ~= "#" then
				targetName = Sheriff.Value
			elseif Hero.Value ~= "#" then
				targetName = Hero.Value
			end
		end

		if targetName then
			local player = Players:FindFirstChild(targetName)
			print(1)
			if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
				print(2)
				camera.CFrame = CFrame.new(camera.CFrame.Position, player.Character.HumanoidRootPart.Position)
			end
		end
	end)


local function TeleportTo(targetName)
	local targetPlayer = Players:FindFirstChild(targetName)
	if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
		local char = client.Character
		if char and char:FindFirstChild("HumanoidRootPart") then
			char.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
		end
	end
end

local function StopFling()
	if not flinging then return end
	flinging = false

	if flingConn then flingConn:Disconnect() end
	if currentSpin then currentSpin:Destroy() end

	local char = client.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	local hum = char and char:FindFirstChild("Humanoid")

	if hum then
		hum.PlatformStand = false
	end

	if char then
		for _, v in pairs(char:GetDescendants()) do
			if v:IsA("BasePart") then
				if v.Name == "Torso" or v.Name == "UpperTorso" or v.Name == "Head" or v.Name == "HumanoidRootPart" then
					v.CanCollide = true
				end
			end
		end
	end

	if root and originalCFrame then
		root.CFrame = originalCFrame
		root.AssemblyLinearVelocity = Vector3.zero
		root.AssemblyAngularVelocity = Vector3.zero
	end
	originalCFrame = nil
end

local function StartFling(targetName)
	if targetName == "#" or targetName == "" then return end
	local targetPlayer = Players:FindFirstChild(targetName)
	if not targetPlayer then return end

	local char = client.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	local hum = char and char:FindFirstChild("Humanoid")
	if not root or not hum then return end

	if flinging then StopFling() end

	flinging = true
	originalCFrame = root.CFrame
	hum.PlatformStand = true

	for _, v in pairs(char:GetDescendants()) do
		if v:IsA("BasePart") then v.CanCollide = false end
	end

	currentSpin = Instance.new("BodyAngularVelocity")
	currentSpin.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
	currentSpin.P = math.huge
	currentSpin.AngularVelocity = Vector3.new(0, 50000, 0)
	currentSpin.Parent = root

	flingConn = RunService.Heartbeat:Connect(function()
		if not flinging then return end

		local tChar = targetPlayer.Character
		local tRoot = tChar and tChar:FindFirstChild("HumanoidRootPart")
		local tHum = tChar and tChar:FindFirstChild("Humanoid")

		if not IsAlive(targetName) or not tRoot or not tHum or tHum.Health <= 0 then
			StopFling()
			return
		end

		root.CFrame = tRoot.CFrame + (tRoot.AssemblyLinearVelocity * 0.5)
	end)
end

local function DoInstaWin()
	if instamurdererwin and Murderer.Value == client.Name then
		task.spawn(function()
			local char = client.Character
			local hum = char and char:FindFirstChild("Humanoid")
			local root = char and char:FindFirstChild("HumanoidRootPart")

			if char and hum and root then
				local knife = char:FindFirstChild("Knife") or client.Backpack:FindFirstChild("Knife")
				if knife then
					hum:EquipTool(knife)
					task.wait(0.1)

					for _, player in pairs(Players:GetPlayers()) do
						if player ~= client then
							while player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 and player.Character:FindFirstChild("HumanoidRootPart") and hum.Health > 0 and instamurdererwin do
								local tRoot = player.Character.HumanoidRootPart
								if (tRoot.Position - deadZone).Magnitude < 1000 then
									break
								end
								root.CFrame = tRoot.CFrame
								mouse1click()
								task.wait()
							end
						end
					end
				end
			end
		end)
	end
end

Murderer:GetPropertyChangedSignal("Value"):Connect(function()
	if notifyroles and Murderer.Value ~= "#" then Library:Notify("Murderer is " .. Murderer.Value) end
	DoInstaWin()
end)

Sheriff:GetPropertyChangedSignal("Value"):Connect(function()
	if notifyroles and Sheriff.Value ~= "#" then Library:Notify("Sheriff is " .. Sheriff.Value) end
end)

Hero:GetPropertyChangedSignal("Value"):Connect(function()
	if notifyroles and Hero.Value ~= "#" then Library:Notify("Hero is " .. Hero.Value) end
end)


Library:AddLabel("Visuals")
Library:AddToggle("Toggle ESP", false, function(state) esp = state end)
Library:AddToggle("Show Names", false, function(state) shownames.Value = state end)

Library:AddLabel("Notify")
Library:AddToggle("Notify Roles", false, function(state) notifyroles = state end)
Library:AddToggle("Notify Gundrop", false, function(state) notifygundrop = state end)

Library:AddLabel("Auto")
Library:AddToggle("Auto Gundrop", false, function(state) getgundrop = state end)
Library:AddToggle("Insta Murderer Win", false, function(state) 
	instamurdererwin = state 
	DoInstaWin()
end)

Library:AddLabel("Character")
Library:AddToggle("Noclip", false, function(state) noclip = state end)
Library:AddTextbox("WalkSpeed", "Value", function(input)
	local walkspeed = tonumber(input) or 16
	if walkspeed > 0 then
		char.Humanoid.WalkSpeed = walkspeed
	end
end)
Library:AddToggle("Antifling", false, function(state) antifling = state end)


Library:AddLabel("Teleport")
Library:AddButton("Teleport to Murderer", function() TeleportTo(Murderer.Value) end)
Library:AddButton("Teleport to Sheriff", function() TeleportTo(Sheriff.Value) end)
Library:AddButton("Teleport to Hero", function() TeleportTo(Hero.Value) end)
Library:AddLabel("Camera")

Library:AddTextbox("Field of View", "FOV", function(input)
	local fov = tonumber(input) or 70
	workspace.CurrentCamera.FieldOfView = fov
end)

Library:AddToggle("Murderer Aimbot", false, function(state) murdereraimbot = state end)
Library:AddToggle("Sheriff Aimbot", false, function(state) sheriffaimbot = state end)

Library:AddLabel("Fling")
Library:AddButton("Fling Murderer", function() StartFling(Murderer.Value) end)
Library:AddButton("Fling Sheriff", function() StartFling(Sheriff.Value) end)
Library:AddButton("Fling Hero", function() StartFling(Hero.Value) end)

--Library:AddTextbox("Fling Player", "Target Name", function(input)
--	local target = getTarget(input)
--	if target then
--		StartFling(target.Name)
--	else
--		Library:Notify("Player not found!")
--	end
--end)

Library:AddButton("Stop Fling", function() StopFling() end)
Library:AddButton("Rejoin Server", function() TeleportService:Teleport(game.PlaceId, client) end)
Library:AddLabel("Other Scripts")
Library:AddButton("Inifnite Yield", function() loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))() end)
Library:AddButton("7yd7 Emotes", function() loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-7yd7-I-Emote-Script-48024"))() end)
task.spawn(function()
	while task.wait(0.5) do
		local success, data = pcall(function()
			return ReplicatedStorage:FindFirstChild("GetPlayerData", true):InvokeServer()
		end)

		if success and type(data) == "table" then
			roles = data
			local M, S, H = "#", "#", "#"
			for name, info in pairs(roles) do
				if IsAlive(name) then
					if info.Role == "Murderer" then M = name
					elseif info.Role == "Sheriff" then S = name
					elseif info.Role == "Hero" then H = name end
				end
			end 
			Murderer.Value = M
			Sheriff.Value = S
			Hero.Value = H
		end
	end
end)


workspace.DescendantAdded:Connect(function(d)
	if d.Name == "GunDrop" and d:IsA("Part") then
		if getgundrop then
			task.spawn(function()
				task.wait(0.1)
				local char = client.Character
				if char and char.PrimaryPart then
					local oldcf = char.PrimaryPart.CFrame
					char.PrimaryPart.CFrame = d.CFrame
					task.wait(0.1)
					if char.PrimaryPart then
						char.PrimaryPart.CFrame = oldcf
					end
				end
			end)
		end
		if notifygundrop then
			task.spawn(function()
				Library:Notify("Gundrop has spawned") 
			end)
		end
	end
end)
