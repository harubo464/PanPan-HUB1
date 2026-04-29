local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/jensonhirst/Orion/main/source"))()

local Window = OrionLib:MakeWindow({
	Name = "PanPan HUB",
	HidePremium = false,
	SaveConfig = false
})

local Main = Window:MakeTab({Name = "Main", Icon = "rbxassetid://4483345998"})
Main:AddToggle({Name = "近づいたらぶっ飛ばす", Default = false, Callback = function(v) getgenv().AutoFling = v end})
Main:AddSlider({Name = "有効距離", Min = 5, Max = 30, Default = 15, Increment = 1, Callback = function(v) getgenv().FlingDistance = v end})
Main:AddSlider({Name = "飛ばす強さ", Min = 50, Max = 600, Default = 250, Increment = 10, Callback = function(v) getgenv().FlingPower = v end})
Main:AddSlider({Name = "足のスピード", Min = 16, Max = 500, Default = 16, Increment = 1, Callback = function(v) getgenv().WalkSpeed = v end})
Main:AddToggle({Name = "Infinite Jump", Default = false, Callback = function(v) getgenv().InfJump = v end})

local Miss = Window:MakeTab({Name = "Miss", Icon = "rbxassetid://6031094678"})
Miss:AddToggle({Name = "プレイヤーを引き寄せ", Default = false, Callback = function(v) getgenv().PullPlayer = v end})
Miss:AddToggle({Name = "プレイヤーを掴む", Default = false, Callback = function(v) getgenv().GrabPlayer = v end})
Miss:AddToggle({Name = "毒ダメージを与える", Default = false, Callback = function(v) getgenv().PoisonDamage = v end})
Miss:AddToggle({Name = "自分がプレイヤーにくっ付く", Default = false, Callback = function(v) getgenv().AttachToPlayer = v end})

local TeleportTab = Window:MakeTab({Name = "Teleport", Icon = "rbxassetid://6035190846"})
local savedCFrame = nil
TeleportTab:AddButton({Name = "今の位置を保存する", Callback = function()
	local root = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	if root then savedCFrame = root.CFrame; print("位置保存") end
end})
TeleportTab:AddButton({Name = "保存した位置に戻る", Callback = function()
	if savedCFrame then
		local root = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
		if root then root.CFrame = savedCFrame end
	end
end})
TeleportTab:AddToggle({Name = "プレイヤーにテレポート", Default = false, Callback = function(v) getgenv().TeleportToPlayer = v end})

local SilentTab = Window:MakeTab({Name = "Silent", Icon = "rbxassetid://6035047377"})
SilentTab:AddToggle({Name = "Silent Aim", Default = false, Callback = function(v) getgenv().SilentAim = v end})

local BlobmanTab = Window:MakeTab({Name = "Blobman", Icon = "rbxassetid://6031075939"})
local blobman = nil
BlobmanTab:AddToggle({
	Name = "ブロブマンを出現",
	Default = false,
	Callback = function(state)
		if state then
			if not blobman then
				blobman = Instance.new("Model")
				blobman.Name = "Blobman"
				local torso = Instance.new("Part", blobman); torso.Name = "Torso"; torso.Size = Vector3.new(2.5,3.5,2.5); torso.Color = Color3.fromRGB(255,170,0); torso.Material = Enum.Material.Neon; torso.Anchored = true; torso.CanCollide = false
				local head = Instance.new("Part", blobman); head.Name = "Head"; head.Size = Vector3.new(2,2,2); head.Color = Color3.fromRGB(255,170,0); head.Material = Enum.Material.Neon; head.Shape = Enum.PartType.Ball; head.Anchored = true; head.CanCollide = false
			end
		else
			if blobman then blobman:Destroy() blobman = nil end
		end
	end
})

OrionLib:Init()

-- ==================== 機能 ====================
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

RunService.Heartbeat:Connect(function()
	local char = LocalPlayer.Character
	if not char then return end
	local root = char:FindFirstChild("HumanoidRootPart")
	local hum = char:FindFirstChild("Humanoid")
	if not root then return end

	if getgenv().WalkSpeed then
		if hum then hum.WalkSpeed = getgenv().WalkSpeed end
	end

	if blobman and blobman:FindFirstChild("Torso") then
		blobman.Torso.Position = root.Position + Vector3.new(0, 6, 0)
		if blobman:FindFirstChild("Head") then
			blobman.Head.Position = blobman.Torso.Position + Vector3.new(0, 3, 0)
		end
	end

	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer and plr.Character then
			local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
			if not tRoot then continue end
			local dist = (tRoot.Position - root.Position).Magnitude

			if getgenv().AutoFling and dist <= (getgenv().FlingDistance or 15) then
				tRoot.Velocity = (tRoot.Position - root.Position).Unit * (getgenv().FlingPower or 250) + Vector3.new(0, 100, 0)
			end

			if getgenv().TeleportToPlayer then
				root.CFrame = tRoot.CFrame * CFrame.new(0, 3, 0)
				break
			end
		end
	end
end)

print("PanPan HUB 読み込み完了")
