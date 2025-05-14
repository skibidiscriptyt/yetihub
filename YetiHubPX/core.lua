-- Yeti Hub - Fixed Core Script
-- Made by @SkibidiScript

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

-- Create GUI
local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "YetiHub"
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 300, 0, 200)
frame.Position = UDim2.new(0.3, 0, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
frame.Active = true
frame.Draggable = true

-- Rainbow GUI background
spawn(function()
    while true do
        for hue = 0, 255, 4 do
            frame.BackgroundColor3 = Color3.fromHSV(hue/255, 1, 1)
            wait(0.03)
        end
    end
end)

-- Button Template
local function makeButton(name, pos, callback)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0, 260, 0, 40)
    btn.Position = UDim2.new(0, 20, 0, pos)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.MouseButton1Click:Connect(callback)
end

-- ESP Function
local espEnabled = false
local function toggleESP()
    espEnabled = not espEnabled
    if espEnabled then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local part = player.Character:FindFirstChild("HumanoidRootPart")
                if part and not part:FindFirstChild("ESPBox") then
                    local box = Instance.new("BoxHandleAdornment", part)
                    box.Name = "ESPBox"
                    box.Adornee = part
                    box.Size = Vector3.new(4, 5, 2)
                    box.AlwaysOnTop = true
                    box.ZIndex = 5
                    box.Transparency = 0.3
                    box.Color3 = Color3.fromRGB(0, 255, 0)
                end
            end
        end
    else
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local part = player.Character:FindFirstChild("HumanoidRootPart")
                if part and part:FindFirstChild("ESPBox") then
                    part.ESPBox:Destroy()
                end
            end
        end
    end
end

-- Aimbot Function
local aimbotEnabled = false
local function toggleAimbot()
    aimbotEnabled = not aimbotEnabled
end

RunService.RenderStepped:Connect(function()
    if not aimbotEnabled then return end
    local closest = nil
    local shortestDist = math.huge
    for _, zombie in pairs(workspace:GetChildren()) do
        if zombie:FindFirstChild("Humanoid") and zombie:FindFirstChild("HumanoidRootPart") then
            local dist = (LocalPlayer.Character.HumanoidRootPart.Position - zombie.HumanoidRootPart.Position).magnitude
            if dist < shortestDist then
                shortestDist = dist
                closest = zombie
            end
        end
    end
    if closest then
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(
            LocalPlayer.Character.HumanoidRootPart.Position,
            closest.HumanoidRootPart.Position
        )
    end
end)

-- Walkspeed Boost
local function boostSpeed()
    LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 40
end

-- Add Buttons
makeButton("Toggle ESP", 10, toggleESP)
makeButton("Toggle Aimbot", 60, toggleAimbot)
makeButton("Boost WalkSpeed", 110, boostSpeed)

-- Notification
game.StarterGui:SetCore("SendNotification", {
    Title = "Yeti Hub",
    Text = "GUI loaded successfully!",
    Duration = 5
})
