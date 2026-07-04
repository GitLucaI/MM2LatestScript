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
local cointweentime = 0.9
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

local flyToggled = false
local FLYING = false
local iyflyspeed = 1
local vehicleflyspeed = 1
local vfly = false
local QEfly = true
local SPEED = 0
local CONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
local lCONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
local flyKeyDown, flyKeyUp

local autoSheriffLoopRunning = false
local instaWinLoopRunning = false

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
		local root = char:FindFirstChild("HumanoidRootPart")
		if root then
			local bg = root:FindFirstChildOfClass("BodyGyro")
			local bv = root:FindFirstChildOfClass("BodyVelocity")
			if bg then bg:Destroy() end
			if bv then bv:Destroy() end
		end
	end
end

local function StartFly()
	local char = client.Character
	if not char then return end

	local T = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
	local humanoid = char:FindFirstChildOfClass("Humanoid")
	if not T or not humanoid then return end

	StopFly()

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
			local cam = workspace.CurrentCamera
			if not vfly and humanoid then
				humanoid.PlatformStand = true
			end

			if CONTROL.L + CONTROL.R ~= 0 or CONTROL.F + CONTROL.B ~= 0 or CONTROL.Q + CONTROL.E ~= 0 then
				SPEED = 50
			elseif not (CONTROL.L + CONTROL.R ~= 0 or CONTROL.F + CONTROL.B ~= 0 or CONTROL.Q + CONTROL.E ~= 0) and SPEED ~= 0 then
				SPEED = 0
			end
			if (CONTROL.L + CONTROL.R) ~= 0 or (CONTROL.F + CONTROL.B) ~= 0 or (CONTROL.Q + CONTROL.E) ~= 0 then
				BV.Velocity = ((cam.CFrame.LookVector * (CONTROL.F + CONTROL.B)) + ((cam.CFrame * CFrame.new(CONTROL.L + CONTROL.R, (CONTROL.F + CONTROL.B + CONTROL.Q + CONTROL.E) * 0.2, 0).Position) - cam.CFrame.Position)) * SPEED
				lCONTROL = {F = CONTROL.F, B = CONTROL.B, L = CONTROL.L, R = CONTROL.R}
			elseif (CONTROL.L + CONTROL.R) == 0 and (CONTROL.F + CONTROL.B) == 0 and (CONTROL.Q + CONTROL.E) == 0 and SPEED ~= 0 then
				BV.Velocity = ((cam.CFrame.LookVector * (lCONTROL.F + lCONTROL.B)) + ((cam.CFrame * CFrame.new(lCONTROL.L + lCONTROL.R, (lCONTROL.F + lCONTROL.B + CONTROL.Q + CONTROL.E) * 0.2, 0).Position) - cam.CFrame.Position)) * SPEED
			else
				BV.Velocity = Vector3.new(0, 0, 0)
			end
			BG.CFrame = cam.CFrame
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

client.CharacterAdded:Connect(function(c)
	character = c
	task.spawn(function()
		local root = c:WaitForChild("HumanoidRootPart", 5)
		local hum = c:WaitForChild("Humanoid", 5)
		if flyToggled and root and hum then
			task.wait(0.2)
			StartFly()
		end
	end)
end)

local function IsAlive(playerName)
	if roles[playerName] then
		return not roles[playerName].Killed and not roles[playerName].Dead
	end
	return false
end

local wasNoclip = false
RunService.Stepped:Connect(function()
	if noclip and character then
		for _, part in pairs(character:GetChildren()) do
			if part:IsA("BasePart") then
				part.CanCollide = false
			end
		end
		wasNoclip = true
	elseif wasNoclip and character then
		for _, part in pairs(character:GetChildren()) do
			if part:IsA("BasePart") then
				if part.Name == "Torso" or part.Name == "UpperTorso" or part.Name == "LowerTorso" or part.Name == "Head" or part.Name == "HumanoidRootPart" then
					part.CanCollide = true
				end
			end
		end
		wasNoclip = false
	end
end)

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
	local collectedCount = 0
	local currentTween = nil
	while task.wait(0.5) do
		local hum = character and character:FindFirstChild("Humanoid")
		if autocollect and character and character:FindFirstChild("HumanoidRootPart") and hum and hum.Health > 0 then
			local coins = {}
			for _, obj in pairs(workspace:GetDescendants()) do
				if obj.Name == "Coin_Server" and obj:IsA("BasePart") and obj.Transparency < 1 then
					table.insert(coins, obj)
				end
			end

			for _, obj in pairs(coins) do
				if not autocollect or not hum or hum.Health <= 0 then break end
				if not obj.Parent or obj.Transparency >= 1 then continue end

				local root = character:FindFirstChild("HumanoidRootPart")
				if not root then break end

				local targetPos = obj.Position

				if (root.Position - targetPos).Magnitude <= 1000 then
					local tweenInfo = TweenInfo.new(cointweentime, Enum.EasingStyle.Linear)
					currentTween = TweenService:Create(root, tweenInfo, {CFrame = CFrame.new(targetPos + Vector3.new(0, 3, 0))})

					local bv = Instance.new("BodyVelocity")
					bv.MaxForce = Vector3.new(100000, 100000, 100000)
					bv.Velocity = Vector3.zero
					bv.Parent = root

					local coinConn
					coinConn = obj.AncestryChanged:Connect(function(_, parent)
						if not parent and currentTween then
							currentTween:Cancel()
						end
					end)

					currentTween:Play()
					currentTween.Completed:Wait()

					if coinConn then coinConn:Disconnect() end
					if bv then bv:Destroy() end
					currentTween = nil

					collectedCount = collectedCount + 1
					if collectedCount >= 5 then
						task.wait(math.random(1, 3))
						collectedCount = 0
					end

					task.wait(0.1)
				end
			end
		elseif currentTween then
			currentTween:Cancel()
			currentTween = nil
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
		elseif coin.Name == "GunDrop" then
			coin.Transparency = coinesp and 0 or 1
			local hl = coin:FindFirstChild("Highlight")

			if coinesp then
				coin.Shape = Enum.PartType.Ball
				if not hl then
					hl = Instance.new("Highlight")
					hl.FillColor = Color3.new(0, 0.65, 0)
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
		if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			camera.CFrame = CFrame.lookAt(camera.CFrame.Position, player.Character.HumanoidRootPart.Position)
		end
	end

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
	if not instamurdererwin or instaWinLoopRunning then return end
	instaWinLoopRunning = true
	task.spawn(function()
		while instamurdererwin do
			if Murderer.Value == client.Name then
				local char = client.Character
				local hum = char and char:FindFirstChild("Humanoid")
				local root = char and char:FindFirstChild("HumanoidRootPart")

				if char and hum and root then
					local knife = char:FindFirstChild("Knife") or client.Backpack:FindFirstChild("Knife")
					if knife then
						hum:EquipTool(knife)
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
			end
			task.wait(0.1)
		end
		instaWinLoopRunning = false
	end)
