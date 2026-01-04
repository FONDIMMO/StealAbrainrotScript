--==================================================
-- FONDI | STEAL A BRAINROT SCRIPT
--==================================================

-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LP = Players.LocalPlayer
local Camera = workspace.CurrentCamera

--==================================================
-- SETTINGS
--==================================================
local Settings = {
    Invisible = false,
    AutoInvisible = true,
    Fly = false,
    Noclip = false
}

--==================================================
-- CHARACTER
--==================================================
local function GetChar()
    return LP.Character or LP.CharacterAdded:Wait()
end

--==================================================
-- INVISIBILITY
--==================================================
local function SetInvisible(state)
    local char = GetChar()
    for _,v in ipairs(char:GetDescendants()) do
        if v:IsA("BasePart") then
            v.Transparency = state and 1 or 0
            v.LocalTransparencyModifier = state and 1 or 0
        elseif v:IsA("Decal") then
            v.Transparency = state and 1 or 0
        end
    end
end

-- Auto invis when holding Brainrot
RunService.RenderStepped:Connect(function()
    if not Settings.AutoInvisible then return end
    local char = GetChar()
    local tool = char:FindFirstChildOfClass("Tool")
    if tool and tool.Name:lower():find("brain") then
        if not Settings.Invisible then
            Settings.Invisible = true
            SetInvisible(true)
        end
    else
        if Settings.Invisible then
            Settings.Invisible = false
            SetInvisible(false)
        end
    end
end)

--==================================================
-- FLY
--==================================================
local BV, BG
local FlySpeed = 60

RunService.RenderStepped:Connect(function()
    if Settings.Fly and GetChar():FindFirstChild("HumanoidRootPart") then
        local hrp = GetChar().HumanoidRootPart
        if not BV then
            BV = Instance.new("BodyVelocity", hrp)
            BV.MaxForce = Vector3.new(1e9,1e9,1e9)
            BG = Instance.new("BodyGyro", hrp)
            BG.MaxTorque = Vector3.new(1e9,1e9,1e9)
        end

        BG.CFrame = Camera.CFrame
        local dir = Vector3.zero
        if UIS:IsKeyDown(Enum.KeyCode.W) then dir += Camera.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then dir -= Camera.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then dir -= Camera.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then dir += Camera.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.new(0,1,0) end
        if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then dir -= Vector3.new(0,1,0) end

        BV.Velocity = dir * FlySpeed
    else
        if BV then BV:Destroy() BV=nil end
        if BG then BG:Destroy() BG=nil end
    end
end)

--==================================================
-- NOCLIP
--==================================================
RunService.Stepped:Connect(function()
    if Settings.Noclip then
        for _,v in ipairs(GetChar():GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end
end)

--==================================================
-- TELEPORT TO BASE
--==================================================
local function TeleportToBase()
    -- пытаемся найти плот/базу игрока
    for _,v in ipairs(workspace:GetDescendants()) do
        if v:IsA("Model") and v.Name:lower():find(LP.Name:lower()) then
            local p = v:FindFirstChildWhichIsA("BasePart")
            if p then
                GetChar():WaitForChild("HumanoidRootPart").CFrame = p.CFrame + Vector3.new(0,5,0)
                return
            end
        end
    end
    warn("Base not found")
end

--==================================================
-- GUI
--==================================================
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromScale(0.28,0.42)
frame.Position = UDim2.fromScale(0.36,0.28)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.Active = true
frame.Draggable = true

local header = Instance.new("Frame", frame)
header.Size = UDim2.fromScale(1,0.14)
header.BackgroundColor3 = Color3.fromRGB(30,30,30)

local title = Instance.new("TextLabel", header)
title.Size = UDim2.fromScale(0.85,1)
title.Text = "FONDI | STEAL A BRAINROT"
title.TextScaled = true
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1,1,1)
title.TextXAlignment = Enum.TextXAlignment.Left

local arrow = Instance.new("TextButton", header)
arrow.Size = UDim2.fromScale(0.15,1)
arrow.Position = UDim2.fromScale(0.85,0)
arrow.Text = "▼"
arrow.TextScaled = true
arrow.BackgroundTransparency = 1
arrow.TextColor3 = Color3.new(1,1,1)

local content = Instance.new("Frame", frame)
content.Position = UDim2.fromScale(0,0.14)
content.Size = UDim2.fromScale(1,0.86)
content.BackgroundTransparency = 1

local function Button(text,y,cb)
    local b = Instance.new("TextButton", content)
    b.Size = UDim2.fromScale(0.85,0.14)
    b.Position = UDim2.fromScale(0.075,y)
    b.Text = text
    b.TextScaled = true
    b.BackgroundColor3 = Color3.fromRGB(40,40,40)
    b.TextColor3 = Color3.new(1,1,1)
    b.MouseButton1Click:Connect(cb)
end

Button("INVISIBLE",0.05,function()
    Settings.Invisible = not Settings.Invisible
    SetInvisible(Settings.Invisible)
end)

Button("FLY",0.22,function()
    Settings.Fly = not Settings.Fly
end)

Button("NOCLIP",0.39,function()
    Settings.Noclip = not Settings.Noclip
end)

Button("TP TO BASE",0.56,function()
    TeleportToBase()
end)

local collapsed = false
arrow.MouseButton1Click:Connect(function()
    collapsed = not collapsed
    arrow.Text = collapsed and "▲" or "▼"
    TweenService:Create(frame,TweenInfo.new(0.25),{
        Size = collapsed and UDim2.fromScale(0.28,0.14) or UDim2.fromScale(0.28,0.42)
    }):Play()
    content.Visible = not collapsed
end)
