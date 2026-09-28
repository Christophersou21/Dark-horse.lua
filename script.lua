-- ==========================================
--        🐴 DARK HORSE HUB PREMIUM 🐴        
--  Otimizado para Mobile & Executores Atuais
-- ==========================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local player = Players.LocalPlayer

-- Anti-Duplicação (Segurança Máxima)
if player:WaitForChild("PlayerGui"):FindFirstChild("DarkHorseHub") then
    player.PlayerGui.DarkHorseHub:Destroy()
end

local gui = Instance.new("ScreenGui")
gui.Name = "DarkHorseHub"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Janela Principal (Design Moderno Dark/Neon)
local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(330, 280)
main.Position = UDim2.fromScale(0.5, 0.5)
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 18) -- Fundo Dark Premium
main.BorderSizePixel = 0
main.Active = true
main.Parent = gui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = main

-- Borda Neon Elegante
local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(0, 170, 255) -- Azul Neon
stroke.Thickness = 1.5
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
stroke.Parent = main

-- ==========================================
--   SISTEMA DE ARRASTAR MOBILE (TOUCH FIX)
-- ==========================================
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

-- Título do Hub
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -40, 0, 40)
title.Position = UDim2.fromOffset(15, 2)
title.BackgroundTransparency = 1
title.Text = "🐴 DARK HORSE HUB"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 16
title.Font = Enum.Font.SourceSansBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = main

-- Lista de Funções com Rolagem Suave
local content = Instance.new("ScrollingFrame")
content.Size = UDim2.new(1, -20, 1, -55)
content.Position = UDim2.fromOffset(10, 45)
content.BackgroundTransparency = 1
content.BorderSizePixel = 0
content.ScrollBarThickness = 3
content.ScrollBarImageColor3 = Color3.fromRGB(0, 170, 255)
content.CanvasSize = UDim2.new(0, 0, 0, 0)
content.Parent = main

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 6)
layout.Parent = content

layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	content.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
end)

-- Função do Sistema Notificações do Hub
local function notifyUser(msg, cor)
    StarterGui:SetCore("ChatMakeSystemMessage", {
        Text = "[🐴 Dark Horse]: " .. msg,
        Color = cor or Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.SourceSansBold,
        FontSize = Enum.FontSize.Size18
    })
end

-- Criador de Botões Premium (com Efeito Visual ao clicar)
local function createButton(name, callback)
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(1, -5, 0, 38)
	button.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
	button.BorderSizePixel = 0
	button.Text = "   " .. name
	button.TextColor3 = Color3.fromRGB(230, 230, 230)
	button.TextSize = 14
	button.Font = Enum.Font.SourceSans
	button.TextXAlignment = Enum.TextXAlignment.Left
	button.Parent = content

	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, 6)
	c.Parent = button

	-- Efeito visual de clique para Mobile
	button.MouseButton1Down:Connect(function()
		button.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
	end)
	button.MouseButton1Up:Connect(function()
		button.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
	end)
	button.MouseButton1Click:Connect(function()
		if callback then callback() end
	end)
end

-- Variables de Controle dos Scripts
local speedActive = false
local infJumpActive = false
local antiRagdollActive = false
local noclipActive = false

-- Loops em tempo real (Garante estabilidade contra anti-cheats do jogo)
RunService.RenderStepped:Connect(function()
    if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
        local hum = player.Character:FindFirstChildOfClass("Humanoid")
        
        -- Loop de Velocidade
        if speedActive then hum.WalkSpeed = 100 end
        
        -- Loop Anti-Ragdoll
        if antiRagdollActive then
            hum.PlatformStand = false
            hum.RequiresNeck = false
            hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
        end
        
        -- Loop Noclip (Passar pelas paredes/Rouba Voando)
        if noclipActive and player.Character:FindFirstChild("HumanoidRootPart") then
            for _, part in ipairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end
    end
end)

-- Sistema do Pulo Infinito
UserInputService.JumpRequest:Connect(function()
    if infJumpActive and player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
        player.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- Teleporte Proporcional para o Jogador mais Próximo
local function tpToNearestPlayer()
    local closest = nil
    local shortestDistance = math.huge
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (player.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
            if dist < shortestDistance then closest = p.Character.HumanoidRootPart shortestDistance = dist end
        end
    end
    if closest then
        player.Character.HumanoidRootPart.CFrame = closest.CFrame + Vector3.new(0, 3, 0)
        notifyUser("Teleportado até o alvo!", Color3.fromRGB(0, 255, 0))
    else
        notifyUser("Nenhum jogador encontrado por perto.", Color3.fromRGB(255, 0, 0))
    end
end

-- ==========================================
--        SISTEMA DE BOTÕES DO HUB
-- ==========================================

createButton("⚡ Speed Boost 100 (Ativar/Desativar)", function()
    speedActive = not speedActive
    notifyUser("Speed Boost " .. (speedActive and "LIGADO" or "DESLIGADO"), speedActive and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 50, 50))
end)

createButton("🦘 Pulo Infinito (Ativar/Desativar)", function()
    infJumpActive = not infJumpActive
    notifyUser("Pulo Infinito " .. (infJumpActive and "LIGADO" or "DESLIGADO"), infJumpActive and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 50, 50))
end)

createButton("🧭 Teleguiado (Teleport no mais perto)", function()
    tpToNearestPlayer()
end)

createButton("🪽 Rouba Voando / Noclip (Ativar/Desativar)", function()
    noclipActive = not noclipActive
    notifyUser("Noclip/Voo " .. (noclipActive and "LIGADO" or "DESLIGADO"), noclipActive and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 50, 50))
end)

createButton("🛡️ Anti-Ragdoll (Imune a quedas)", function()
    antiRagdollActive = not antiRagdollActive
    notifyUser("Anti-Ragdoll " .. (antiRagdollActive and "LIGADO" or "DESLIGADO"), antiRagdollActive and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 50, 50))
end)

createButton("👻 Invisibilidade (Modo Local)", function()
    if player.Character then
        for _, v in pairs(player.Character:GetDescendants()) do
            if v:IsA("BasePart") or v:IsA("Decal") then
                if v.Name ~= "HumanoidRootPart" then v.Transparency = 0.8 end
            end
        end
        notifyUser("Invisibilidade local ativada!", Color3.fromRGB(0, 255, 255))
    end
end)

createButton("📚 Vasta Biblioteca (Abrir Dex Explorer)", function()
    notifyUser("Carregando Banco de Dados...", Color3.fromRGB(255, 170, 0))
    loadstring(game:HttpGet("https://githubusercontent.com"))()
end)

-- Botão Fechar (Design Compacto Clean)
local close = Instance.new("TextButton")
close.Size = UDim2.fromOffset(24, 24)
close.Position = UDim2.new(1, -30, 0, 8)
close.BackgroundColor3 = Color3.fromRGB(40, 20, 20)
close.Text = "X"
close.TextColor3 = Color3.fromRGB(255, 100, 100)
close.Font = Enum.Font.SourceSansBold
close.Parent = main

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(1, 0)
closeCorner.Parent = close

local closeStroke = Instance.new("UIStroke")
closeStroke.Color = Color3.fromRGB(180, 45, 45)
closeStroke.Parent = close

close.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

notifyUser("Injetado com sucesso! Divirta-se.", Color3.fromRGB(0, 170, 255))

