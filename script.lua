-- ==========================================
--        🐴 DARK HORSE HUB NEO-GLOW 🐴
--        Otimizado para Celular e Tablet
-- ==========================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Anti-Duplicação
local oldGui = playerGui:FindFirstChild("DarkHorseHub")
if oldGui then
    oldGui:Destroy()
end

-- ==========================================
--        INTERFACE ADAPTÁVEL (RESPONSIVA)
-- ==========================================

local gui = Instance.new("ScreenGui")
gui.Name = "DarkHorseHub"
gui.ResetOnSpawn = false
gui.Parent = playerGui

local main = Instance.new("Frame")
-- Usando escala para se adaptar perfeitamente a telas pequenas de celular e grandes de tablet
main.Size = UDim2.new(0, 340, 0, 320)
main.Position = UDim2.fromScale(0.5, 0.5)
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.BackgroundColor3 = Color3.fromRGB(11, 11, 14)
main.BorderSizePixel = 0
main.Active = true
main.Parent = gui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 16)
mainCorner.Parent = main

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(0, 221, 255)
stroke.Thickness = 2
stroke.Parent = main

-- Restringe o tamanho para não quebrar em telas muito pequenas
local sizeConstraint = Instance.new("UISizeConstraint")
sizeConstraint.MaxSize = Vector2.new(450, 400)
sizeConstraint.MinSize = Vector2.new(280, 250)
sizeConstraint.Parent = main

-- ==========================================
--      SISTEMA DE ARRASTAR (TOUCH & MOUSE)
-- ==========================================

local dragging = false
local dragInput, dragStart, startPos

main.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
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
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- ==========================================
--         TOPO / TÍTULO ESTILIZADO
-- ==========================================

local banner = Instance.new("Frame")
banner.Size = UDim2.new(1, 0, 0, 45)
banner.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
banner.BorderSizePixel = 0
banner.Parent = main

local bannerCorner = Instance.new("UICorner")
bannerCorner.CornerRadius = UDim.new(0, 16)
bannerCorner.Parent = banner

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -20, 1, 0)
title.Position = UDim2.fromOffset(15, 0)
title.BackgroundTransparency = 1
title.Text = "🐴 DARK HORSE HUB"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 16
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = banner

-- ==========================================
--              ÁREA ROLÁVEL
-- ==========================================

local content = Instance.new("ScrollingFrame")
content.Size = UDim2.new(1, -20, 1, -65)
content.Position = UDim2.fromOffset(10, 55)
content.BackgroundTransparency = 1
content.BorderSizePixel = 0
content.ScrollBarThickness = 4
content.ScrollBarImageColor3 = Color3.fromRGB(0, 221, 255)
content.Parent = main

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 8)
layout.Parent = content

layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    content.CanvasSize = UDim2.fromOffset(0, layout.AbsoluteContentSize.Y + 15)
end)

-- ==========================================
--       CRIADOR DE BOTÕES PREMIUM
-- ==========================================

local function createButton(name, color, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -5, 0, 44)
    button.BackgroundColor3 = Color3.fromRGB(20, 20, 27)
    button.BorderSizePixel = 0
    button.Text = "   " .. name
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 14
    button.Font = Enum.Font.GothamSemibold
    button.TextXAlignment = Enum.TextXAlignment.Left
    button.AutoButtonColor = false
    button.Parent = content

    local bCorner = Instance.new("UICorner")
    bCorner.CornerRadius = UDim.new(0, 8)
    bCorner.Parent = button

    local bStroke = Instance.new("UIStroke")
    bStroke.Color = color
    bStroke.Thickness = 1
    bStroke.Parent = button

    button.MouseButton1Down:Connect(function()
        button.BackgroundColor3 = color
        button.TextColor3 = Color3.fromRGB(0, 0, 0)
    end)

    button.MouseButton1Up:Connect(function()
        button.BackgroundColor3 = Color3.fromRGB(20, 20, 27)
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)

    button.MouseButton1Click:Connect(function()
        if callback then callback() end
    end)
end

-- ==========================================
--     MATEMÁTICA DAS HORAS DE MANAUS
-- ==========================================

-- Baseado no horário atual de 17:46 + 5 minutos para anoitecer (17:51 = 1071 minutos totais)
local totalMinutosManaus = (17 * 60) + 51

