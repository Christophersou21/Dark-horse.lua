-- DARK HORSE HUB (Versão Sem Abas - Direta para Mobile)
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

-- Anti-Duplicação
if player:WaitForChild("PlayerGui"):FindFirstChild("DarkHorseHub") then
    player.PlayerGui.DarkHorseHub:Destroy()
end

local gui = Instance.new("ScreenGui")
gui.Name = "DarkHorseHub"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Janela Principal Super Compacta
local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(320, 260)
main.Position = UDim2.fromScale(0.5, 0.5)
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
main.Active = true
main.Parent = gui

Instance.new("UICorner", main).CornerRadius = UDim.new(0, 8)

-- Arrastar no Celular (Touch/Mouse)
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

-- Título do Menu
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -40, 0, 35)
title.Position = UDim2.fromOffset(12, 5)
title.BackgroundTransparency = 1
title.Text = "DARK HORSE HUB"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextSize = 16
title.Font = Enum.Font.SourceSansBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = main

-- Lista de Conteúdo com Rolagem
local content = Instance.new("ScrollingFrame")
content.Size = UDim2.new(1, -20, 1, -50)
content.Position = UDim2.fromOffset(10, 42)
content.BackgroundTransparency = 1
content.BorderSizePixel = 0
content.ScrollBarThickness = 4
content.CanvasSize = UDim2.new(0, 0, 0, 0)
content.Parent = main

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 5)
layout.Parent = content

-- Ajuste automático do tamanho da lista
layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	content.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
end)

-- Função para Criar os Botões de Hack
local function addFunction(name, callback)
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(1, -5, 0, 36)
	button.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
	button.BorderSizePixel = 0
	button.Text = "  " .. name
	button.TextColor3 = Color3.new(1, 1, 1)
	button.TextSize = 14
	button.Font = Enum.Font.SourceSans
	button.TextXAlignment = Enum.TextXAlignment.Left
	button.Parent = content
	button.MouseButton1Click:Connect(function() if callback then callback() end end)
    Instance.new("UICorner", button).CornerRadius = UDim.new(0, 5)
end

-- Função Auxiliar de Teleporte para o Jogador Mais Próximo
local function teleportToNearest()
    local closest = nil
    local shortestDistance = math.huge
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (player.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
            if dist < shortestDistance then
                closest = p.Character.HumanoidRootPart
                shortestDistance = dist
            end
        end
    end
    if closest then
        player.Character.HumanoidRootPart.CFrame = closest.CFrame + Vector3.new(0, 3, 0)
    end
end

-- ==========================================
-- TODAS AS FUNÇÕES DIRETAS NA TELA
-- ==========================================

addFunction("⚡ Speed Boost (Velocidade)", function()
    if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
        player.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 80
    end
end)

addFunction("🦘 Pulo Infinito", function()
    UserInputService.JumpRequest:Connect(function()
        if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
            player.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end)
end)

addFunction("🧭 Teleguiado (Teleport Proximo)", function()
    teleportToNearest()
end)

addFunction("👻 Invisivel (Local)", function()
    if player.Character then
        for _, v in pairs(player.Character:GetDescendants()) do
            if v:IsA("BasePart") or v:IsA("Decal") then
                v.Transparency = v.Name == "HumanoidRootPart" and 1 or 0.7
            end
        end
    end
end)

addFunction("🛡️ Anti-Ragdoll", function()
    if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
        player.Character:FindFirstChildOfClass("Humanoid").PlatformStand = false
        player.Character:FindFirstChildOfClass("Humanoid").RequiresNeck = false
    end
end)

addFunction("🪽 Rouba Voando", function()
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local bv = Instance.new("BodyVelocity", player.Character.HumanoidRootPart)
        bv.Velocity = Vector3.new(0, 45, 0)
        bv.MaxForce = Vector3.new(0, math.huge, 0)
        task.wait(0.8)
        bv:Destroy()
    end
end)

addFunction("📚 Vasta Biblioteca (Dex)", function()
    loadstring(game:HttpGet("https://githubusercontent.com"))()
end)

-- Botão Fechar (X)
local close = Instance.new("TextButton")
close.Size = UDim2.fromOffset(25, 25)
close.Position = UDim2.new(1, -32, 0, 5)
close.BackgroundColor3 = Color3.fromRGB(180, 45, 45)
close.Text = "X"
close.TextColor3 = Color3.new(1, 1, 1)
close.Font = Enum.Font.SourceSansBold
close.Parent = main
close.MouseButton1Click:Connect(function() gui:Destroy() end)
Instance.new("UICorner", close).CornerRadius = UDim.new(1, 0)
