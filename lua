-- FIRE ANTI LAG: UNIVERSAL EDITION (NO WAIT - FIXED IMAGE)
-- Optimizado para carga instantánea y máxima compatibilidad

if not game:IsLoaded() then game.Loaded:Wait() end

local player = game.Players.LocalPlayer
local pgui = player:WaitForChild("PlayerGui")
local HttpService = game:GetService("HttpService")
local SaveFile = "FireSettings_V1.json"

local Settings = {UltraAntiLag = false, FPSBooster = false}

-- --- SISTEMA DE GUARDADO ---
local function SafeWrite(file, data)
    pcall(function() if writefile then writefile(file, data) end end)
end

local function SafeRead(file)
    local data = nil
    pcall(function() if isfile and isfile(file) then data = readfile(file) end end)
    return data
end

-- --- FUNCIONES DE OPTIMIZACIÓN (BACKGROUND THREAD) ---
local function ApplyUltra()
    task.spawn(function()
        local objects = game:GetDescendants()
        for i, v in pairs(objects) do
            if i % 100 == 0 then task.wait() end -- Evita lag al aplicar
            pcall(function()
                if v:IsA("BasePart") or v:IsA("MeshPart") then
                    v.Material = Enum.Material.Plastic
                    v.Reflectance = 0
                    if v:IsA("MeshPart") then v.TextureID = "" end
                elseif v:IsA("Decal") or v:IsA("Texture") or v:IsA("ParticleEmitter") or v:IsA("Trail") then
                    v:Destroy()
                end
            end)
        end
    end)
end

local function ApplyFPS()
    pcall(function()
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        for _, p in pairs(game.Players:GetPlayers()) do
            if p.Character then
                for _, item in pairs(p.Character:GetDescendants()) do
                    if item:IsA("Shirt") or item:IsA("Pants") or item:IsA("Accessory") then
                        item:Destroy()
                    end
                end
            end
        end
    end)
end

-- --- INTERFAZ ---
if pgui:FindFirstChild("FireUniversal") then pgui.FireUniversal:Destroy() end
local sg = Instance.new("ScreenGui", pgui); sg.Name = "FireUniversal"; sg.ResetOnSpawn = false

local Main = Instance.new("Frame", sg)
Main.Size = UDim2.new(0, 190, 0, 190); Main.Position = UDim2.new(0.25, 0, 0.4, 0)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10); Main.Visible = false; Main.Active = true
Instance.new("UICorner", Main); Instance.new("UIStroke", Main).Color = Color3.fromRGB(255, 0, 0)

-- BOTÓN CON ICONO DE FUEGO OFICIAL (NO SE BORRA)
local OpenBtn = Instance.new("ImageButton", sg)
OpenBtn.Size = UDim2.new(0, 50, 0, 50)
OpenBtn.Position = UDim2.new(0.02, 0, 0.45, 0)
OpenBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
-- Este ID es fuego oficial de la librería de Roblox, carga siempre:
OpenBtn.Image = "rbxassetid://10734950309" 
OpenBtn.ImageColor3 = Color3.fromRGB(255, 60, 0) -- Tinte naranja/rojo fuego
OpenBtn.ScaleType = Enum.ScaleType.Fit
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(0, 12)
local Stroke = Instance.new("UIStroke", OpenBtn)
Stroke.Color = Color3.fromRGB(255, 0, 0)
Stroke.Thickness = 2

-- Función Drag Robusta (Mejorada)
local function Drag(obj)
    local UIS = game:GetService("UserInputService")
    local dragging, dragStart, startPos
    obj.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = obj.Position
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    obj.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end
Drag(OpenBtn); Drag(Main)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 40); Title.Text = "FIRE ANTI LAG"; Title.TextColor3 = Color3.fromRGB(255, 50, 50)
Title.BackgroundTransparency = 1; Title.Font = Enum.Font.GothamBold; Title.TextSize = 14

local function CreateButton(name, pos, color, cb)
    local btn = Instance.new("TextButton", Main)
    btn.Size = UDim2.new(0.85, 0, 0, 35); btn.Position = UDim2.new(0.075, 0, 0, pos)
    btn.BackgroundColor3 = Color3.fromRGB(15, 15, 15); btn.Text = name; btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold; btn.TextSize = 10
    Instance.new("UICorner", btn); Instance.new("UIStroke", btn).Color = color
    btn.MouseButton1Click:Connect(cb)
end

CreateButton("ULTRA ANTI-LAG", 45, Color3.fromRGB(255, 0, 0), function()
    Settings.UltraAntiLag = true
    SafeWrite(SaveFile, HttpService:JSONEncode(Settings))
    ApplyUltra()
end)

CreateButton("FPS BOOSTER", 90, Color3.fromRGB(255, 0, 0), function()
    Settings.FPSBooster = true
    SafeWrite(SaveFile, HttpService:JSONEncode(Settings))
    ApplyFPS()
end)

CreateButton("COPIAR DISCORD", 135, Color3.fromRGB(88, 101, 242), function()
    if setclipboard then setclipboard("discord.gg/RBMrFxbbSb") end
end)

-- --- AUTO-LOAD ---
local savedData = SafeRead(SaveFile)
if savedData then
    local success, decoded = pcall(HttpService.JSONDecode, HttpService, savedData)
    if success then
        Settings = decoded
        if Settings.UltraAntiLag then ApplyUltra() end
        if Settings.FPSBooster then ApplyFPS() end
    end
end

OpenBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)
