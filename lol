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
    "COBSONAPPROVED",
    "70KLIKES",
    "80KLIKES",
    "SUPERUPDATE",
    "SUMMER",
    "100KLIKES",
    "120KLIKES",
    "AUTUMN",
    "90KLIKES",
    "SPRING"
}

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

local AutoSpin = false -- Variable to track toggle state

Tab:AddToggle({
    Name = "Auto Spin",
    Default = false,
    Callback = function(Value)
        AutoSpin = Value -- Update toggle state

        if AutoSpin then
            spawn(function()
                while AutoSpin do
                    local success, response = pcall(function()
                        return game.ReplicatedStorage.Remotes.Spin:InvokeServer()
                    end)

                    -- Optional: Add a notification if the spin fails
                    if not success then
                        OrionLib:MakeNotification({
                            Name = "Spin Failed",
                            Content = "Error: " .. tostring(response),
                            Image = "rbxassetid://4483345998",
                            Time = 3
                        })
                    end

                    wait(1) -- Adjust delay to prevent excessive server calls
                end
            end)
        end
    end
})

Tab:AddButton({
    Name = "AddStat",
    Callback = function()
        local RemoteEvent = game.ReplicatedStorage.Remotes:FindFirstChild("AddStat")

        if RemoteEvent and RemoteEvent:IsA("RemoteEvent") then
            local success, response = pcall(function()
                return RemoteEvent:FireServer()
            end)

            if success then
                OrionLib:MakeNotification({
                    Name = "Success",
                    Content = "Kill command executed!",
                    Image = "rbxassetid://4483345998",
                    Time = 3
                })
            else
                OrionLib:MakeNotification({
                    Name = "Error",
                    Content = "Failed: " .. tostring(response),
                    Image = "rbxassetid://4483345998",
                    Time = 3
                })
            end
        else
            OrionLib:MakeNotification({
                Name = "Error",
                Content = "Kill function not found!",
                Image = "rbxassetid://4483345998",
                Time = 3
            })
        end
    end
})

        

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
