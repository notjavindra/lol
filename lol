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
    Content = "Enjoy " .. Player.Name .. ".",
    Image = "rbxassetid://4483345998",
    Time = 5
})

-- Create Main Tab
local Tab = Window:MakeTab({
    Name = "Main",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- WalkSpeed Textbox
Tab:AddTextbox({
    Name = "WalkSpeed",
    Default = "Enter WalkSpeed.",
    TextDisappear = true,
    Callback = function(Value)
        local number = tonumber(Value)
        if number and Player.Character and Player.Character:FindFirstChild("Humanoid") then
            Player.Character.Humanoid.WalkSpeed = number
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
        if number and Player.Character and Player.Character:FindFirstChild("Humanoid") then
            Player.Character.Humanoid.JumpPower = number
        end
    end  
})

-- Auto Redeem Codes Button
Tab:AddButton({
    Name = "Auto Redeem Codes",
    Callback = function()
        local ScreenGui = Player.PlayerGui:FindFirstChild("ScreenGui")
        if ScreenGui and ScreenGui:FindFirstChild("Codes") then
            local CodesUI = ScreenGui.Codes.Main
            local InputBox = CodesUI.Input.Textbox
            local RedeemButton = CodesUI.Reedeem.TextButton
            
            for _, code in ipairs(Codes) do
                InputBox.Text = code
                wait(0.5) -- Small delay to simulate input
                fireclickdetector(RedeemButton) -- Simulating button press
                wait(1) -- Wait for redemption to process
            end
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
