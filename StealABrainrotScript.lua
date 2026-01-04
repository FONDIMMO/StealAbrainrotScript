--==================================================
-- FONDI | STEAL A BRAINROT (STABLE)
--==================================================

-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local LP = Players.LocalPlayer
local Camera = workspace.CurrentCamera

--==================================================
-- CHARACTER SAFE
--==================================================
local function GetChar()
    return LP.Character or LP.CharacterAdded:Wait()
end

--==================================================
-- SETTINGS
--==================================================
local Settings = {
    Fly = false,
    Noclip = false,
    Invisible = false
}

--==================================================
-- INVISIBLE (SAFE)
--==================================================
local function SetInvisible(state)
    local char = GetChar()
    for _,v in ipairs(char:GetDescendants()) do
        if v:IsA("BasePart") then
            v.Transparency = state and 1 or 0
            v.CanCollide = not state
        elseif v:IsA("Accessory") and v:FindFirstChild("Handle") then
            v.Handle.Transparency = state and 1 or 0
        end
    end
end

--==================================================
-- NOCLIP (REAL)
--==================================================
RunService.Stepped:Connect(function()
    if Settings.Noclip then
        local char = GetChar()
        for _,v in ipairs(char:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end
end)

--==================================================
-- FLY (OLD BUT STABLE)
--==================================================
local BV, BG
local SPEED = 60

RunService.RenderStepped:Connect(function()
    if Settings.Fly then
        local char = GetChar()
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        if not BV then
            BV = Instance.new("BodyVelocity")
            BV.MaxForce = Vector3.new(1e9,1e9,1e9)
            BV.Parent = hrp

            BG = Instance.new("BodyGyro")
            BG.MaxTorque = Vector3.new(1e9,1e9,1e9)
            BG.Parent = hrp
        end

        BG.CFrame = Camera.CFrame

        local move = Vector3.new()
        if UIS:IsKeyDown(Enum.KeyCode.W) then move += Camera.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then move -= Camera.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then move -= Camera.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then move += Camera.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then move += Vector3.new(0,1,0) end
        if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then move -= Vector3.new(0,1,0) end

        BV.Velocity = move * SPEED
    else
        if BV then BV:Destroy() BV=nil end
        if BG then BG:Destroy() BG=nil end
    end
end)

--==================================================
-- TELEPORT SAFE
--==================================================
local function TeleportSafe()
    GetChar():WaitForChild("HumanoidRootPart").CFrame = CFrame.new(0,200,0)
end

--==================================================
-- GUI (ALWAYS LOADS)
--==================================================
local gui = Instance.new("ScreenGui")
gui.Name = "FONDI_GUI"
gui.ResetOnSpawn = false
gui.Parent = game.CoreGui

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromScale(0.3,0.4)
frame.Position = UDim2.fromScale(0.35,0.3)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.Active = true
frame.Draggable = true

local header = Instance.new("Frame", frame)
header.Size = UDim2.fromScale(1,0.18)
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
content.Position = UDim2.fromScale(0,0.18)
content.Size = UDim2.fromScale(1,0.82)
content.BackgroundTransparency = 1

local function Btn(text,y,cb)
    local b = Instance.new("TextButton", content)
    b.Size = UDim2.fromScale(0.85,0.18)
    b.Position = UDim2.fromScale(0.075,y)
    b.Text = text
    b.TextScaled = true
    b.BackgroundColor3 = Color3.fromRGB(40,40,40)
    b.TextColor3 = Color3.new(1,1,1)
    b.MouseButton1Click:Connect(cb)
end

Btn("INVISIBLE",0.05,function()
    Settings.Invisible = not Settings.Invisible
    SetInvisible(Settings.Invisible)
end)

Btn("FLY",0.27,function()
    Settings.Fly = not Settings.Fly
end)

Btn("NOCLIP",0.49,function()
    Settings.Noclip = not Settings.Noclip
end)

Btn("TP SAFE",0.71,function()
    TeleportSafe()
end)

local collapsed=false
arrow.MouseButton1Click:Connect(function()
    collapsed = not collapsed
    arrow.Text = collapsed and "▲" or "▼"
    TweenService:Create(frame,TweenInfo.new(0.25),{
        Size = collapsed and UDim2.fromScale(0.3,0.18) or UDim2.fromScale(0.3,0.4)
    }):Play()
    content.Visible = not collapsed
end)

print("[FONDI] Script loaded successfully")
