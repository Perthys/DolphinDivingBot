--[[
    Name: DolphinDivingBot.lua
    Version: 1.0
    Author: Perth
    Description: A bot that dolphin dives onto people and kills them (made for this game) https://www.roblox.com/games/6650331930/new-sword-steal-time-testing
    Dependencies: none
    Licence: MIT
]]
local _G = _G;

local SwordString = "Rainbow Sword"; -- I was too lazy to make this universal so if you do congrast you're cool

local Config = {
    
    Distance = {
        ['AttackRange'] = 15;
        ['ReachRange'] = 10;
        ['SwordEquipRange'] = 40;
        ['LungDistance'] = 15;
        ['RunAwayRange'] = 20;
    };
}


_G.Toggle = true;

-- // Localized Globals \\
local game = game;
local workspace = workspace;

-- // Localizeds Global Functions \\
local task = task;
local wait = task.wait;
local spawn = task.spawn;

local print = print;
local warn = warn;
local error = error;

local table = table
local table_sort = table.sort
local table_insert = table.insert

local pairs = pairs;
local ipairs = ipairs

local vector3_new = Vector3.new

local cframe_new = CFrame.new
local cframe_fromEulerAnglesXYZ = CFrame.fromEulerAnglesXYZ

local instance_new = Instance.new

local Color3_fromHSV = Color3.fromHSV

local BrickColor_random = BrickColor.random

local math = math
local math_rad = math.rad
local math_random = math.random

local firetouchinterest = firetouchinterest;

-- // Localized GetService Method \\
local GetService = game.GetService

local Players = GetService(game, "Players");
local PathFindingService = GetService(game, "PathfindingService");
local HttpService = GetService(game, 'HttpService');
local RunService = GetService(game, "RunService")

-- // Localized Service Methods \\
local GetPlayers = Players.GetPlayers;

local CreatePath = PathFindingService.CreatePath;

local GetAsync = game.HttpGetAsync;

local ray_new = Ray.new
local FindPartOnRayWithIgnoreList = workspace.FindPartOnRayWithIgnoreList


-- // Player Vars \\ --
local LocalPlayer = Players.LocalPlayer;

local Character, Head, HumanoidRootPart, Humanoid;
local Backpack = LocalPlayer.Backpack;
-- // Localized Strings \\ 

local HumanoidRootPartString = "HumanoidRootPart";
local HumanoidString = "Humanoid"
local HandleString = "Handle"
local HitboxString = "Hitbox"

local _Part = workspace:FindFirstChild("Areas"):FindFirstChild("Default"):FindFirstChild("SafeArea"):FindFirstChild("Light")

local MainSafe = workspace.Areas.Default.SafeArea.MainSafe
Character = LocalPlayer.Character do
    
    Head = Character:WaitForChild("Head");
    HumanoidRootPart = Character:WaitForChild('HumanoidRootPart') or Character.PrimaryPart;
    Humanoid = Character:WaitForChild("Humanoid"); do
        
       --[[ if Humanoid.HumanoidRigType == RigTypeSixEnum then
            
            
            else
                
        end;]]
    end;
end;

for __Index, __Value in pairs(game:GetDescendants()) do
    if not __Value:IsDescendantOf(LocalPlayer) and not __Value:IsDescendantOf(Character) and __Value:IsA('TouchTransmitter') then
            __Value:Destroy()
    end
end
    
Players.PlayerAdded:Connect(function(Player)
    Player.Backpack:ChildAdded(function(_Instance)
        if _Instance:IsA('Tool') then
            local Transmitter = _Instance:FindFirstChildOfClass('TouchTransmitter')
            
            if Transmitter then
                Transmitter:Destroy()
            end
        end
    end)
end)


local function _CharacterAdded(_Character)
    Character = LocalPlayer.Character do
    
    Head = Character:WaitForChild("Head");
    HumanoidRootPart = Character:WaitForChild('HumanoidRootPart') or Character.PrimaryPart;
    Humanoid = Character:WaitForChild("Humanoid"); do
        
       --[[ if Humanoid.HumanoidRigType == RigTypeSixEnum then
            
            
            else
                
        end;]]
    end;
end;


end
local function GetMagnitude(Part1, Part2)
    return (Part2.Position - Part1.Position).magnitude;
