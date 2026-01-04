--==================================================
-- FONDI | STEAL A BRAINROT (FIXED v2)
--==================================================

-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local PhysicsService = game:GetService("PhysicsService")
local LP = Players.LocalPlayer
local Camera = workspace.CurrentCamera

--==================================================
-- CHARACTER
--==================================================
local function Char()
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
-- COLLISION GROUP FIX
--==================================================
pcall(function()
    PhysicsService:CreateCollisionGroup("FONDI_NOCLIP")
end)
PhysicsService:CollisionGroupSetCollidable("FONDI_NOCLIP","Default",false)

--==================================================
-- INVISIBILITY
--==================================================
local function SetInvisible(state)
    for _,v in ipairs(Char():GetDescendants()) do
        if v:IsA("BasePart") then
            v.Transparency = state and 1 or 0
        elseif v:IsA("Accessory") and v:FindFirstChild("Handle") then
            v.Handle.Transparency = state and 1 or 0
        end
    end
end

--==================================================
-- REAL NOCLIP (WALL FIX)
--==================================================
RunService.Stepped:Connect(function()
    if Settings.Noclip then
        for _,v in ipairs(Char():GetDescendants()) do
            if v:IsA("BasePart") then
                PhysicsService:SetPartCollisionGroup(v,"FONDI_NOCLIP")
                v.CanCollide = false
            end
        end
    end
end)

--==================================================
-- FLY (WORKS WITH BRAINROT TOOL)
--==================================================
local LV, AO
local SPEED = 65

RunService.RenderStepped:Connect(function()
    if Settings.Fly then
        local hrp = Char():WaitForChild("HumanoidRootPart")

        if not LV then
            LV = Instance.new("LinearVelocity")
            LV.MaxForce = math.huge
            LV.Attachment0 = Instance.new("Attachment", hrp)
            LV.Parent = hrp

            AO = Instance.new("AlignOrientation")
            AO.Attachment0 = LV.Attachment0
            AO.RigidityEnabled = true
            AO.MaxTorque = math.huge
            AO.Parent = hrp
        end

        AO.CFrame = Camera.CFrame

        local dir = Vector3.zero
        if UIS:IsKeyDown(Enum.KeyCode.W) then dir += Camera.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then dir -= Camera.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then dir -= Camera.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then dir += Camera.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.new(0,1,0) end
        if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then dir -= Vector3.new(0,1,0) end

        LV.VectorVelocity = dir * SPEED
    else
        if LV then LV:Destroy() LV=nil end
        if AO then AO:Destroy() AO=nil end
    end
end)

--==================================================
-- TELEPORT SAFE
--==================================================
local function TeleportSafe()
    Char():WaitForChild("HumanoidRootPart").CFrame = CFrame.new(0,250,0)
end

--==================================================
-- GUI
--==================================================
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.ResetOnSpawn = false

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

local function Btn(txt,y,cb)
    local b = Instance.new("TextButton", content)
    b.Size = UDim2.fromScale(0.85,0.18)
    b.Position = UDim2.fromScale(0.075,y)
    b.Text = txt
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
    collapsed=not collapsed
    arrow.Text = collapsed and "▲" or "▼"
    TweenService:Create(frame,TweenInfo.new(0.25),{
        Size = collapsed and UDim2.fromScale(0.3,0.18) or UDim2.fromScale(0.3,0.4)
    }):Play()
    content.Visible = not collapsed
end)
