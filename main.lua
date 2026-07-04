local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local client = Players.LocalPlayer
local character = client.Character or client.CharacterAdded:Wait()
local deadZone = Vector3.new(14, 517, -26)
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/GitLucaI/SLib/refs/heads/main/automatic"))()

client.CharacterAdded:Connect(function(c)
	character = c
end)

local roles = {}
local esp = false
local coinesp = false
local notifyroles = false
local notifygundrop = false
local getgundrop = false
local instamurdererwin = false
local autosheriffwin = false
local noclip = false
local murdereraimbot = false
local sheriffaimbot = false
local antifling = false
local autocollect = false
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

local FLYING = false
local iyflyspeed = 1
local vehicleflyspeed = 1
local vfly = false
local QEfly = true
local SPEED = 0
local CONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
local lCONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
local flyKeyDown, flyKeyUp

local function IsAlive(playerName)
	if roles[playerName] then
		return not roles[playerName].Killed and not roles[playerName].Dead
	end
	return false
end

RunService.Stepped:Connect(function()
	if noclip or autocollect and character then
		for _, part in pairs(character:GetChildren()) do
			if part:IsA("BasePart") then
				part.CanCollide = false
			end
		end
	end
end)

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

task.spawn(function()
	while task.wait(0.5) do
		if autocollect and character and character:FindFirstChild("HumanoidRootPart") then
			for _, obj in pairs(workspace:GetDescendants()) do
				if obj.Name == "Coin_Server" and obj:IsA("BasePart") and obj.Transparency < 1 then
					local root = character.HumanoidRootPart
					local targetPos = obj.Position
					local tweenInfo = TweenInfo.new(math.random(0.3, 0.8), Enum.EasingStyle.Linear)
					local tween = TweenService:Create(root, tweenInfo, {CFrame = CFrame.new(targetPos + Vector3.new(0, 3, 0))})
					tween:Play()
					tween.Completed:Wait()
					task.wait(0.1)
				end
			end
		end
	end
end)

local function updateCoinVisibility()
	for _, coin in pairs(workspace:GetDescendants()) do
		if coin.Name == "Coin_Server" and coin:IsA("BasePart") then
			coin.Transparency = coinesp and 0 or 1
			local hl = coin:FindFirstChild("Highlight")

			if coinesp then
				coin.Shape = Enum.PartType.Ball
				if not hl then
					hl = Instance.new("Highlight")
					hl.FillColor = Color3.new(1, 1, 0)
					hl.Parent = coin
				end
				hl.Enabled = true
			elseif hl then
				hl.Enabled = false
			end
		end
	end
end

