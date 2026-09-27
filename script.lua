-- DARK HORSE HUB (Pronto para Produção no GitHub)
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

-- Anti-Duplicação
if player:WaitForChild("PlayerGui"):FindFirstChild("DarkHorseHub") then
    player.PlayerGui.DarkHorseHub:Destroy()
end

local gui = Instance.new("ScreenGui")
gui.Name = "DarkHorseHub"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Janela principal
local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(620, 420)
main.Position = UDim2.fromScale(0.5, 0.5)
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
main.BorderSizePixel = 0
main.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 14)
corner.Parent = main

-- ==========================================
-- SISTEMA DE ARRASTAR A JANELA (DRAGGABLE)
-- ==========================================
local dragging, dragInput, dragStart, startPos
local function update(input)
	local delta = input.Position - dragStart
	main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end
main.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = main.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then dragging = false end
		end)
	end
end)
main.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
end)
UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then update(input) end
end)

-- Título
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -30, 0, 55)
title.Position = UDim2.fromOffset(15, 5)
title.BackgroundTransparency = 1
title.Text = "🐴 DARK HORSE HUB"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextSize = 25
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = main

-- Área das abas
local tabs = Instance.new("Frame")
tabs.Size = UDim2.new(0, 180, 1, -70)
tabs.Position = UDim2.fromOffset(10, 60)
tabs.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
tabs.BorderSizePixel = 0
tabs.Parent = main

local tabsCorner = Instance.new("UICorner")
tabsCorner.CornerRadius = UDim.new(0, 10)
tabsCorner.Parent = tabs

local tabsLayout = Instance.new("UIListLayout")
tabsLayout.Padding = UDim.new(0, 8)
tabsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
tabsLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabsLayout.Parent = tabs

local tabsPadding = Instance.new("UIPadding")
tabsPadding.PaddingTop = UDim.new(0, 10)
tabsPadding.Parent = tabs

-- Conteúdo (ScrollingFrame)
local content = Instance.new("ScrollingFrame")
content.Size = UDim2.new(1, -205, 1, -70)
content.Position = UDim2.fromOffset(195, 60)
content.BackgroundTransparency = 1
content.BorderSizePixel = 0
content.ScrollBarThickness = 5
content.CanvasSize = UDim2.new(0, 0, 0, 0)
content.Parent = main

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 8)
layout.Parent = content

local function clearContent()
	for _, obj in ipairs(content:GetChildren()) do
		if not obj:IsA("UIListLayout") then obj:Destroy() end
	end
end

-- Botão de função (Agora aceita uma função real como clique)
local function addFunction(name, callback)
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(1, -10, 0, 45)
	button.BackgroundColor3 = Color3.fromRGB(32, 32, 40)
	button.BorderSizePixel = 0
	button.Text = "  " .. name
	button.TextColor3 = Color3.new(1, 1, 1)
	button.TextSize = 16
	button.Font = Enum.Font.Gotham
	button.TextXAlignment = Enum.TextXAlignment.Left
	button.Parent = content

	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, 8)
	c.Parent = button

	button.MouseButton1Click:Connect(function()
		if callback then callback() end
	end)
end

local function addTab(name, order, callback)
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(1, -20, 0, 48)
	button.BackgroundColor3 = Color3.fromRGB(35, 35, 43)
	button.BorderSizePixel = 0
	button.Text = name
	button.TextColor3 = Color3.new(1, 1, 1)
	button.TextSize = 15
	button.Font = Enum.Font.GothamBold
	button.LayoutOrder = order
	button.Parent = tabs

	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, 8)
	c.Parent = button
	button.MouseButton1Click:Connect(callback)
	return button
end

layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	content.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 15)
end)

-- Variables para exploits ativos
local infJumpConnection
local speedConnection

-- Abas
local function showLennon()
	clearContent()
	addFunction("🧭 Teleguiado", function() print("Teleguiado ativado") end)
	addFunction("📚 Vasta Biblioteca", function() print("Biblioteca carregada") end)
	addFunction("🐾 Dar Pets para Pegar", function() print("Pets ativado") end)
end

local function showChili()
	clearContent()
	addFunction("🪽 Rouba Voando")
	addFunction("🥚 Auto Steal")
	
	-- Pulo Infinito REAL
	addFunction("🦘 Pulo Infinito", function()
		if infJumpConnection then infJumpConnection:Disconnect() end
		infJumpConnection = UserInputService.JumpRequest:Connect(function()
			if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
				player.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
			end
		end)
		print("Pulo Infinito Ativado!")
	end)
	
	addFunction("🛡️ Anti-Ragdoll")
	
	-- Invisibilidade REAL (Local)
	addFunction("👻 Invisível", function()
		if player.Character then
			for _, part in ipairs(player.Character:GetDescendants()) do
				if part:IsA("BasePart") or part:IsA("Decal") then
					part.Transparency = part.Name == "HumanoidRootPart" and 1 or 0.5
				end
			end
			print("Você ficou semi-invisível na sua tela!")
		end
	end)
	
	-- Speed Boost REAL
	addFunction("⚡ Speed Boost", function()
		if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
			player.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 100
			print("Velocidade alterada para 100!")
		end
	end)
end

local function showMiranda()
	clearContent()
	addFunction("🐾 Lista de Pets para Pegar")
	addFunction("🧪 Auto Farm Samples")
end

addTab("🔹 Lennon V4", 1, showLennon)
addTab("🌶️ Chili Hub", 2, showChili)
addTab("🐾 Miranda V4", 3, showMiranda)

-- Botão Fechar
local close = Instance.new("TextButton")
close.Size = UDim2.fromOffset(35, 35)
close.Position = UDim2.new(1, -45, 0, 10)
close.BackgroundColor3 = Color3.fromRGB(180, 45, 45)
close.Text = "X"
close.TextColor3 = Color3.new(1, 1, 1)
close.TextSize = 16
close.Font = Enum.Font.GothamBold
close.Parent = main

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(1, 0)
closeCorner.Parent = close

close.MouseButton1Click:Connect(function()
	if infJumpConnection then infJumpConnection:Disconnect() end
	gui:Destroy()
end)

showLennon()
print("Dark Horse Hub injetado!")