local function calcularHorarioPet(nomePet, porcentagem)
    local minutosAdicionais = totalMinutosManaus * (porcentagem / 100)
    local minutesFinais = totalMinutosManaus + minutosAdicionais
    
    local hora = math.floor((minutesFinais / 60) % 24)
    local minuto = math.floor(minutesFinais % 60)
    
    local horarioFormatado = string.format("%02d:%02d", hora, minuto)
    
    StarterGui:SetCore("SendNotification", {
        Title = "⏰ " .. nomePet,
        Text = "Vai spawnar exatamente as: " .. horarioFormatado,
        Duration = 8
    })
end

-- ==========================================
--        BOTÕES COM CORES DO TEMA
-- ==========================================

local C_Orange = Color3.fromRGB(255, 140, 0)
local C_Green  = Color3.fromRGB(50, 205, 50)
local C_Blue   = Color3.fromRGB(0, 191, 255)

createButton("🦊 Kitsune (44%)", C_Orange, function()
    calcularHorarioPet("Kitsune", 44)
end)

createButton("🐋 Royal SkyWhale (63%)", C_Blue, function()
    calcularHorarioPet("Royal SkyWhale", 63)
end)

createButton("🔥 World Burner (70%)", C_Orange, function()
    calcularHorarioPet("World Burner", 70)
end)

createButton("🦄 Unicorn (70%)", C_Blue, function()
    calcularHorarioPet("Unicorn", 70)
end)

createButton("👼 Archangel (71%)", C_Green, function()
    calcularHorarioPet("Archangel", 71)
end)

