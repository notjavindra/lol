local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/ionlyusegithubformcmods/1-Line-Scripts/main/Mobile%20Friendly%20Orion')))()
local Player = game.Players.LocalPlayer

-- Create UI Window
local Window = OrionLib:MakeWindow({
    Name = "ForzaHub Ball Eating Simulator",
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

local AutoGift = false -- Variable to track toggle state

Tab:AddToggle({
    Name = "Auto Claim Gifts",
    Default = false
    Callback = function(Value)
        AutoGift = Value -- Update toggle state

        if AutoGift then
            spawn(function()
                while AutoGift do
                    local success, response = pcall(function()
                        return game.ReplicatedStorage.Remotes.Gift:InvokeServer()
                    end)

                    -- Optional: Add a notification if the spin fails
                    if not success then
                        OrionLib:MakeNotification({
                            Name = "Claim Gift Failed",
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

local Players = game:GetService("Players")
local SelectedPlayer = nil -- Track the selected player

-- Function to get and update the player list

local function updatePlayerList()
    local playerNames = {}

    for _, player in ipairs(Players:GetPlayers()) do
        table.insert(playerNames, player.Name)
    end

    -- Update the dropdown with current player names
    playerDropdown:UpdateDropdown({
        Name = "Select Player",
        Options = playerNames
    })
end

-- Dropdown to select a player
local playerDropdown = Tab:AddDropdown({
    Name = "Select Player",
    Default = nil,
    Options = {},  -- This will be populated dynamically
    Callback = function(Value)
        SelectedPlayer = Value -- Store selected player
    end
})

-- Button to refresh the player list in the dropdown
Tab:AddButton({
    Name = "Refresh Player List",
    Callback = function()
        updatePlayerList()
    end
})

-- Button to kill the selected player
Tab:AddButton({
    Name = "Kill Player",
    Callback = function()
        if SelectedPlayer then
            local RemoteFunction = game.ReplicatedStorage.Remotes:FindFirstChild("Kill")
            if RemoteFunction and RemoteFunction:IsA("RemoteFunction") then
                RemoteFunction:InvokeServer(Players[SelectedPlayer])
                OrionLib:MakeNotification({
                    Name = "Success",
                    Content = "Killed " .. SelectedPlayer,
                    Image = "rbxassetid://4483345998",
                    Time = 3
                })
            else
                OrionLib:MakeNotification({
                    Name = "Error",
                    Content = "Kill function not found!",
                    Image = "rbxassetid://4483345998",
                    Time = 3
                })
            end
        else
            OrionLib:MakeNotification({
                Name = "Error",
                Content = "No player selected!",
                Image = "rbxassetid://4483345998",
                Time = 3
            })
        end
    end
})

-- Button to kick the selected player
Tab:AddButton({
    Name = "Kick Player",
    Callback = function()
        if SelectedPlayer then
            local RemoteFunction = game.ReplicatedStorage.Remotes:FindFirstChild("Kick")
            if RemoteFunction and RemoteFunction:IsA("RemoteFunction") then
                RemoteFunction:InvokeServer(Players[SelectedPlayer])
                OrionLib:MakeNotification({
                    Name = "Success",
                    Content = "Kicked " .. SelectedPlayer,
                    Image = "rbxassetid://4483345998",
                    Time = 3
                })
            else
                OrionLib:MakeNotification({
                    Name = "Error",
                    Content = "Kick function not found!",
                    Image = "rbxassetid://4483345998",
                    Time = 3
                })
            end
        else
            OrionLib:MakeNotification({
                Name = "Error",
                Content = "No player selected!",
                Image = "rbxassetid://4483345998",
                Time = 3
            })
        end
    end
})

-- Initialize player list on script start
updatePlayerList()

-- Update player list when a player joins or leaves
Players.PlayerAdded:Connect(updatePlayerList)
Players.PlayerRemoved:Connect(updatePlayerList)



        

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
