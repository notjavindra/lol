local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/ionlyusegithubformcmods/1-Line-Scripts/main/Mobile%20Friendly%20Orion')))()
local Player = game.Players.LocalPlayer

-- Create UI Window
local Window = OrionLib:MakeWindow({
    Name = "Forza Hub",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "OrionTest",
    IntroText = "Loading Script..."
})

local Codes = {
    "RELEASE",
    "START",
    "GROUP",
    "WEEKSPECIAL",
    "10KLIKES",
    "HELLOTWITTER",
    "VERIFIED",
    "GEMMY",
    "COBSONAPPROVED"
}

-- Notification Upon Login
OrionLib:MakeNotification({
    Name = "Logged In!",
    Content = "Enjoy " .. Player.Name .. "!",
    Image = "rbxassetid://4483345998",
    Time = 5
})

-- Create Main Tab
local Tab = Window:MakeTab({
    Name = "Main",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local WalkSpeedValue = 16 -- Default WalkSpeed
local JumpPowerValue = 50 -- Default JumpPower

-- WalkSpeed Textbox
Tab:AddTextbox({
    Name = "WalkSpeed",
    Default = "Enter WalkSpeed.",
    TextDisappear = true,
    Callback = function(Value)
        local number = tonumber(Value)
        if number then
            WalkSpeedValue = number
        end
    end  
})

-- JumpPower Textbox
Tab:AddTextbox({
    Name = "JumpPower",
    Default = "Enter JumpPower.",
    TextDisappear = true,
    Callback = function(Value)
        local number = tonumber(Value)
        if number then
            JumpPowerValue = number
        end
    end  
})

-- Loop to constantly apply WalkSpeed and JumpPower
spawn(function()
    while true do
        if Player.Character and Player.Character:FindFirstChild("Humanoid") then
            local Humanoid = Player.Character.Humanoid
            Humanoid.WalkSpeed = WalkSpeedValue
            Humanoid.JumpPower = JumpPowerValue
        end
        wait(0.0)
    end
end)

Tab:AddButton({
    Name = "Auto Redeem Codes",
    Callback = function()
        local ScreenGui = Player.PlayerGui:FindFirstChild("ScreenGui")
        if ScreenGui and ScreenGui:FindFirstChild("Codes") then
            local CodesUI = ScreenGui.Codes.Main
            local InputBox = CodesUI.Input.TextBox
            local RedeemButton = CodesUI.Redeem.TextButton -- Make sure the button name matches your UI
            
            for _, code in ipairs(Codes) do
                -- Set the text in the input box
                InputBox.Text = code
                wait(0.5) -- Small delay to ensure text is set
                
                -- Use fireproximityprompt or just simulate a click using proper method
                -- Method 1: Using FireButton function if it's a TextButton
                if RedeemButton:IsA("TextButton") or RedeemButton:IsA("ImageButton") then
                    -- This will simulate the button being clicked
                    RedeemButton.MouseButton1Down:Connect(function() end):Disconnect()
                    RedeemButton.MouseButton1Up:Connect(function() end):Disconnect()
                end
                
                -- Method 2: Using getconnections (more reliable)
                for _, connection in pairs(getconnections(RedeemButton.MouseButton1Click)) do
                    connection.Function()
                end
                
                -- Add notification for each code attempt
                OrionLib:MakeNotification({
                    Name = "Code Attempted",
                    Content = "Tried code: " .. code,
                    Image = "rbxassetid://4483345998",
                    Time = 2
                })
                
                wait(1.5) -- Wait for redemption to process before trying next code
            end
            
            OrionLib:MakeNotification({
                Name = "Success",
                Content = "All codes have been attempted!",
                Image = "rbxassetid://4483345998",
                Time = 5
            })
        else
            OrionLib:MakeNotification({
                Name = "Error",
                Content = "Codes UI not found!",
                Image = "rbxassetid://4483345998",
                Time = 5
            })
        end
    end    
})

-- Initialize UI
OrionLib:Init()
