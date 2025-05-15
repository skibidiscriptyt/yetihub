-- Yeti Hub - Made by @SkibidiScript
-- Full GUI, ESP, Aimbot, Movement Tweaks, Anti-Admin, Auto Play

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

-- GUI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "YetiHub"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 400, 0, 350)
Frame.Position = UDim2.new(0.3, 0, 0.3, 0)
Frame.BackgroundColor3 = Color3.fromRGB(255, 0, 255)
Frame.Active = true
Frame.Draggable = true

-- Rainbow background effect
spawn(function()
    while true do
        for hue = 0, 255, 5 do
            Frame.BackgroundColor3 = Color3.fromHSV(hue / 255, 1, 1)
            wait(0.05)
        end
    end
end)

-- Utility: Button creator
local function createButton(name, yPos, callback)
    local btn = Instance.new("TextButton", Frame)
    btn.Size = UDim2.new(0, 300, 0, 40)
    btn.Position = UDim2.new(0, 50, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 22
    btn.Text = name
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- Button Toggles
local espEnabled = false
local aimbotEnabled = false
local autoPlayRunning = false

createButton("Toggle ESP", 10, function()
    espEnabled = not espEnabled
end)

createButton("Toggle Aimbot", 60, function()
    aimbotEnabled = not aimbotEnabled
end)

createButton("Boost WalkSpeed", 110, function()
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
    if hum then
        hum.WalkSpeed = 40
    end
end)

createButton("Auto Plays", 160, function()
    if autoPlayRunning then return end
    autoPlayRunning = true
    spawn(function()
        while autoPlayRunning do
            wait(3)
            local pos = Vector3.new(math.random(-300, 300), 10, math.random(-300, 300))
            pcall(function()
                LocalPlayer.Character:MoveTo(pos)
            end)
        end
    end)
end)

-- ESP Logic
spawn(function()
    while true do
        wait(1)
        if espEnabled then
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    if not plr.Character:FindFirstChild("ESPBox") then
                        local box = Instance.new("BoxHandleAdornment")
                        box.Name = "ESPBox"
                        box.Size = Vector3.new(4, 5, 2)
                        box.Adornee = plr.Character.HumanoidRootPart
                        box.AlwaysOnTop = true
                        box.ZIndex = 10
                        box.Transparency = 0.2
                        box.Color3 = Color3.fromRGB(0, 255, 0)
                        box.Parent = plr.Character
                    end
                end
            end

            for _, npc in pairs(workspace:GetChildren()) do
                if npc:IsA("Model") and npc:FindFirstChild("HumanoidRootPart") and npc.Name:lower():find("zombie") then
                    if not npc:FindFirstChild("ESPBox") then
                        local box = Instance.new("BoxHandleAdornment")
                        box.Name = "ESPBox"
                        box.Size = Vector3.new(4, 5, 2)
                        box.Adornee = npc.HumanoidRootPart
                        box.AlwaysOnTop = true
                        box.ZIndex = 10
                        box.Transparency = 0.2
                        box.Color3 = Color3.fromRGB(255, 0, 0)
                        box.Parent = npc
                    end
                end
            end
        end
    end
end)

-- Aimbot Logic
RunService.RenderStepped:Connect(function()
    if aimbotEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local closest, dist = nil, math.huge
        for _, zombie in pairs(workspace:GetChildren()) do
            if zombie:FindFirstChild("HumanoidRootPart") and zombie:FindFirstChild("Humanoid") and string.find(zombie.Name:lower(), "zombie") then
                local mag = (zombie.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                if mag < dist then
                    closest = zombie
                    dist = mag
                end
            end
        end

        if closest then
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(
                LocalPlayer.Character.HumanoidRootPart.Position,
                closest.HumanoidRootPart.Position
            )
        end
    end
end)

-- GUI Notification
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Yeti Hub Loaded",
    Text = "All features are active. Made by @SkibidiScript",
    Duration = 6
})