end;

local function CreateVisualizer(Part)
    if Part then
        local CheckBox = Part:FindFirstChild('SelectionBoxCreated')
        
        if not CheckBox then
            local SelectionBox = instance_new('SelectionBox'); do
                SelectionBox.Parent = Part
                SelectionBox.Adornee = Part
                SelectionBox.Name = "SelectionBoxCreated"
                
                
                if _Part then
                    coroutine.wrap(function()
                        while _G.Toggle do
                            SelectionBox.Color3 = _Part.Color
                            wait()
                        end
                    end)()
                end
            end
		end
    end
end

local function EquipSword()
    
    local _Sword = Character:FindFirstChild(SwordString)
    if not _Sword then
        local Sword = Backpack:FindFirstChild(SwordString)
        
        if Sword then
            Sword.Parent = Character
        end
        
        return Sword
        
    else
        return _Sword
    end
    
    return false
end;

local function DequipTools()
    for Index, Value in pairs(Character:GetChildren()) do
        if Value:IsA('Tool') then
            Value.Parent = Backpack
        end
    end
end;


local function LookAt(Part1, PositionArg) 
    local Position = CFrame.new(Part1.Position, PositionArg)
    Part1.CFrame = Position 
end

local function Reach(Tool, Size)
    local Size = vector3_new(10, 10, Size)
    
    local Hitbox = Tool:FindFirstChild(HitboxString);
    
    if Hitbox then
        Hitbox.Size = Size
        CreateVisualizer(Hitbox)
    end
end

local function Attack(Sword, TargetPart)
    local Handle = Sword:FindFirstChild(HandleString);

    Sword:Activate()
    if Handle then
        firetouchinterest(Handle, TargetPart, 0)
        firetouchinterest(Handle, TargetPart, 1)
    end
end

local function Jump()
    Humanoid.Jump = true;
end

local function Spin(Part1, Part2)
    if part1 and part2 then
        local CFrameValue = Part1.CFrame:ToObjectSpace(Part2.CFrame);
        
        if CFrameValue.X >0 then
            for i = 1,30 do
                Part1.CFrame = Part1.CFrame * cframe_fromEulerAnglesXYZ(0, math_rad(40), 0)
            end
        else
            for i = 1,30 do
                Part1.CFrame = Part1.CFrame * cframe_fromEulerAnglesXYZ(0, math_rad(-40), 0)
            end
        end
    end
end

local function MoveToRelative(Vector)
    Humanoid:MoveTo(HumanoidRootPart.CFrame * Vector.p)
end

local function Avoid()
    Humanoid:Move(Vector3.new(0,0,-5),false)
end

local function CheckInRegion(____HumanoidRootPart)
    local XBound = {MainSafe.Position.X-(MainSafe.Size.X/2)-1,MainSafe.Position.X+(MainSafe.Size.X/2)+1}
    local ZBound = {MainSafe.Position.Z-(MainSafe.Size.Z/2)-1,MainSafe.Position.Z+(MainSafe.Size.Z/2)+1}
    return (____HumanoidRootPart.Position.X > XBound[1] and ____HumanoidRootPart.Position.X < XBound[2] and ____HumanoidRootPart.Position.Z > ZBound[1] and ____HumanoidRootPart.Position.Z < ZBound[2])
end

local function GetPlayerPriorityTable()
    local PlayersTable = GetPlayers(Players);
    
    local NewTable = {};
    
    for Index, Variable in ipairs(PlayersTable) do
        if Variable ~= LocalPlayer and Variable.Character then
            
            local _Humanoid = Variable.Character:FindFirstChild(HumanoidString)
            local _HumanoidRootPart = Variable.Character:FindFirstChild(HumanoidRootPartString);
            
            if _Humanoid and _HumanoidRootPart then
                
                if not CheckInRegion(_HumanoidRootPart) then
                    if _Humanoid.Health > 0 and _Humanoid.Health < 101 then
            
                        local CurrentIndex = #NewTable + 1

        
                        if _HumanoidRootPart then
                            table_insert(NewTable, CurrentIndex, {
                                Variable.Name; 
                                GetMagnitude(HumanoidRootPart, _HumanoidRootPart);
                                Variable;
                            })
                        end
            
                        continue
                    end
                end
            
            end
        end
    
    end;
    
    table_sort(NewTable, function(Variable1,Variable2)
		return Variable1[2] < Variable2[2]
    end)
    
    return NewTable
