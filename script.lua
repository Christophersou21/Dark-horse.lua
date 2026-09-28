-- ==========================================
--        🐴 DARK HORSE HUB 🐴
--        Otimizado para Mobile
-- ==========================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Anti-Duplicação
local oldGui = playerGui:FindFirstChild("DarkHorseHub")
if oldGui then
    oldGui:Destroy()
end

-- ==========================================
--              GUI PRINCIPAL
-- ==========================================

local gui = Instance.new("ScreenGui")
gui.Name = "DarkHorseHub"
gui.ResetOnSpawn = false
gui.Parent = playerGui

local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(330, 280)
main.Position = UDim2.fromScale(0.5, 0.5)
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
main.BorderSizePixel = 0
main.Active = true
main.Parent = gui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = main

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(0, 170, 255)
stroke.Thickness = 1.5
stroke.Parent = main

-- ==========================================
--          ARRASTAR NO CELULAR
-- ==========================================

local dragging = false
local dragInput
local dragStart
local startPos

main.InputBegan:Connect(function(input)

    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

        dragging = true
        dragStart = input.Position
        startPos = main.Position

        input.Changed:Connect(function()

            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end

        end)
    end
end)

main.InputChanged:Connect(function(input)

    if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then

        dragInput = input
    end

end)

UserInputService.InputChanged:Connect(function(input)

    if input == dragInput and dragging then

        local delta = input.Position - dragStart

        main.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )

    end

end)

-- ==========================================
--                TÍTULO
-- ==========================================

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -50, 0, 40)
title.Position = UDim2.fromOffset(15, 2)
title.BackgroundTransparency = 1
title.Text = "🐴 DARK HORSE HUB"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 16
title.Font = Enum.Font.SourceSansBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = main

-- ==========================================
--              ÁREA DOS BOTÕES
-- ==========================================

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

    content.CanvasSize = UDim2.new(
        0,
        0,
        0,
        layout.AbsoluteContentSize.Y + 10
    )

end)

-- ==========================================
--              ESTADOS
-- ==========================================

local speedActive = false
local infJumpActive = false

-- ==========================================
--          FUNÇÃO DOS BOTÕES
-- ==========================================

local function createButton(name, callback)

    local button = Instance.new("TextButton")

    button.Size = UDim2.new(1, -5, 0, 42)
    button.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
    button.BorderSizePixel = 0
    button.Text = "   " .. name
    button.TextColor3 = Color3.fromRGB(230, 230, 230)
    button.TextSize = 14
    button.Font = Enum.Font.SourceSans
    button.TextXAlignment = Enum.TextXAlignment.Left
    button.AutoButtonColor = false
    button.Parent = content

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = button

    button.MouseButton1Down:Connect(function()
        button.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
    end)

    button.MouseButton1Up:Connect(function()
        button.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
    end)

    button.MouseButton1Click:Connect(function()

        if callback then
            callback()
        end

    end)

    return button
end

-- ==========================================
--             ⚡ SPEED BOOST
-- ==========================================

createButton("⚡ Speed Boost 100", function()

    speedActive = not speedActive

    local character = player.Character
    local humanoid = character
        and character:FindFirstChildOfClass("Humanoid")

    if speedActive then

        if humanoid then
            humanoid.WalkSpeed = 100
        end

        print("[Dark Horse] Speed Boost: LIGADO")

    else

        if humanoid then
            humanoid.WalkSpeed = 16
        end

        print("[Dark Horse] Speed Boost: DESLIGADO")

    end

end)

-- ==========================================
--             🦘 PULO INFINITO
-- ==========================================

createButton("🦘 Pulo Infinito", function()

    infJumpActive = not infJumpActive

    print(
        "[Dark Horse] Pulo Infinito: "
        .. (infJumpActive and "LIGADO" or "DESLIGADO")
    )

end)

-- ==========================================
--          SPEED CONTÍNUO
-- ==========================================

RunService.RenderStepped:Connect(function()

    if speedActive then

        local character = player.Character
        local humanoid = character
            and character:FindFirstChildOfClass("Humanoid")

        if humanoid then
            humanoid.WalkSpeed = 100
        end

    end

end)

-- ==========================================
--             PULO INFINITO
-- ==========================================

UserInputService.JumpRequest:Connect(function()

    if not infJumpActive then
        return
    end

    local character = player.Character

    if not character then
        return
    end

    local humanoid = character:FindFirstChildOfClass("Humanoid")

    if humanoid then
        humanoid:ChangeState(
            Enum.HumanoidStateType.Jumping
        )
    end

end)

-- ==========================================
--                ❌ FECHAR
-- ==========================================

local close = Instance.new("TextButton")

close.Size = UDim2.fromOffset(28, 28)
close.Position = UDim2.new(1, -35, 0, 7)
close.BackgroundColor3 = Color3.fromRGB(40, 20, 20)
close.Text = "X"
close.TextColor3 = Color3.fromRGB(255, 100, 100)
close.TextSize = 14
close.Font = Enum.Font.SourceSansBold
close.Parent = main

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(1, 0)
closeCorner.Parent = close

close.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- ==========================================
--                FINAL
-- ==========================================

print("🐴 DARK HORSE HUB carregado!")
print("⚡ Speed Boost disponível")
print("🦘 Pulo Infinito disponível")