createButton("🦅 Nightflame (72%)", C_Orange, function()
    calcularHorarioPet("Nightflame", 72)
end){
  "venyx": 0,
  "name": "dark horse hub",
  "data": {
    "System / Interface/Quick bars/Show quick bars": true,
    "Farm / Sell/Favorite/Auto favorite": true,
    "System / Interface/Quick bars/Quick bar layout": "{\"pins\":{\"Event / Butterfly/Butterfly bloom/Auto butterfly bloom\":1,\"Farm / Fuse/Fuse machine/Auto fuse\":1,\"Event / Halloween/Phantom Express/Auto Phantom Express\":4,\"Player / Combat/Hit aura/Hit aura\":2,\"Event / Lab/Lab/Steal lab eggs\":1,\"Player / Move/Protection/Invisible\":2,\"Event / Halloween/Ghost Dog and fishing/Auto fishing\":3,\"Player / Combat/Auto hit/Auto hit\":2,\"Steal / Auto Steal/Auto steal/Auto steal\":1,\"Player / Move/Movement/Speed boost\":2,\"Farm / Sell/Eggs/Auto sell eggs\":1,\"Event / Butterfly/Butterfly machine/Auto craft essence\":2,\"Event / Halloween/Monsters/Auto farm monsters\":4,\"Event / Halloween/Halloween Dimension/Auto Pumpkin Moon\":4,\"Farm / Mutate/Auto mutate/Auto mutate\":1,\"Farm / Sell/Favorite/Auto favorite\":1,\"Steal / Auto Steal/Auto steal/Drop eggs at safe zone\":2,\"Event / AA/Admin abuse/Instant steal (Admin Treadmill)\":4,\"Steal / Auto Steal/Auto steal/Steal from other players\":2,\"Event / Race/Racing Event/Auto race\":1,\"Farm / Pen/Auto place/Auto place\":1,\"Farm / Treadmill/Treadmill/Auto treadmill\":3,\"Farm / Pen/Auto hatch/Auto hatch\":1,\"Event / Halloween/Halloween Dimension/Auto buy Halloween Dimension Egg\":4,\"Event / Halloween/Halloween Dimension/Auto steal Halloween eggs\":4,\"Event / Butterfly/Butterfly machine/Auto trade up\":2},\"fold\":{\"1\":true,\"4\":true,\"3\":true,\"2\":true},\"at\":{\"1\":[276.255126953125,57.60747528076172],\"4\":[558.5322265625,59.71636962890625],\"3\":[418.84466552734377,57.98832702636719],\"2\":[137.08941650390626,56.155967712402347]},\"keys\":[]}",
    "System / Optimizer/Graphics/Disable 3D Render": false,
    "Farm / Pen/Auto place/Place first": "Best value",
    "Steal / Auto Steal/Filter/Only below /s": 0,
    "Farm / Pen/Auto hatch/Equip best pets": true,
    "Event / AA/Capture the egg/Auto capture event egg": false,
    "Farm / Mutate/Mutate filter/Only these eggs": [],
    "Farm / Treadmill/Treadmill/Auto upgrade treadmill": false,
    "Steal / Auto Steal/Auto steal/Drop eggs at safe zone": false,
    "Steal / Auto Steal/Auto hop server/Auto hop": false,
    "System / Interface/Interface/Dim the game": 50,
    "Player / Combat/Hit aura/Skip friends": true,
    "Player / ESP/Others/Pen egg ESP": false,
    "System / Optimizer/Frame rate/FPS position": "0.5000,18,0.0000,-64",
    "Event / Butterfly/Butterfly bloom/Auto butterfly bloom": true,
    "Farm / Pen/Auto hatch/Rarities": ["Eternal", "Secret"],
    "Steal / Auto Steal/Filter/Min value /s": 0,
    "Player / Combat/Hit aura/Hit aura": true,
    "Event / Star/Shooting Star/Auto catch shooting star": true,
    "Steal / Egg Predictor/Egg showcase/Calculate mutations": [],
    "Steal / Egg Predictor/Egg showcase/Sort eggs": "Value",
    "Event / Halloween/Ghost Dog and fishing/Auto fishing": true,
    "System / Optimizer/Bases/Hide other players' pets and eggs": false,
    "Player / Combat/Auto hit/Auto hit": false,
    "Event / Halloween/Ghost Dog and fishing/Auto Ghost Dog quest": true,
    "Event / Butterfly/Butterfly bloom/Catch mode": "Chase",
    "Event / Butterfly/Butterfly machine/Trade": ["Emerald to Sapphire", "Sapphire to Amethyst", "Amethyst to Radiant"],
    "Event / Halloween/Halloween Dimension/Halloween eggs": [
      "Bone Emperor",
      "Voidseer Pumpkin",
      "Zombified Bone Emperor",
      "Ghost Reaper",
      "Gorillastein",
      "Phantom Dragon",
      "Shelltide Voyager",
      "Zombified Grave Cerberus",
      "Zombified Phantom Dragon",
      "BloodBloom",
      "Grave Cerberus",
      "Graveyard Brute",
      "Werewolf",
      "Zombified Night Fang",
      "Zombified Pumpkin Fiend",
      "Zombified Tombstone Bear"
    ],
    "Farm / Pen/Auto place/Auto place": true,
    "Steal / Auto Steal/Filter/Rarities": ["Divine", "Eternal", "Secret"],
    "System / Webhook/What to post/Post fused eggs": true,
    "Event / Halloween/Halloween Dimension/Auto Pumpkin Moon": true,
    "Farm / Sell/Pets/Sell rarities": ["Rare", "Uncommon", "Common"],
    "Player / Move/Protection/Ignore traps": true,
    "Farm / Fuse/Fuse filter/Rarities": ["Eternal", "Secret", "Cosmic"],
    "System / Webhook/Discord webhook/Ping role ID": "",
    "Player / ESP/Others/Hide sleeping guards": true,
    "Event / Halloween/Halloween Dimension/Min value /s": 0,
    "System / Optimizer/Frame rate/Show FPS and ping": true,
    "Farm / Treadmill/Progress/Auto claim index rewards": true,
    "System / Interface/Quick bars/Keybinds": true,
    "Steal / Auto Steal/Auto steal/Instant steps": 3,
    "Farm / Fuse/Fuse filter/Never fuse": [],
    "Farm / Pen/Auto hatch/Mutations": [],
    "System / Optimizer/Bases/Hide my pets and eggs": false,
    "Event / Halloween/Monsters/Monster order": "Most tokens",
    "Steal / Auto Steal/Filter/Zones": ["Enchanted Forest", "Light Dark", "Titan Temple", "Cherry Blossom", "Cosmic"],
    "Event / Butterfly/Butterfly machine/Auto craft essence": true,
    "Farm / Mutate/Auto mutate/Auto mutate": true,
    "Player / ESP/Others/Other pens ESP": false,
    "Player / ESP/Field eggs/Egg ESP": false,
    "Farm / Pen/Keep eggs/Min value /s": 50000000000,
    "Steal / Auto Steal/Auto steal/Delivery method": "Tween",
    "Farm / Treadmill/Progress/Auto buy trails": true
  }
}