end

local function DoAutoSheriffWin()
	if not autosheriffwin or autoSheriffLoopRunning then return end
	autoSheriffLoopRunning = true
	task.spawn(function()
		while autosheriffwin do
			local char = client.Character
			local hum = char and char:FindFirstChild("Humanoid")
			local root = char and char:FindFirstChild("HumanoidRootPart")
			local mPlayer = Players:FindFirstChild(Murderer.Value)

			if char and hum and root and hum.Health > 0 and mPlayer and mPlayer.Character then
				local mRoot = mPlayer.Character:FindFirstChild("HumanoidRootPart")
				local mHum = mPlayer.Character:FindFirstChild("Humanoid")

				if mRoot and mHum and mHum.Health > 0 then
					local gun = char:FindFirstChild("Gun") or client.Backpack:FindFirstChild("Gun")
					if gun then
						hum:EquipTool(gun)
						local oldcf = root.CFrame
						local tpPos = mRoot.Position + Vector3.new(15, 0, 15)

						local params = RaycastParams.new()
						params.FilterDescendantsInstances = {mPlayer.Character, char}
						params.FilterType = Enum.RaycastFilterType.Exclude

						local checkRay = workspace:Raycast(mRoot.Position, Vector3.new(15, 0, 15), params)
						if checkRay then
							tpPos = mRoot.Position + Vector3.new(0, 15, 0)
						end

						local startLock = tick()
						while tick() - startLock < 0.6 do
							if not mPlayer.Character or not mPlayer.Character:FindFirstChild("HumanoidRootPart") or mHum.Health <= 0 then break end

							local currentMRootPos = mPlayer.Character.HumanoidRootPart.Position
							root.CFrame = CFrame.lookAt(tpPos, currentMRootPos)
							root.AssemblyLinearVelocity = Vector3.zero
							root.AssemblyAngularVelocity = Vector3.zero
							workspace.CurrentCamera.CFrame = CFrame.lookAt(workspace.CurrentCamera.CFrame.Position, currentMRootPos)

							task.wait()
						end

						mouse1click()
						task.wait(0.3)

						root.CFrame = oldcf
						task.wait(1)
					end
				end
			end
			task.wait(0.1)
		end
		autoSheriffLoopRunning = false
	end)
end

Murderer:GetPropertyChangedSignal("Value"):Connect(function()
	if notifyroles and Murderer.Value ~= "#" then Library:Notify("Murderer is " .. Murderer.Value) end
end)

Sheriff:GetPropertyChangedSignal("Value"):Connect(function()
	if notifyroles and Sheriff.Value ~= "#" then Library:Notify("Sheriff is " .. Sheriff.Value) end
end)

Hero:GetPropertyChangedSignal("Value"):Connect(function()
	if notifyroles and Hero.Value ~= "#" then Library:Notify("Hero is " .. Hero.Value) end
end)

Library:AddLabel("Visuals")
Library:AddToggle("Toggle ESP", false, function(state) esp = state end)
Library:AddToggle("Toggle Collectables ESP", false, function(state) 
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
	if state then DoInstaWin() end
end)
Library:AddToggle("Auto Sheriff/Hero Win", false, function(state)
	autosheriffwin = state
	if state then DoAutoSheriffWin() end
end)
Library:AddTextbox("Coin Tween Time", "Value", function(input)
	local ctt = tonumber(input) or 0.9
	cointweentime = ctt
end)
Library:AddToggle("Auto Collect Coins", false, function(state) autocollect = state end)

Library:AddLabel("Character")
Library:AddToggle("Fly", false, function(state)
	flyToggled = state
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
		d.Shape = Enum.PartType.Ball
		local hl = Instance.new("Highlight")
		hl.FillColor = Color3.new(0, 0.75, 0)
		hl.Parent = d
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
