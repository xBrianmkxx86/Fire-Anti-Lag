-- FIRE ANTI LAG - DISCORD EDITION
if not game:IsLoaded() then game.Loaded:Wait() end

local player = game.Players.LocalPlayer
local pgui = player:WaitForChild("PlayerGui")

if pgui:FindFirstChild("FireHub_Discord") then pgui.FireHub_Discord:Destroy() end

local sg = Instance.new("ScreenGui", pgui)
sg.Name = "FireHub_Discord"
sg.ResetOnSpawn = false

-- --- CONFIGURACIÓN ---
local MiDiscord = "discord.gg/TU_LINK_AQUI" -- CAMBIA ESTO POR TU LINK REAL

-- --- FUNCIÓN DRAGGABLE ---
local function MakeDraggable(obj)
    local dragging, dragInput, dragStart, startPos
    obj.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = obj.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- --- BOTÓN "F" ---
local OpenBtn = Instance.new("TextButton", sg)
OpenBtn.Size = UDim2.new(0, 45, 0, 45)
OpenBtn.Position = UDim2.new(0.02, 0, 0.45, 0)
OpenBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
OpenBtn.Text = "F"
OpenBtn.TextColor3 = Color3.new(1, 1, 1)
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.TextSize = 20
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", OpenBtn).Color = Color3.fromRGB(255, 50, 50)
MakeDraggable(OpenBtn)

-- --- MENÚ ---
local Main = Instance.new("Frame", sg)
Main.Size = UDim2.new(0, 190, 0, 200) -- Un poco más alto para el botón extra
Main.Position = UDim2.new(0.25, 0, 0.4, 0)
Main.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
Main.Visible = false
Main.Active = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", Main).Color = Color3.fromRGB(255, 0, 0)
MakeDraggable(Main)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "FIRE ANTI LAG"
Title.TextColor3 = Color3.fromRGB(255, 50, 50)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14

-- --- CREADOR DE BOTONES ---
local function CreateButton(name, pos, color, cb)
    local btn = Instance.new("TextButton", Main)
    btn.Size = UDim2.new(0.85, 0, 0, 35)
    btn.Position = UDim2.new(0.075, 0, 0, pos)
    btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 10
    Instance.new("UICorner", btn)
    local s = Instance.new("UIStroke", btn)
    s.Color = color
    btn.MouseButton1Click:Connect(cb)
end

-- BOTONES ORIGINALES
CreateButton("ULTRA ANTI-LAG", 45, Color3.fromRGB(255, 0, 0), function()
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("BasePart") or v:IsA("MeshPart") then
            v.Material = Enum.Material.Plastic
            if v:IsA("MeshPart") then v.TextureID = "" end
        elseif v:IsA("Decal") or v:IsA("Texture") or v:IsA("ParticleEmitter") then
            v:Destroy()
        end
    end
end)

CreateButton("FPS BOOSTER", 90, Color3.fromRGB(255, 0, 0), function()
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    for _, p in pairs(game.Players:GetPlayers()) do
        if p.Character then
            for _, item in pairs(p.Character:GetDescendants()) do
                if item:IsA("Shirt") or item:IsA("Pants") or item:IsA("Accessory") then item:Destroy() end
            end
        end
    end
end)

-- NUEVO BOTÓN: DISCORD (Color Azul para resaltar)
CreateButton("COPIAR DISCORD", 145, Color3.fromRGB(88, 101, 242), function()
    if setclipboard then
        setclipboard(MiDiscord)
        local old = Title.Text
        Title.Text = "¡COPIADO!"
        Title.TextColor3 = Color3.new(0, 1, 0)
        task.wait(2)
        Title.Text = old
        Title.TextColor3 = Color3.fromRGB(255, 50, 50)
    else
        Title.Text = "ERROR: NO CLIPBOARD"
    end
end)

OpenBtn.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)
