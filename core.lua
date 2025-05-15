-- 🔐 Yeti Hub Key System (72-hour rotating, per user)
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local userId = LocalPlayer.UserId

local function generateKey(id)
    local now = os.time()
    local rotation = now - (now % (72 * 3600))
    local raw = tostring(id) .. "_" .. tostring(rotation)
    return string.sub(HttpService:GenerateGUID(false):gsub("-", "") .. raw, 1, 10):upper()
end

local expectedKey = generateKey(userId)

-- 🛑 Stop here unless user has the right key (example: only you)
local allowedKeys = {
    ["C1433FFAE9"] = true, -- Replace with real rotating keys or store externally
}

if not allowedKeys[expectedKey] then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Yeti Hub 🔐",
        Text = "Access Denied - Invalid Key!",
        Duration = 8
    })
    return
end
-- Yeti Hub v1.0 - By @SkibidiScript
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")
local RunService = game:GetService("RunService")

-- 🔐 Key System
local function generateKey(id)
    local now = os.time()
    local rotation = now - (now % (72 * 3600))
    local raw = tostring(id) .. "_" .. tostring(rotation)
    return string.sub(HttpService:GenerateGUID(false):gsub("-", "") .. raw, 1, 10):upper()
end

local userId = LocalPlayer.UserId
local expectedKey = generateKey(userId)

-- ✅ Optional Whitelist (you can replace this with real keys)
local allowedKeys = {
    [expectedKey] = true -- Let everyone in with their generated key (for now)
}

if not allowedKeys[expectedKey] then
    StarterGui:SetCore("SendNotification", {
        Title = "Yeti Hub 🔐",
        Text = "Access Denied - Invalid Key!",
        Duration = 8
    })
    return
end

-- ✅ GUI Setup
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "YetiHub"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 400, 0, 400)
frame.Position = UDim2.new(0.3, 0, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(255, 0, 255)
frame.Active = true
frame.Draggable = true

-- 🌈 Rainbow Effect
spawn(function()
    while true do
        for hue = 0, 255, 5 do
            frame.BackgroundColor3 = Color3.fromHSV(hue / 255, 1, 1)
            wait(0.05)
        end
    end
end)

-- 🔘 Create Button Utility
local function createButton(text, yPos, callback)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0, 300, 0, 40)
    btn.Position = UDim2.new(0, 50, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 20
    btn.Text = text
    btn.MouseButton1Click:Connect(callback)
end

-- 🔘 Show User Key
createButton("Your Key: " .. expectedKey, 10, function()
    setclipboard(expectedKey)
    StarterGui:SetCore("SendNotification", {
        Title = "Key Copied",
        Text = "Your rotating key was copied to clipboard!",
        Duration = 4
    })
end)

-- 🔍 ESP
local espEnabled = false
createButton("Toggle ESP", 60, function()
    espEnabled = not espEnabled
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Model") and v:FindFirstChild("HumanoidRootPart") and not v:FindFirstChild("YetiESP") then
            local box = Instance.new("BoxHandleAdornment", v)
            box.Name = "YetiESP"
            box.Adornee = v.HumanoidRootPart
            box.Size = Vector3.new(4, 5, 2)
            box.AlwaysOnTop = true
            box.ZIndex = 10
            box.Color3 = Color3.fromRGB(0, 255, 0)
            box.Transparency = espEnabled and 0.2 or 1
        end
    end
end)

-- 🎯 Aimbot
local aimbotEnabled = false
createButton("Toggle Aimbot", 110, function()
    aimbotEnabled = not aimbotEnabled
end)

RunService.RenderStepped:Connect(function()
    if aimbotEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local closest, dist = nil, math.huge
        for _, v in pairs(workspace:GetChildren()) do
            if v.Name:lower():find("zombie") and v:FindFirstChild("HumanoidRootPart") then
                local mag = (v.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                if mag < dist then
                    closest = v
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

-- 🚀 WalkSpeed / JumpPower
createButton("Boost Speed + Jump", 160, function()
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
    if hum then
        hum.WalkSpeed = 50
        hum.JumpPower = 80
    end
end)

-- 🤖 Auto Plays
local autoPlay = false
createButton("Auto Plays (Farm)", 210, function()
    autoPlay = not autoPlay
    StarterGui:SetCore("SendNotification", {
        Title = "Auto Plays",
        Text = autoPlay and "Running..." or "Stopped!",
        Duration = 4
    })
    spawn(function()
        while autoPlay and LocalPlayer.Character do
            wait(2)
            local randomPos = Vector3.new(
                math.random(-300, 300),
                10,
                math.random(-300, 300)
            )
            pcall(function()
                LocalPlayer.Character:MoveTo(randomPos)
            end)
        end
    end)
end)

-- ✅ Finished
StarterGui:SetCore("SendNotification", {
    Title = "Yeti Hub Loaded ✅",
    Text = "All functions are ready! Made by @SkibidiScript",
    Duration = 5
})
