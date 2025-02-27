_G.Lock = not _G.Lock 

_G.AutoEquip = not _G.AutoEquip
local NameItem = "Combat"


local mainFolder = workspace.Main
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local IslandName = nil  
local FolderMob = nil   

local HRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")



function CheckLevel()
    
    local MyLevel = game.Players.LocalPlayer.PlayerData.Levels.Value
    
    if MyLevel >= 1 and MyLevel <= 99 then  
        MonName = "Bandit [Lv.5]"
        CFQuest = CFrame.new(-177, 12, -686)
        IslandName = "Starter"   
        FolderMob = "Bandits"
        QuestName = "Quest 1"
    elseif MyLevel >= 100 and MyLevel <= 150 then  
        MonName = "Bandit Leader [Lv.50]"
        CFQuest = CFrame.new(11, 13, -585)
        IslandName = "Starter"      
        FolderMob = "Bandit Leader"
        QuestName = "Quest 2"
    elseif MyLevel >= 151 and MyLevel <= 300 then  
        MonName = "Monkey King [Lv.150]"
        CFQuest = CFrame.new(1008, 10, -114)
        IslandName = "Jungle"      
        FolderMob = "Monkey King"
        QuestName = "Quest 4"
    elseif MyLevel >= 301 and MyLevel <= 600 then  
        MonName = "Snow Bandit Leader [Lv.450]"
        CFQuest = CFrame.new(-174, 15, 962)
        IslandName = "Snow"      
        FolderMob = "Snow Bandit Leader"
        QuestName = "Quest 6"
    elseif MyLevel >= 601 and MyLevel <= 3000 then  
        MonName = "Desert King [Lv.1500]"
        CFQuest = CFrame.new(1571, 11, 1255)
        IslandName = "Desert"      
        FolderMob = "Desert King"
        QuestName = "Quest 8"
    --[[elseif MyLevel >= 1501 and MyLevel <= 3000 then  
        MonName = "Dark Adventure [Lv.2500]"
        CFQuest = CFrame.new(-1305, 34, 2038)
        IslandName = "Shells"      
        FolderMob = "Dark Adventure"
        QuestName = "Quest 10"]]
    elseif MyLevel >= 3001 and MyLevel <= 15000 then  
        MonName = "Sorceror Teacher [Lv.4500]"
        CFQuest = CFrame.new(2398, 12, -911)
        IslandName = "Hidden"      
        FolderMob = "Sorceror Teacher"
        QuestName = "Quest 12"
    --[[elseif MyLevel >= 5001 and MyLevel <= 7500 then  
        MonName = "Frost King [Lv.7500]"
        CFQuest = CFrame.new(-1807, 18, 288)
        IslandName = "Frost"      
        FolderMob = "Frost King"
        QuestName = "Quest 14"]]
    else
        MonName = nil
        CFQuest = nil
        IslandName = nil
        FolderMob = nil
        QuestName = nil 
    end
end

CheckLevel()

spawn(function()
    pcall(function()
        local questPrompt = workspace.Npc.Quest:FindFirstChild(QuestName):FindFirstChild("ProximityPrompt")
        while _G.Lock do task.wait(0.1)
            pcall(function()
                if questPrompt then
                    questPrompt:InputHoldBegin() 
                    task.wait(0.7) 
                    questPrompt:InputHoldEnd()  
                end
            end)
        end
    end)
end)


spawn(function()
    while _G.AutoEquip do task.wait(0)
        if LocalPlayer.Character and LocalPlayer.Backpack:FindFirstChild(NameItem) then
            LocalPlayer.Backpack:FindFirstChild(NameItem).Parent = LocalPlayer.Character
        end
    end
end)


spawn(function()
    game:GetService("RunService").RenderStepped:Connect(function()
    pcall(function()
        if _G.Lock then
            game:GetService'VirtualUser':CaptureController()
            game:GetService'VirtualUser':Button1Down(Vector2.new(1280, 672))
        end
    end)
end) 
end)



repeat task.wait()
    pcall(function()
        CheckLevel()
        
        if not MonName or not CFQuest or not IslandName or not FolderMob or not QuestName then return end  

        local IslandFolder = mainFolder:FindFirstChild(IslandName)
        if not IslandFolder then return end 

        local BanditFolder = IslandFolder:FindFirstChild(FolderMob)
        if not BanditFolder then return end  
        
        local Mon = nil
        local MonFound = false
        for _, v in pairs(BanditFolder:GetChildren()) do
            if v:IsA("Model") and v.Name == MonName then
                local Humanoid = v:FindFirstChild("Humanoid")
                if Humanoid and Humanoid.Health > 0 then
                    Mon = v 
                    MonFound = true
                    Humanoid:GetPropertyChangedSignal("Health"):Connect(function()
                        if Humanoid.Health <= 0 then
                            Mon = nil
                            MonFound = false
                            HRP.CFrame = CFQuest
                        end
                    end)
                    break
                end
            end
        end

        local HRP_ = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        
        if not MonFound then
            HRP_.CFrame = CFQuest
        end
        
        if not HRP_ then return end  

        if MonName then
            local MonName_Pos = Mon.HumanoidRootPart.Position
            HRP_.CFrame = CFrame.lookAt(MonName_Pos + Vector3.new(0, 8, 0), MonName_Pos)
        end
        
    end)
    
until not _G.Lock
