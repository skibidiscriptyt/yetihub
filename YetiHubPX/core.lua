-- Yeti Hub Core - @SkibidiScript
-- Auto Play, Aimbot, ESP, Movement Tweaks, Anti-Admin

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

-- ✅ Anti-Admin Detection
local function isAdmin(plr)
    local roles = {"Admin", "Moderator", "Staff"}
    for _, v in pairs(roles) do
        if plr:GetRoleInGroup(1) == v or string.find(plr.Name:lower(), "mod") then
            return true
        end
    end
    return false
end

Players.PlayerAdded:Connect(function(plr)
    if isAdmin(plr) then
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Yeti Hub",
            Text = "Admin Detected. Auto-Kill Disabled.",
            Duration = 5
        })
    end
end)

-- ✅ ESP for Players, Zombies, Items
local function createESP(obj, color)
    local box = Instance.new("BoxHandleAdornment", obj)
    box.Size = Vector3.new(4, 5, 2)
    box.Adornee = obj
    box.Color3 = color
    box.AlwaysOnTop = true
    box.ZIndex = 10
    box.Transparency = 0.2
end

for _, plr in pairs(Players:GetPlayers()) do
    if plr ~= LocalPlayer and plr.Character then
        createESP(plr.Character:FindFirstChild("HumanoidRootPart"), Color3.fromRGB(0, 255, 0))
    end
end

workspace.ChildAdded:Connect(function(child)
    if child.Name:lower():find("zombie") then
        wait(1)
        createESP(child:FindFirstChild("HumanoidRootPart"), Color3.fromRGB(255, 0, 0))
    elseif child.Name:lower():find("item") then
        wait(1)
        createESP(child:FindFirstChild("Handle") or child:FindFirstChildWhichIsA("Part"), Color3.fromRGB(255, 255, 0))
    end
end)

-- ✅ Auto Aim (Aimbot Max Lock)
local function getClosestZombie()
    local closest, dist = nil, math.huge
    for _, v in pairs(workspace:GetChildren()) do
        if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Name:lower():find("zombie") then
            local mag = (v.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).magnitude
            if mag < dist then
                closest = v
                dist = mag
            end
        end
    end
    return closest
end

RunService.RenderStepped:Connect(function()
    local target = getClosestZombie()
    if target then
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(
            LocalPlayer.Character.HumanoidRootPart.Position,
            target.HumanoidRootPart.Position
        )
    end
end)

-- ✅ Auto Play (Simple Walk-to-Win Logic)
local function autoWalk()
    while true do
        wait(3)
        local pos = Vector3.new(math.random(-500, 500), 10, math.random(-500, 500))
        pcall(function()
            LocalPlayer.Character:MoveTo(pos)
        end)
    end
end

spawn(autoWalk)

-- ✅ WalkSpeed / JumpPower / Hitbox Extender
LocalPlayer.Character:WaitForChild("Humanoid").WalkSpeed = 40
LocalPlayer.Character.Humanoid.JumpPower = 80

for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
    if v:IsA("Part") and v.Name == "HumanoidRootPart" then
        v.Size = Vector3.new(10, 10, 10)
        v.Transparency = 0.5
    end
end

-- ✅ GUI Setup
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "YetiHub"
local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 400, 0, 300)
Frame.Position = UDim2.new(0.3, 0, 0.3, 0)
Frame.BackgroundColor3 = Color3.fromRGB(255, 0, 255)
Frame.Active = true
Frame.Draggable = true

-- Rainbow effect
spawn(function()
    while true do
        for hue = 0, 255, 5 do
            Frame.BackgroundColor3 = Color3.fromHSV(hue / 255, 1, 1)
            wait(0.05)
        end
    end
end)

-- ✅ GUI Notification
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Yeti Hub Loaded",
    Text = "All functions active. Made by @SkibidiScript",
    Duration = 6
})
