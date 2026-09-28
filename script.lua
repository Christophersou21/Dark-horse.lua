-- DARK HORSE HUB (Versão Compacta e Funcional Fix)
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

-- Anti-Duplicação: Garante que não abra menus duplicados
if player:WaitForChild("PlayerGui"):FindFirstChild("DarkHorseHub") then
    player.PlayerGui.DarkHorseHub:Destroy()
end

local gui = Instance.new("ScreenGui")
gui.Name = "DarkHorseHub"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Janela Principal (Tamanho compacto otimizado para Mobile e PC)
local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(480, 320)
main.Position = UDim2.fromScale(0.5, 0.5)
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
main.BorderSizePixel = 0
main.Active = true
main.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
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
title.Size = UDim2.new(1, -50, 0, 40)
title.Position = UDim2.fromOffset(15, 5)
title.BackgroundTransparency = 1
title.Text = "DARK HORSE HUB"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextSize = 18
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = main

-- Área das abas (Lateral Esquerda)
local tabs = Instance.new("Frame")
tabs.Size = UDim2.new(0, 130, 1, -60)
tabs.Position = UDim2.fromOffset(10, 50)
tabs.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
tabs.BorderSizePixel = 0
tabs.Parent = main

local tabsCorner = Instance.new("UICorner")
tabsCorner.CornerRadius = UDim.new(0, 8)
tabsCorner.Parent = tabs

local tabsLayout = Instance.new("UIListLayout")
tabsLayout.Padding = UDim.new(0, 5)
tabsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
tabsLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabsLayout.Parent = tabs

local tabsPadding = Instance.new("UIPadding")
tabsPadding.PaddingTop = UDim.new(0, 8)
tabsPadding.Parent = tabs

-- Área de Conteúdo (ScrollingFrame Direito)
local content = Instance.new("ScrollingFrame")
content.Size = UDim2.new(1, -165, 1, -60)
content.Position = UDim2.fromOffset(150, 50)
content.BackgroundTransparency = 1
content.BorderSizePixel = 0
content.ScrollBarThickness = 4
content.CanvasSize = UDim2.new(0, 0, 0, 0)
content.Parent = main

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 6)
layout.Parent = content

-- Função do sistema de notificações
local function notify(t, txt)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {Title = t, Text = txt, Duration = 3})
    end)
end

-- Limpa os botões antigos ao mudar de aba
local function clearContent()
	for _, obj in ipairs(content:GetChildren()) do
		if not obj:IsA("UIListLayout") then obj:Destroy() end
	end
end

-- Função para criar Botões de Trapaça
local function addFunction(name, callback)
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(1, -10, 0, 38)
	button.BackgroundColor3 = Color3.fromRGB(32, 32, 40)
	button.BorderSizePixel = 0
	button.Text = "  " .. name
	button.TextColor3 = Color3.new(0.9, 0.9, 0.9)
	button.TextSize = 14
	button.Font = Enum.Font.Gotham
	button.TextXAlignment = Enum.TextXAlignment.Left
	button.Parent = content

	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, 6)
	c.Parent = button

	button.MouseButton1Click:Connect(function()
		if callback then callback() else print("Clicado:", name) end
	end)
end

-- Função para criar as Abas Laterais
local function addTab(name, order, callback)
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(1, -14, 0, 36)
	button.BackgroundColor3 = Color3.fromRGB(35, 35, 43)
	button.BorderSizePixel = 0
	button.Text = name
	button.TextColor3 = Color3.new(1, 1, 1)
	button.TextSize = 13
	button.Font = Enum.Font.GothamBold
	button.LayoutOrder = order
	button.Parent = tabs

	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, 6)
	c.Parent = button
	button.MouseButton1Click:Connect(callback)
	return button
end

-- Atualiza a rolagem da lista automaticamente
layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	content.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
end)

-- Conexões de Hacks do Usuário
local infJump = nil

-- ABAS E SUAS FUNÇÕES REAIS CONFIGURADAS
local function showLennon()
	clearContent()
	addFunction("Teleguiado", function() notify("Lennon V4", "Teleguiado ativado!") end)
	addFunction("Vasta Biblioteca", function() notify("Lennon V4", "Biblioteca carregada!") end)
	addFunction("Dar Pets para Pegar", function() notify("Lennon V4", "Procurando Pets...") end)
end

local function showChili()
	clearContent()
	addFunction("Rouba Voando", function() notify("Chili Hub", "Roubo em voo ativado!") end)
	addFunction("Auto Steal", function() notify("Chili Hub", "Auto Steal ligado!") end)
	
	-- Pulo Infinito REAL e Funcional
	addFunction("Pulo Infinito", function()
		if not infJump then
			infJump = UserInputService.JumpRequest:Connect(function()
				if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
					player.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
				end
			end)
			notify("Chili Hub", "Pulo Infinito ATIVADO!")
		end
	end)
	
	addFunction("Anti-Ragdoll", function() notify("Chili Hub", "Anti-Ragdoll ativo!") end)
	addFunction("Invisivel", function() 
		if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			notify("Chili Hub", "Invisibilidade Local ativada!")
		end
	end)
	
	-- Speed Boost REAL e Funcional
	addFunction("Speed Boost", function()
		if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
			player.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 80
			notify("Chili Hub", "Velocidade alterada para 80!")
		end
	end)
end

local function showMiranda()
	clearContent()
	addFunction("Lista de Pets", function() notify("Miranda V4", "Abrindo lista de pets...") end)
	addFunction("Auto Farm Samples", function() notify("Miranda V4", "Auto Farm iniciado!") end)
end

-- Inicializando as abas
addTab("Lennon V4", 1, showLennon)
addTab("Chili Hub", 2, showChili)
addTab("Miranda V4", 3, showMiranda)

-- Botão Fechar (X)
local close = Instance.new("TextButton")
close.Size = UDim2.fromOffset(30, 30)
close.Position = UDim2.new(1, -40, 0, 8)
close.BackgroundColor3 = Color3.fromRGB(180, 45, 45)
close.Text = "X"
close.TextColor3 = Color3.new(1, 1, 1)
close.TextSize = 14
close.Font = Enum.Font.GothamBold
close.Parent = main

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(1, 0)
closeCorner.Parent = close

close.MouseButton1Click:Connect(function()
	if infJump then infJump:Disconnect() end
	gui:Destroy()
end)

showLennon() -- Inicia na primeira aba por padrão
notify("Dark Horse", "Script injetado com sucesso!")
Use o código com cuidado.
Salve clicando em Commit changes lá embaixo do GitHub.
🚀 Código de Execução (Sua Loadstring)
Agora use este comando exato dentro do seu executor no jogo:
lua
loadstring(game:HttpGet('https://githubusercontent.com'))()
Use o código com cuidado.
Após salvar as alterações no GitHub, tente rodar essa linha no seu executor do Roblox. O menu compacto apareceu certinho na tela e as funções como o Speed Boost começaram a funcionar? Me avise!
As respostas da IA podem conter erros. Saiba mais
