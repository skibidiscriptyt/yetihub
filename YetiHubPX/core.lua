-- ✅ GUI Setup
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "YetiHub"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 400, 0, 350)
Frame.Position = UDim2.new(0.3, 0, 0.3, 0)
Frame.BackgroundColor3 = Color3.fromRGB(255, 0, 255)
Frame.Active = true
Frame.Draggable = true

-- Rainbow Background
spawn(function()
    while true do
        for hue = 0, 255, 5 do
            Frame.BackgroundColor3 = Color3.fromHSV(hue / 255, 1, 1)
            wait(0.05)
        end
    end
end)

-- Utility to create buttons
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

-- Button 1: ESP Toggle
local espEnabled = false
createButton("Toggle ESP", 10, function()
    espEnabled = not espEnabled
    print("ESP Toggled:", espEnabled)
end)

-- Button 2: Aimbot Toggle
local aimbotEnabled = false
createButton("Toggle Aimbot", 60, function()
    aimbotEnabled = not aimbotEnabled
    print("Aimbot Toggled:", aimbotEnabled)
end)

-- Button 3: WalkSpeed Boost
createButton("Boost WalkSpeed", 110, function()
    local hum = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
    if hum then
        hum.WalkSpeed = 40
    end
end)

-- ✅ NEW BUTTON: Auto Play
local autoPlayRunning = false
createButton("Auto Plays", 160, function()
    if autoPlayRunning then return end
    autoPlayRunning = true

    spawn(function()
        while autoPlayRunning do
            wait(3)
            local pos = Vector3.new(math.random(-300, 300), 10, math.random(-300, 300))
            pcall(function()
                game.Players.LocalPlayer.Character:MoveTo(pos)
            end)
        end
    end)
end)