end;

local function GetBestPlayer()
    return GetPlayerPriorityTable()[1]
end;

local Dodging = false;
local Attacking = false;
local RunAway = false;

local function Main()
    EquipSword()
    Character = LocalPlayer.Character do
    
    Head = Character:WaitForChild("Head");
    HumanoidRootPart = Character:WaitForChild('HumanoidRootPart') or Character.PrimaryPart;
    Humanoid = Character:WaitForChild("Humanoid"); do
        
       --[[ if Humanoid.HumanoidRigType == RigTypeSixEnum then
            
            
            else
                
        end;]]
        end;
    end;


    --Humanoid.Jump = true;
    Humanoid.AutoRotate = false
    local Target = GetBestPlayer();


    if not RunAway then
        if Target then 
            if not Dodging or Attacking then
                LookAt(HumanoidRootPart, Target[3].Character:FindFirstChild(HumanoidRootPartString).Position) 
            end
        end

        local _Sword = Target[3]:FindFirstChildOfClass('Tool')


        if _Sword then
            if GetMagnitude(_Sword.Handle, HumanoidRootPart) <= 20 then
                Dodging = true;
                LookAt(HumanoidRootPart, Sword.Handle.Position)
            
                MoveToRelative(cframe_new(0,0,30))
                wait()
                Dodging = false;
            end
        end


        if Target[2] <= Config.Distance.SwordEquipRange then
            local Sword = EquipSword()

            if Sword then
                Attack(Sword,Target[3].Character:FindFirstChild(HumanoidRootPartString))
                Reach(Sword, Config.Distance.ReachRange)
                
                MoveToRelative(cframe_new(0,0,-Target[2] + 10))
                if Target[2] <= Config.Distance.AttackRange then
                    Attack(Sword,Target[3].Character:FindFirstChild(HumanoidRootPartString))
                    LookAt(HumanoidRootPart, Target[3].Character:FindFirstChild(HumanoidRootPartString).CFrame * cframe_new(0,0,0).p) 
                    Spin(HumanoidRootPart, Target[3].Character:FindFirstChild(HumanoidRootPartString))
                end

                if Target[2] <= Config.Distance.LungDistance then
                    Spin(HumanoidRootPart, Target[3].Character:FindFirstChild(HumanoidRootPartString))
                    HumanoidRootPart.CFrame = HumanoidRootPart.CFrame * cframe_new(0,1,0)
                    LookAt(HumanoidRootPart, Target[3].Character:FindFirstChild(HumanoidRootPartString).CFrame * cframe_new(0,-10,-3).p)
                    --LookAt(HumanoidRootPart, Target[3].Character:FindFirstChild(HumanoidRootPartString).CFrame * cframe_new(0,-5,0).p) 
                end
            end


        elseif Target[2] > Config.Distance.SwordEquipRange then
            --DequipTools()
        
        end

    end
    
    if Humanoid.Health == 80 then
        RunAway = true;
        
        repeat wait()
            local Target = GetBestPlayer();
            
            
            if Target[2] <= Config.Distance.RunAwayRange then
                LookAt(HumanoidRootPart, Target[3].Character:FindFirstChild(HumanoidRootPartString).CFrame * cframe_new(0,2.5,0).p)
                MoveToRelative(cframe_new(0,0,50))
                
            elseif Target[2] > Config.Distance.RunAwayRange then
                LookAt(HumanoidRootPart, Target[3].Character:FindFirstChild(HumanoidRootPartString).CFrame * cframe_new(0,0,0).p)
            end
            
        until Humanoid.Health > 80 or not _G.Toggle
        RunAway = false;
    end
end

--[[
while _G.Toggle do
    Main()
    
    wait()
end
]]
_G.Connection = RunService.RenderStepped:Connect(function()
    Main()
end)

--[[

if not _G.Toggle then
    _G.Connection:Disconnect()
end
]]

LocalPlayer.CharacterAdded:Connect(_CharacterAdded)