RunService:BindToRenderStep("AimbotAndVisuals", Enum.RenderPriority.Camera.Value + 1, function()
	UpdateHighlights()
	local targetName = nil
	task.spawn(function()
		if murdereraimbot and Murderer.Value ~= "#" then
			targetName = Murderer.Value
		elseif sheriffaimbot then
			if Sheriff.Value ~= "#" then
				targetName = Sheriff.Value
			elseif Hero.Value ~= "#" then
				targetName = Hero.Value
			end
		end
	end)

	task.spawn(function()
		if targetName then
			local player = Players:FindFirstChild(targetName)
			if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
				camera.CFrame = CFrame.lookAt(camera.CFrame.Position, player.Character.HumanoidRootPart.Position)
			end
		end
	end)

	for _, prplayer in pairs(Players:GetPlayers()) do
		if prplayer ~= client and prplayer.Character then
			for _, part in pairs(prplayer.Character:GetChildren()) do
				if part:IsA("BasePart") and (part.Name == "HumanoidRootPart" or part.Name == "Torso" or part.Name == "LowerTorso" or part.Name == "UpperTorso") then
					part.CanCollide = not antifling
				end
			end
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

local function DoAutoSheriffWin()
	if autosheriffwin and (Sheriff.Value == client.Name or Hero.Value == client.Name) then
		task.spawn(function()
			while autosheriffwin and (Sheriff.Value == client.Name or Hero.Value == client.Name) do
				local char = client.Character
				local hum = char and char:FindFirstChild("Humanoid")
				local root = char and char:FindFirstChild("HumanoidRootPart")
				local mPlayer = Players:FindFirstChild(Murderer.Value)

				if char and hum and root and hum.Health > 0 and mPlayer and mPlayer.Character and mPlayer.Character:FindFirstChild("HumanoidRootPart") and mPlayer.Character:FindFirstChild("Humanoid") and mPlayer.Character.Humanoid.Health > 0 then
					local gun = char:FindFirstChild("Gun") or client.Backpack:FindFirstChild("Gun")
					if gun then
						hum:EquipTool(gun)
						local oldcf = root.CFrame
						local mRoot = mPlayer.Character.HumanoidRootPart

						local tpPos = mRoot.Position + Vector3.new(15, 0, 15)
						local params = RaycastParams.new()
						params.FilterDescendantsInstances = {mPlayer.Character, char}
						params.FilterType = Enum.RaycastFilterType.Exclude

						for angle = 0, 360, 45 do
							local rad = math.rad(angle)
							local offset = Vector3.new(math.cos(rad) * 15, 0, math.sin(rad) * 15)
							local checkPos = mRoot.Position + offset
							local ray = workspace:Raycast(checkPos, (mRoot.Position - checkPos), params)
							if not ray then
								tpPos = checkPos
								break
							end
						end

						root.CFrame = CFrame.lookAt(tpPos, mRoot.Position)
						root.Anchored = true

						task.wait(0.15)
						workspace.CurrentCamera.CFrame = CFrame.lookAt(workspace.CurrentCamera.CFrame.Position, mRoot.Position)
						task.wait(0.1)
						mouse1click()
						task.wait(0.3)

						root.Anchored = false
						root.CFrame = oldcf
						task.wait(1)
					end
				end
				task.wait(0.1)
			end
		end)
	end
end

local function StartFly()
	local char = client.Character
	if not char then return end

	local T = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
	local humanoid = char:FindFirstChildOfClass("Humanoid")
	if not T or not humanoid then return end

	FLYING = true
	local BG = Instance.new('BodyGyro')
	local BV = Instance.new('BodyVelocity')
	BG.P = 9e4
	BG.Parent = T
	BV.Parent = T
	BG.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
	BG.CFrame = T.CFrame
	BV.Velocity = Vector3.new(0, 0, 0)
	BV.MaxForce = Vector3.new(9e9, 9e9, 9e9)

	task.spawn(function()
		repeat task.wait()
			local camera = workspace.CurrentCamera
			if not vfly and humanoid then
				humanoid.PlatformStand = true
			end

			if CONTROL.L + CONTROL.R ~= 0 or CONTROL.F + CONTROL.B ~= 0 or CONTROL.Q + CONTROL.E ~= 0 then
				SPEED = 50
			elseif not (CONTROL.L + CONTROL.R ~= 0 or CONTROL.F + CONTROL.B ~= 0 or CONTROL.Q + CONTROL.E ~= 0) and SPEED ~= 0 then
				SPEED = 0
			end
			if (CONTROL.L + CONTROL.R) ~= 0 or (CONTROL.F + CONTROL.B) ~= 0 or (CONTROL.Q + CONTROL.E) ~= 0 then
				BV.Velocity = ((camera.CFrame.LookVector * (CONTROL.F + CONTROL.B)) + ((camera.CFrame * CFrame.new(CONTROL.L + CONTROL.R, (CONTROL.F + CONTROL.B + CONTROL.Q + CONTROL.E) * 0.2, 0).Position) - camera.CFrame.Position)) * SPEED
				lCONTROL = {F = CONTROL.F, B = CONTROL.B, L = CONTROL.L, R = CONTROL.R}
			elseif (CONTROL.L + CONTROL.R) == 0 and (CONTROL.F + CONTROL.B) == 0 and (CONTROL.Q + CONTROL.E) == 0 and SPEED ~= 0 then
				BV.Velocity = ((camera.CFrame.LookVector * (lCONTROL.F + lCONTROL.B)) + ((camera.CFrame * CFrame.new(lCONTROL.L + lCONTROL.R, (lCONTROL.F + lCONTROL.B + CONTROL.Q + CONTROL.E) * 0.2, 0).Position) - camera.CFrame.Position)) * SPEED
			else
				BV.Velocity = Vector3.new(0, 0, 0)
			end
			BG.CFrame = camera.CFrame
		until not FLYING

		CONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
		lCONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
		SPEED = 0
		if BG then BG:Destroy() end
		if BV then BV:Destroy() end
		if humanoid then humanoid.PlatformStand = false end
	end)

	flyKeyDown = UserInputService.InputBegan:Connect(function(input, processed)
		if processed then return end
		if input.KeyCode == Enum.KeyCode.W then
			CONTROL.F = (vfly and vehicleflyspeed or iyflyspeed)
		elseif input.KeyCode == Enum.KeyCode.S then
			CONTROL.B = - (vfly and vehicleflyspeed or iyflyspeed)
		elseif input.KeyCode == Enum.KeyCode.A then
			CONTROL.L = - (vfly and vehicleflyspeed or iyflyspeed)
		elseif input.KeyCode == Enum.KeyCode.D then
			CONTROL.R = (vfly and vehicleflyspeed or iyflyspeed)
		elseif input.KeyCode == Enum.KeyCode.E and QEfly then
			CONTROL.Q = (vfly and vehicleflyspeed or iyflyspeed) * 2
		elseif input.KeyCode == Enum.KeyCode.Q and QEfly then
			CONTROL.E = -(vfly and vehicleflyspeed or iyflyspeed) * 2
		end
	end)

	flyKeyUp = UserInputService.InputEnded:Connect(function(input, processed)
		if processed then return end
		if input.KeyCode == Enum.KeyCode.W then
			CONTROL.F = 0
		elseif input.KeyCode == Enum.KeyCode.S then
			CONTROL.B = 0
		elseif input.KeyCode == Enum.KeyCode.A then
			CONTROL.L = 0
		elseif input.KeyCode == Enum.KeyCode.D then
			CONTROL.R = 0
		elseif input.KeyCode == Enum.KeyCode.E then
			CONTROL.Q = 0
		elseif input.KeyCode == Enum.KeyCode.Q then
			CONTROL.E = 0
		end
	end)
end

local function StopFly()
	FLYING = false
	if flyKeyDown then flyKeyDown:Disconnect() end
	if flyKeyUp then flyKeyUp:Disconnect() end

	local char = client.Character
	if char then
		local humanoid = char:FindFirstChildOfClass('Humanoid')
		if humanoid then
			humanoid.PlatformStand = false
		end
	end
end

Murderer:GetPropertyChangedSignal("Value"):Connect(function()
	if notifyroles and Murderer.Value ~= "#" then Library:Notify("Murderer is " .. Murderer.Value) end
	DoInstaWin()
	DoAutoSheriffWin()
end)

Sheriff:GetPropertyChangedSignal("Value"):Connect(function()
	if notifyroles and Sheriff.Value ~= "#" then Library:Notify("Sheriff is " .. Sheriff.Value) end
	DoAutoSheriffWin()
end)

Hero:GetPropertyChangedSignal("Value"):Connect(function()
	if notifyroles and Hero.Value ~= "#" then Library:Notify("Hero is " .. Hero.Value) end
	DoAutoSheriffWin()
end)

Library:AddLabel("Visuals")
Library:AddToggle("Toggle ESP", false, function(state) esp = state end)
Library:AddToggle("Toggle Coins ESP", false, function(state) 
	coinesp = state 
	updateCoinVisibility()
end)
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
Library:AddToggle("Auto Sheriff/Hero Win", false, function(state)
	autosheriffwin = state
	DoAutoSheriffWin()
end)
Library:AddToggle("Auto Collect Coins", false, function(state) autocollect = state end)

Library:AddLabel("Character")
Library:AddToggle("Fly", false, function(state)
	if state then
		StartFly()
	else
		StopFly()
	end
end)
Library:AddTextbox("Fly Speed", "Multiplier", function(input)
	local newSpeed = tonumber(input)
	if newSpeed and newSpeed > 0 then
		iyflyspeed = newSpeed
	end
end)
Library:AddToggle("Noclip", false, function(state) noclip = state end)
Library:AddTextbox("WalkSpeed", "Value", function(input)
	local walkspeed = tonumber(input) or 16
	if walkspeed > 0 and character and character:FindFirstChild("Humanoid") then
		character.Humanoid.WalkSpeed = walkspeed
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
Library:AddButton("Stop Fling", function() StopFling() end)

Library:AddLabel("Other Scripts")
Library:AddButton("Infinite Yield", function()
	loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
end)
Library:AddButton("Emote Loader", function()
	loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-7yd7-I-Emote-Script-48024"))()
end)

Library:AddLabel("Place")

Library:AddButton("Rejoin Server", function() TeleportService:Teleport(game.PlaceId, client) end)

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
	elseif d.Name == "Coin_Server" and d:IsA("BasePart") then
		d.Transparency = coinesp and 0 or 1
		if coinesp then
			d.Shape = Enum.PartType.Ball
			local hl = Instance.new("Highlight")
			hl.FillColor = Color3.new(1, 1, 0)
			hl.Parent = d
		end
	end
end)

updateCoinVisibility()
