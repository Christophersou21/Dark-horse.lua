-- DARK HORSE HUB (Versão Otimizada Mobile Ultra Light)
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

if player:WaitForChild("PlayerGui"):FindFirstChild("DarkHorseHub") then
    player.PlayerGui.DarkHorseHub:Destroy()
end

local gui = Instance.new("ScreenGui")
gui.Name = "DarkHorseHub"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(420, 260)
main.Position = UDim2.fromScale(0.5, 0.5)
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
main.Active = true
main.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = main

-- Arrastar no Celular (Touch)
local dragging, dragInput, dragStart, startPos
main.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true dragStart = input.Position startPos = main.Position
		input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
	end
end)
main.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
end)
UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - dragStart
		main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -40, 0, 35)
title.Position = UDim2.fromOffset(10, 5)
title.BackgroundTransparency = 1
title.Text = "DARK HORSE HUB"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextSize = 16
title.Font = Enum.Font.SourceSansBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = main

local tabs = Instance.new("Frame")
tabs.Size = UDim2.new(0, 110, 1, -50)
tabs.Position = UDim2.fromOffset(10, 40)
tabs.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
tabs.Parent = main

local tabsLayout = Instance.new("UIListLayout")
tabsLayout.Padding = UDim.new(0, 4)
tabsLayout.Parent = tabs

local content = Instance.new("ScrollingFrame")
content.Size = UDim2.new(1, -140, 1, -50)
content.Position = UDim2.fromOffset(130, 40)
content.BackgroundTransparency = 1
content.CanvasSize = UDim2.new(0, 0, 0, 0)
content.Parent = main

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 4)
layout.Parent = content

local function clearContent()
	for _, obj in ipairs(content:GetChildren()) do
		if not obj:IsA("UIListLayout") then obj:Destroy() end
	end
end

local function addFunction(name, callback)
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(1, -10, 0, 35)
	button.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
	button.Text = " " .. name
	button.TextColor3 = Color3.new(1, 1, 1)
	button.TextSize = 14
	button.Font = Enum.Font.SourceSans
	button.TextXAlignment = Enum.TextXAlignment.Left
	button.Parent = content
	button.MouseButton1Click:Connect(function() if callback then callback() end end)
    Instance.new("UICorner", button).CornerRadius = UDim.new(0, 4)
end

local function addTab(name, callback)
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(1, -10, 0, 32)
	button.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
	button.Text = name
	button.TextColor3 = Color3.new(1, 1, 1)
	button.TextSize = 13
	button.Font = Enum.Font.SourceSansBold
	button.Parent = tabs
	button.MouseButton1Click:Connect(callback)
    Instance.new("UICorner", button).CornerRadius = UDim.new(0, 4)
end

layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	content.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
end)

local function showLennon()
	clearContent()
	addFunction("Teleguiado")
	addFunction("Vasta Biblioteca")
	addFunction("Dar Pets para Pegar")
end

local function showChili()
	clearContent()
	addFunction("Rouba Voando")
	addFunction("Auto Steal")
	addFunction("Pulo Infinito", function()
		UserInputService.JumpRequest:Connect(function()
			if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
				player.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
			end
		end)
	end)
	addFunction("Speed Boost", function()
		if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
			player.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 80
		end
	end)
end

local function showMiranda()
	clearContent()
	addFunction("Lista de Pets")
	addFunction("Auto Farm Samples")
end

addTab("Lennon V4", showLennon)
addTab("Chili Hub", showChili)
addTab("Miranda V4", showMiranda)

local close = Instance.new("TextButton")
close.Size = UDim2.fromOffset(25, 25)
close.Position = UDim2.new(1, -35, 0, 5)
close.BackgroundColor3 = Color3.fromRGB(180, 45, 45)
close.Text = "X"
close.TextColor3 = Color3.new(1, 1, 1)
close.Font = Enum.Font.SourceSansBold
close.Parent = main
close.MouseButton1Click:Connect(function() gui:Destroy() end)
Instance.new("UICorner", close).CornerRadius = UDim.new(1, 0)

showLennon()
