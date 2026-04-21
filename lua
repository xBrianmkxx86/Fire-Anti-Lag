-- FIRE ANTI-LAG | GHOST EDITION
-- Diseñado para no crashear con otros scripts
if not game:IsLoaded() then game.Loaded:Wait() end

-- Espera 10 segundos para que tu script de Farm cargue primero
task.wait(10)

local function CleanGame()
    -- Optimización de Renderizado nativa
    settings().Rendering.QualityLevel = 1
    
    local Lighting = game:GetService("Lighting")
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 9e9
    
    -- Borrado de texturas sin saturar el motor
    for _, v in pairs(game:GetDescendants()) do
        pcall(function()
            if v:IsA("Part") or v:IsA("MeshPart") then
                v.Material = Enum.Material.SmoothPlastic
                v.Reflectance = 0
            elseif v:IsA("Decal") or v:IsA("Texture") then
                v:Destroy()
            elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
                v.Enabled = false
            end
        end)
    end
end

-- Ejecutar limpieza en un hilo separado
task.spawn(CleanGame)

-- Evitar que nuevos efectos ralenticen el juego
game.Workspace.DescendantAdded:Connect(function(v)
    pcall(function()
        if v:IsA("ParticleEmitter") or v:IsA("Trail") then
            v.Enabled = false
        elseif v:IsA("Decal") or v:IsA("Texture") then
            v:Destroy()
        end
    end)
end)
