-- FlowAuth LRM compatibility variables
LRM_IsUserPremium=false
LRM_LinkedDiscordID="\048"
LRM_ScriptName="\070\114\101\101"
LRM_TotalExecutions=0
LRM_SecondsLeft=math.huge
LRM_UserNote="\078\111\116\032\115\112\101\099\105\102\105\101\100"
LRM_ScriptVersion="\048\046\048\046\048\046\049"
LRM_ExecutionTrace="\102\097\049\095\105\087\089\116\048\109\082\079\118\076\088\079\089\086\066\057\104\083\080\053\081\118\078\078"
-- FlowAuth target internal
-- FlowAuth execution lease
do
local environment=(getgenv and getgenv())or _G
local previous=type(environment)=="table" and rawget(environment,"FlowAuth") or nil
if type(previous)=="table" and type(previous.Stop)=="function" then pcall(previous.Stop,previous) end
local active=true
local client={}
local keyedFeatureOrigin="\104\116\116\112\115\058\047\047\102\108\111\119\097\117\116\104\046\110\101\116"
local keyedFeatureGatewayOrigin="\104\116\116\112\115\058\047\047\102\108\111\119\097\117\116\104\046\110\101\116"
local keyedFeatureBusy={}
local function keyedFeatureHash(value)
if type(value)~="string" then return nil end
value=string.lower(value)
if #value~=32 or not string.match(value,"^[a-f0-9]+$") then return nil end
return value
end
function client:GetKeyLink(loaderHash)
loaderHash=keyedFeatureHash(loaderHash)
if not loaderHash then return nil,"invalid_loader_hash" end
return keyedFeatureGatewayOrigin.."/getkey?project_id="..loaderHash
end
function client:RequireKey(loaderHash,key)
if not active then return false,"client_stopped" end
loaderHash=keyedFeatureHash(loaderHash)
if not loaderHash then return false,"invalid_loader_hash" end
local gateway=keyedFeatureGatewayOrigin.."/getkey?project_id="..loaderHash
if type(key)~="string" then return false,"key_required",gateway end
key=string.gsub(key,"^%s*(.-)%s*$","%1")
if #key<1 or #key>512 or string.find(key,"%c") then return false,"invalid_key",gateway end
if keyedFeatureBusy[loaderHash] then return false,"feature_loading",gateway end
keyedFeatureBusy[loaderHash]=true
local url=keyedFeatureOrigin.."/v1/loaders/"..loaderHash..".lua"
local source=nil
for attempt=1,2 do
local ok,value=pcall(game.HttpGet,game,url)
if ok and type(value)=="string" and #value>0 and #value<=262144 and not string.find(string.lower(value),"<html",1,true) then source=value break end
if attempt==1 and type(task)=="table" and type(task.wait)=="function" then task.wait(.15) end
end
url=nil
if not source then keyedFeatureBusy[loaderHash]=nil key=nil return false,"loader_download_failed",gateway end
local compiler=loadstring
if type(compiler)~="function" then keyedFeatureBusy[loaderHash]=nil source=nil key=nil return false,"loadstring_unavailable",gateway end
local feature,compileError=compiler(source,"=FlowAuthKeyedFeature")
source=nil
if not feature then keyedFeatureBusy[loaderHash]=nil key=nil return false,"loader_compile_failed: "..tostring(compileError),gateway end
local callOk,featureResult=xpcall(function()return feature(key)end,function(value)return tostring(value)end)
key=nil
feature=nil
keyedFeatureBusy[loaderHash]=nil
if not callOk then return false,featureResult,gateway end
return true,featureResult,gateway
end
function client:Stop()
active=false
if type(environment)=="table" and rawget(environment,"FlowAuth")==self then
pcall(rawset,environment,"FlowAuth",nil)
end
end
if type(environment)=="table" then pcall(rawset,environment,"FlowAuth",client) end
end
-- FlowAuth payload
--@flowauth:fa1_iWYt0mROvLXOYVB9hSP5QvNN
-- Eagle Hub X - Obsidian UI + Levi Skin Changer + Accuracy + Manual Spam
-- BÜTÜN XÜSUSİYYƏTLƏR BİRLƏŞDİRİLDİ (Avatar Changer SİLİNDİ)

repeat task.wait() until game:IsLoaded()

local function cleanup()
    for _,n in pairs({"EagleHubXGui","SpamCenter","EagleHubMini","EagleBallStats"}) do
        local o=game.CoreGui:FindFirstChild(n); if o then o:Destroy() end
    end
end
cleanup()

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local StatsService = game:GetService("Stats")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local Workspace = game:GetService("Workspace")

-- ========== GETGC REMOTE FINDER (YENİ VERSİYA) ==========
local replicated_storage = cloneref(game:GetService('ReplicatedStorage'))
local workspace_clone = cloneref(game:GetService('Workspace'))

local _token = nil
local _remote_data = nil

-- Token funksiyasını tap
for _, func in getgc(true) do
    if type(func) == 'function' then
        local info = debug.info(func, "s")
        if info and info:find('PRY', 1, true) then
            for _, upvalue in debug.getupvalues(func) do
                if type(upvalue) == 'function' then
                    _token = upvalue
                    break
                end
            end
            if _token then break end
        end
    end
end

function _tokenize(remote_uid)
    if not _token then return "" end
    local time = tostring(math.floor(workspace_clone:GetServerTimeNow() * 100))
    local key = _token(remote_uid, 'TIME')
    local characters = {}
    for i = 1, #time do
        local byte1 = string.byte(time, i)
        local byte2 = string.byte(key, (i - 1) % #key + 1)
        characters[i] = string.char(bit32.bxor((byte1 + i) % 256, byte2))
    end
    return table.concat(characters)
end

local remoteHooked = false
local remote = nil
local remote_args = nil

-- Remote hook et
for _, remote_obj in pairs(replicated_storage:GetDescendants()) do
    if remote_obj:IsA('RemoteEvent') or remote_obj:IsA('RemoteFunction') then
        local meta = getrawmetatable(remote_obj)
        if meta and not meta.__index_captured then
            setreadonly(meta, false)
            local old_index = meta.__index
            meta.__index_captured = true
            meta.__index = function(self, key)
                if (key == 'FireServer' and self:IsA('RemoteEvent')) or 
                   (key == 'InvokeServer' and self:IsA('RemoteFunction')) then
                    return function(_, ...)
                        local args = {...}
                        if #args == 8 and type(args[2]) == "string" and type(args[3]) == "string" and type(args[4]) == "number" then
                            if not remoteHooked then
                                remote = self
                                remote_args = args
                                remoteHooked = true
                                print("✅ Remote hooked!")
                            end
                        end
                        return old_index(self, key)(_, unpack(args))
                    end
                end
                return old_index(self, key)
            end
            setreadonly(meta, true)
        end
    end
end

-- ========== FIRE PARRY ==========
local function fireParry()
    if not remoteHooked or not remote or not remote_args then return end
    local cam = Workspace.CurrentCamera
    local char = LocalPlayer.Character
    if not char then return end
    
    local is_mobile = UserInputService.TouchEnabled and not UserInputService.MouseEnabled
    local aim_target
    if is_mobile then
        local vp = cam.ViewportSize
        aim_target = {vp.X/2, vp.Y/2}
    else
        local ok, mouse = pcall(function() return UserInputService:GetMouseLocation() end)
        aim_target = ok and {mouse.X, mouse.Y} or {0, 0}
    end
    
    local event_data = {}
    local Alive = Workspace:FindFirstChild("Alive")
    if Alive then
        for _, entity in pairs(Alive:GetChildren()) do
            if entity.PrimaryPart then
                local ok, sp = pcall(function() return cam:WorldToScreenPoint(entity.PrimaryPart.Position) end)
                if ok then event_data[entity.Name] = sp end
            end
        end
    end
    
    pcall(function()
        remote:FireServer(
            remote_args[1] or "",
            remote_args[2] or "",
            _tokenize(remote_args[2] or ""),
            0.5,
            cam.CFrame,
            event_data,
            aim_target,
            false
        )
    end)
end

-- ========== ACCURACY SYSTEM ==========
local accuracy = 50
local divisor_multiplier = 1.1
local randomized_accuracy_enabled = false

local function update_divisor()
    divisor_multiplier = 0.7 + (accuracy - 1) * (0.9/99)
end

local function update_randomized_accuracy()
    if not randomized_accuracy_enabled then return end
    local ping_str = StatsService.Network.ServerStatsItem["Data Ping"]:GetValueString()
    local ping = tonumber(ping_str:match("%d+")) or 0
    local new_accuracy
    if ping >= 90 then new_accuracy = 4
    elseif ping <= 50 then new_accuracy = math.random(70, 100)
    else new_accuracy = accuracy end
    if new_accuracy then accuracy = new_accuracy; update_divisor() end
end

task.spawn(function()
    while task.wait(1) do
        if randomized_accuracy_enabled then update_randomized_accuracy() end
    end
end)

-- ========== SYSTEM OBYEKTI ==========
System = {
    get_real_ball = function()
        local balls = Workspace:FindFirstChild("Balls")
        if not balls then return nil end
        for _, ball in pairs(balls:GetChildren()) do
            if ball:IsA("BasePart") and ball:GetAttribute("realBall") then
                return ball
            end
        end
        return nil
    end,
    
    get_all_balls = function()
        local balls = Workspace:FindFirstChild("Balls")
        if not balls then return {} end
        local result = {}
        for _, ball in pairs(balls:GetChildren()) do
            if ball:IsA("BasePart") and ball:GetAttribute("realBall") then
                table.insert(result, ball)
            end
        end
        return result
    end
}

-- ========== VARIABLES ==========
local AutoParry = false
local AnimFix = false
local AutoJump = false
local ManualSpam = false
local spamActive = false
local lastSpamTime = 0
local spamInterval = 1/200
local SpamKey = Enum.KeyCode.E
local waitingSpamKey = false
local parried_balls = {}
local billboardLabels = {}
local detections = {infinity=false, deathslash=false, timehole=false, slashesoffury=false, phantom=false}
local infinity_active = false
local deathslash_active = false
local timehole_active = false
local slashesoffury_active = false
local slashesoffury_count = 0
local maxParryCount = 36
local parryDelay = 0.05
local CurrentCurveMethod = "camera"
local ParryDist = 8
local LowGraphics = false
local ShowBallStats = false
local peakVel = 0
getgenv().AbilityESP = false

local function isInGame() return Workspace:FindFirstChild("Alive") ~= nil end
local Alive = Workspace:FindFirstChild("Alive")
local Runtime = Workspace:FindFirstChild("Runtime")

RunService.Heartbeat:Connect(function()
    if not Alive or not Alive.Parent then Alive = Workspace:FindFirstChild("Alive") end
    if not Runtime or not Runtime.Parent then Runtime = Workspace:FindFirstChild("Runtime") end
end)

-- ========== CURVE MODES ==========
local function getCurveCFrame()
    local camera = Workspace.CurrentCamera
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return camera.CFrame end
    
    local closestDot = -math.huge
    local targetPos = nil
    
    if Alive then
        for _, entity in pairs(Alive:GetChildren()) do
            if entity ~= char and entity:FindFirstChild("HumanoidRootPart") then
                local dir = (entity.HumanoidRootPart.Position - camera.CFrame.Position).Unit
                local dot = camera.CFrame.LookVector:Dot(dir)
                if dot > closestDot then
                    closestDot = dot
                    targetPos = entity.HumanoidRootPart.Position
                end
            end
        end
    end
    
    targetPos = targetPos or (root.Position + camera.CFrame.LookVector * 1000)
    local toTarget = (targetPos - root.Position).Unit
    
    if CurrentCurveMethod == "camera" then
        return camera.CFrame
    elseif CurrentCurveMethod == "dot" then
        return CFrame.lookAt(root.Position, targetPos + Vector3.new(0, 1.75, 0))
    elseif CurrentCurveMethod == "backwards" then
        return CFrame.new(root.Position, root.Position + (-toTarget) * 1000)
    elseif CurrentCurveMethod == "slow" then
        return CFrame.new(root.Position, root.Position + Vector3.new(0, -350, 0))
    elseif CurrentCurveMethod == "random" then
        local direction = (targetPos - root.Position).Unit
        local randomOffset
        local attempts = 0
        repeat
            randomOffset = Vector3.new(
                math.random(-4000, 4000),
                math.random(-4000, 4000),
                math.random(-4000, 4000)
            )
            local curveDir = (targetPos + randomOffset - root.Position).Unit
            local dot = direction:Dot(curveDir)
            attempts = attempts + 1
        until dot < 0.95 or attempts > 10
        return CFrame.new(root.Position, targetPos + randomOffset)
    elseif CurrentCurveMethod == "accelerated" then
        return CFrame.new(root.Position, targetPos + Vector3.new(0, 5, 0))
    elseif CurrentCurveMethod == "high" then
        return CFrame.new(root.Position, targetPos + Vector3.new(0, 9e18, 0))
    else
        return camera.CFrame
    end
end

-- ========== ANIMATION ==========
local SwordAPI = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("SwordAPI")
local lastplayedd = 0
local bypasscd = false
local AnimationDelay = 2
local AnimationCache = {}

local function GetCharacter() return LocalPlayer.Character end
local function GetHumanoid() 
    local char = GetCharacter() 
    return char and char:FindFirstChildOfClass("Humanoid") 
end

local function StopAnimation(track) 
    track:Stop(track:GetAttribute("StopFadeTime") or 0.1) 
end

local function PlayGrabAnimation(track) 
    track:Play(track:GetAttribute("PlayFadeTime") or 0, track:GetAttribute("PlayWeight") or 1, track:GetAttribute("PlaySpeed") or 1) 
end

local function GetParryAnimation()
    local char = GetCharacter()
    if not char then return nil end
    local cs = char:GetAttribute("CurrentlyEquippedSword")
    if not cs then return SwordAPI.Collection.Default:FindFirstChild("GrabParry") end
    if AnimationCache[cs] then return AnimationCache[cs] end
    local ok, sd = pcall(function() return ReplicatedStorage.Shared.ReplicatedInstances.Swords.GetSword:Invoke(cs) end)
    if not ok or type(sd) ~= "table" then 
        AnimationCache[cs] = SwordAPI.Collection.Default:FindFirstChild("GrabParry")
        return AnimationCache[cs] 
    end
    for _, obj in pairs(SwordAPI.Collection:GetChildren()) do 
        if obj.Name == sd.AnimationType then 
            local a = obj:FindFirstChild("GrabParry") or obj:FindFirstChild("Grab")
            if a then AnimationCache[cs] = a; return a end 
        end 
    end
    AnimationCache[cs] = SwordAPI.Collection.Default:FindFirstChild("GrabParry")
    return AnimationCache[cs]
end

local function PlayParry_Animation()
    local hum = GetHumanoid()
    if not hum then return end
    local anim = GetParryAnimation()
    if not anim then return end
    for _, track in pairs(hum.Animator:GetPlayingAnimationTracks()) do
        if track.Name == "GrabParry" or track.Name == "Grab" then
            track.TimePosition = 0
            StopAnimation(track)
        elseif track.Name == "SuccessParry" or track.Name == "Success" then
            StopAnimation(track)
        end
    end
    local g = hum.Animator:LoadAnimation(anim)
    PlayGrabAnimation(g)
end

local function SpamParry_Animation()
    if (os.clock() - lastplayedd) >= (AnimationDelay - 0.8) or bypasscd then
        lastplayedd = os.clock()
        bypasscd = false
        PlayParry_Animation()
    end
end

pcall(function()
    ReplicatedStorage.Remotes.ParrySuccess.OnClientEvent:Connect(function()
        bypasscd = true
        local hum = GetHumanoid()
        if hum then
            for _, t in pairs(hum.Animator:GetPlayingAnimationTracks()) do
                if t.Name == "GrabParry" or t.Name == "Grab" then StopAnimation(t) end
            end
        end
    end)
end)

-- ========== HEADLESS & KORBLOX ==========
local Byte_Library = {}

function Byte_Library.Korblox(char)
    if not char then return end
    local leg = char:FindFirstChild("Right Leg")
    if not leg then return end
    if not leg:FindFirstChild("KorbloxMesh") then
        for _, v in leg:GetChildren() do if v:IsA("SpecialMesh") then v:Destroy() end end
        local m = Instance.new("SpecialMesh")
        m.Name = "KorbloxMesh"
        m.MeshId = "rbxassetid://902942096"
        m.TextureId = "rbxassetid://902843398"
        m.Offset = Vector3.new(0, 0.7, 0)
        m.Parent = leg
    end
end

function Byte_Library.Restore_Leg(char)
    if not char then return end
    local leg = char:FindFirstChild("Right Leg")
    if not leg then return end
    for _, v in leg:GetChildren() do if v:IsA("SpecialMesh") then v:Destroy() end end
end

function Byte_Library.Headless(char)
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end
    head.Transparency = 1
    for _, child in head:GetChildren() do
        if child:IsA("Decal") or child.Name == "face" then
            child.Transparency = 1
        elseif child:IsA("SpecialMesh") or child:IsA("DataModelMesh") then
            if not child:GetAttribute("OriginalScale") then
                child:SetAttribute("OriginalScale", child.Scale)
                child.Scale = Vector3.new(0, 0, 0)
            end
        end
    end
end

function Byte_Library.Restore_Head(char)
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end
    head.Transparency = 0
    for _, child in head:GetChildren() do
        if child:IsA("Decal") or child.Name == "face" then
            child.Transparency = 0
        elseif child:IsA("SpecialMesh") or child:IsA("DataModelMesh") then
            local orig = child:GetAttribute("OriginalScale")
            if orig then child.Scale = orig; child:SetAttribute("OriginalScale", nil) end
        end
    end
end

local headlessKorblox_conn = nil

LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    if getgenv().HeadlessKorbloxEnabled then
        Byte_Library.Headless(char)
        Byte_Library.Korblox(char)
    end
    if LowGraphics then pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Level01 end) end
end)

-- ========== ABILITY ESP ==========
local function createBillboardGui(p)
    task.spawn(function()
        local character = p.Character
        while not character or not character.Parent do
            task.wait()
            character = p.Character
        end
        local head = character:WaitForChild("Head", 10)
        if not head then return end
        local bg = Instance.new("BillboardGui")
        bg.Name = "AbilityESP_Gui"
        bg.Adornee = head
        bg.Size = UDim2.new(0, 220, 0, 60)
        bg.StudsOffset = Vector3.new(0, 3.5, 0)
        bg.AlwaysOnTop = true
        bg.Parent = head
        local tl = Instance.new("TextLabel")
        tl.Size = UDim2.new(1, 0, 1, 0)
        tl.TextColor3 = Color3.new(1, 1, 1)
        tl.TextSize = 14
        tl.TextStrokeTransparency = 0
        tl.Font = Enum.Font.GothamBold
        tl.BackgroundTransparency = 1
        tl.Parent = bg
        tl.Visible = false
        billboardLabels[p] = tl
        local hum = character:FindFirstChild("Humanoid")
        if hum then hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None end
        local conn
        conn = RunService.Heartbeat:Connect(function()
            if not (character and character.Parent) then
                conn:Disconnect()
                pcall(function() bg:Destroy() end)
                billboardLabels[p] = nil
                return
            end
            tl.Visible = getgenv().AbilityESP
            if getgenv().AbilityESP then
                local ab = p:GetAttribute("EquippedAbility")
                tl.Text = ab and (p.DisplayName .. " [" .. ab .. "]") or p.DisplayName
            end
        end)
    end)
end

for _, p in pairs(Players:GetPlayers()) do
    if p ~= LocalPlayer then
        p.CharacterAdded:Connect(function() createBillboardGui(p) end)
        if p.Character then createBillboardGui(p) end
    end
end

Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function() createBillboardGui(p) end)
end)

-- ========== LOW GRAPHICS ==========
local origQuality = nil

local function setLowGraphics(v)
    LowGraphics = v
    if v then
        pcall(function()
            origQuality = settings().Rendering.QualityLevel
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        end)
        pcall(function()
            game:GetService("Lighting").GlobalShadows = false
            game:GetService("Lighting").FogEnd = 9e9
        end)
    else
        pcall(function()
            if origQuality then settings().Rendering.QualityLevel = origQuality end
        end)
        pcall(function()
            game:GetService("Lighting").GlobalShadows = true
        end)
    end
end

-- ========== LEVI STYLE SKIN CHANGER (EGH-dan TAM) ==========
local SKIN_LAST_EQUIPPED_CONFIG_KEY = "Skin.LastEquippedSword"
local EXPLOSION_LAST_EQUIPPED_CONFIG_KEY = "Skin.LastEquippedExplosion"
local AUTO_CONFIG_FILE = "LeviHubX/auto_config.json"

local function readLeviHubAutoConfig()
    local data = {}
    pcall(function()
        if isfile and isfile(AUTO_CONFIG_FILE) then
            local decoded = HttpService:JSONDecode(readfile(AUTO_CONFIG_FILE))
            if type(decoded) == "table" then
                data = decoded
            end
        end
    end)
    return data
end

local function writeLeviHubAutoConfig(data)
    pcall(function()
        if isfolder and makefolder and not isfolder("LeviHubX") then
            makefolder("LeviHubX")
        end
        if writefile then
            writefile(AUTO_CONFIG_FILE, HttpService:JSONEncode(data or {}))
        end
    end)
end

local function loadLastEquippedSword()
    local data = readLeviHubAutoConfig()
    local saved = data[SKIN_LAST_EQUIPPED_CONFIG_KEY]
    return type(saved) == "string" and saved or ""
end

local function loadLastEquippedExplosion()
    local data = readLeviHubAutoConfig()
    local saved = data[EXPLOSION_LAST_EQUIPPED_CONFIG_KEY]
    return type(saved) == "string" and saved or ""
end

getgenv().saveLastEquippedSword = function(swordName)
    if type(swordName) ~= "string" or swordName == "" then return end
    local data = readLeviHubAutoConfig()
    data[SKIN_LAST_EQUIPPED_CONFIG_KEY] = swordName
    writeLeviHubAutoConfig(data)
end

getgenv().saveLastEquippedExplosion = function(explosionName)
    if type(explosionName) ~= "string" or explosionName == "" then return end
    local data = readLeviHubAutoConfig()
    data[EXPLOSION_LAST_EQUIPPED_CONFIG_KEY] = explosionName
    writeLeviHubAutoConfig(data)
end

task.spawn(function()
    pcall(function()
        local oi = getthreadidentity and getthreadidentity() or 2
        if setthreadidentity then setthreadidentity(2) end
        
        local swordInstancesInstance = ReplicatedStorage:WaitForChild("Shared", 9e9):WaitForChild("ReplicatedInstances", 9e9):WaitForChild("Swords", 9e9)
        local si = require(swordInstancesInstance)
        
        if setthreadidentity then setthreadidentity(oi) end
        
        local sc
        while task.wait() and not sc do
            for _, v in pairs(getconnections(ReplicatedStorage.Remotes.FireSwordInfo.OnClientEvent)) do
                if v.Function and islclosure(v.Function) then
                    local up = getupvalues(v.Function)
                    if #up == 1 and type(up[1]) == "table" then
                        sc = up[1]
                        break
                    end
                end
            end
        end
        
        local function getSlashName(sn)
            local i2 = getthreadidentity and getthreadidentity() or 2
            if setthreadidentity then setthreadidentity(2) end
            local sln
            pcall(function() sln = si:GetSword(sn) end)
            if setthreadidentity then setthreadidentity(i2) end
            return (sln and sln.SlashName) or "SlashEffect"
        end
        
        local function setSword()
            if not getgenv().skinChangerEnabled then return end
            local char = LocalPlayer.Character
            local aF = Workspace:FindFirstChild("Alive")
            if not char or not aF or char.Parent ~= aF then return end
            if not char:FindFirstChild("Humanoid") or char.Humanoid.Health <= 0 then return end
            
            local i2 = getthreadidentity and getthreadidentity() or 2
            if setthreadidentity then setthreadidentity(2) end
            
            pcall(function()
                setupvalue(rawget(si, "EquipSwordTo"), 3, false)
                if getgenv().changeSwordModel and getgenv().swordModel and getgenv().swordModel ~= "" then
                    si:EquipSwordTo(char, getgenv().swordModel)
                end
                if getgenv().changeSwordAnimation and getgenv().swordAnimations and getgenv().swordAnimations ~= "" then
                    sc:SetSword(getgenv().swordAnimations)
                end
            end)
            
            if setthreadidentity then setthreadidentity(i2) end
        end
        
        local ppf
        while not ppf do
            for _, v in pairs(getconnections(ReplicatedStorage.Remotes.ParrySuccessAll.OnClientEvent)) do
                if v.Function and getinfo(v.Function).name == "parrySuccessAll" then
                    ppf = v.Function
                    v:Disable()
                    break
                end
            end
            if not ppf then task.wait() end
        end
        
        getgenv().slashName = getSlashName(getgenv().swordFX or "")
        
        ReplicatedStorage.Remotes.ParrySuccessAll.OnClientEvent:Connect(function(...)
            setthreadidentity(2)
            local args = {...}
            if tostring(args[4]) == LocalPlayer.Name then
                if getgenv().skinChangerEnabled and getgenv().changeSwordFX and getgenv().swordFX and getgenv().swordFX ~= "" then
                    args[1] = getgenv().slashName
                    args[3] = getgenv().swordFX
                end
            end
            return ppf(unpack(args))
        end)
        
        getgenv().updateSword = function()
            if getgenv().changeSwordFX and getgenv().swordFX and getgenv().swordFX ~= "" then
                getgenv().slashName = getSlashName(getgenv().swordFX)
            end
            setSword()
        end
        
        while task.wait(0.1) do
            if getgenv().skinChangerEnabled and getgenv().changeSwordModel and getgenv().swordModel and getgenv().swordModel ~= "" then
                local char = LocalPlayer.Character
                local aF = Workspace:FindFirstChild("Alive")
                if char and aF and char.Parent == aF and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
                    local cur = LocalPlayer:GetAttribute("CurrentlyEquippedSword")
                    if cur and cur ~= getgenv().swordModel and cur ~= char:GetAttribute("LastOverwrittenSword") then
                        char:SetAttribute("LastOverwrittenSword", cur)
                        setSword()
                    elseif not char:FindFirstChild(getgenv().swordModel) then
                        setSword()
                    end
                    for _, v in pairs(char:GetChildren()) do
                        if v:IsA("Model") and v.Name ~= getgenv().swordModel and v:FindFirstChild("Handle") then
                            v:Destroy()
                        end
                    end
                end
            end
        end
    end)
end)

-- ========== MANUAL SPAM UI ==========
local SpamGui = Instance.new("ScreenGui", CoreGui)
SpamGui.Name = "SpamCenter"
SpamGui.ResetOnSpawn = false
SpamGui.IgnoreGuiInset = true
SpamGui.DisplayOrder = 9

local SpamBtn = Instance.new("TextButton", SpamGui)
SpamBtn.Size = UDim2.new(0, 130, 0, 44)
SpamBtn.Position = UDim2.new(1, -148, 0.5, -22)
SpamBtn.BackgroundColor3 = Color3.fromRGB(14, 14, 14)
SpamBtn.Text = "SPAM"
SpamBtn.Font = Enum.Font.GothamBold
SpamBtn.TextSize = 13
SpamBtn.TextColor3 = Color3.fromRGB(120, 120, 120)
SpamBtn.BorderSizePixel = 0
SpamBtn.Draggable = true
SpamBtn.Visible = false
Instance.new("UICorner", SpamBtn).CornerRadius = UDim.new(0, 8)
local SpamStroke = Instance.new("UIStroke", SpamBtn)
SpamStroke.Color = Color3.fromRGB(60, 60, 60)
SpamStroke.Thickness = 1.5

local function setSpamActive(v)
    if not ManualSpam then v = false end
    spamActive = v
    if v then
        SpamBtn.Text = "ON"
        SpamBtn.TextColor3 = Color3.fromRGB(255, 140, 0)
        TweenService:Create(SpamBtn, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(28, 14, 0)}):Play()
        TweenService:Create(SpamStroke, TweenInfo.new(0.12), {Color = Color3.fromRGB(255, 140, 0)}):Play()
    else
        SpamBtn.Text = "SPAM"
        SpamBtn.TextColor3 = Color3.fromRGB(120, 120, 120)
        TweenService:Create(SpamBtn, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(14, 14, 14)}):Play()
        TweenService:Create(SpamStroke, TweenInfo.new(0.12), {Color = Color3.fromRGB(60, 60, 60)}):Play()
    end
end

local ts2 = 0
local wd2 = false

SpamBtn.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.Touch or inp.UserInputType == Enum.UserInputType.MouseButton1 then
        ts2 = tick()
        wd2 = false
    end
end)

SpamBtn.InputChanged:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.Touch or inp.UserInputType == Enum.UserInputType.MouseMovement then
        if tick() - ts2 > 0.12 then wd2 = true end
    end
end)

SpamBtn.InputEnded:Connect(function(inp)
    if (inp.UserInputType == Enum.UserInputType.Touch or inp.UserInputType == Enum.UserInputType.MouseButton1) and not wd2 then
        if not isInGame() or not ManualSpam then return end
        setSpamActive(not spamActive)
    end
end)

UserInputService.InputBegan:Connect(function(inp, gp)
    if gp or waitingSpamKey then return end
    if inp.KeyCode == SpamKey and ManualSpam then
        if not isInGame() then return end
        setSpamActive(not spamActive)
    end
end)

-- ========== OBSIDIAN UI ==========
local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()
local Options = Library.Options

local Window = Library:CreateWindow({
    Title = "Eagle Hub X",
    Footer = "Free version",
    Icon = 135334786148169,
    NotifySide = "Right",
    ShowCustomCursor = true,
    AutoShow = true,
})

local function N(t, m) Library:Notify({Title = t, Description = m, Time = 3}) end

local Tabs = {
    Combat = Window:AddTab("Combat", "sword"),
    Detect = Window:AddTab("Detection", "shield"),
    Visuals = Window:AddTab("Visuals", "eye"),
    Player = Window:AddTab("Player", "user"),
    Skin = Window:AddTab("Skin Changer", "skull"),
    Settings = Window:AddTab("Settings", "settings"),
}

-- ═══ COMBAT TAB ═══
local CL = Tabs.Combat:AddLeftGroupbox("Auto Parry")
local CR = Tabs.Combat:AddRightGroupbox("Manual Spam")

CL:AddToggle("AutoParry", {
    Text = "Auto Parry",
    Default = false,
    Callback = function(v)
        AutoParry = v
        table.clear(parried_balls)
        N("Auto Parry", v and "ON" or "OFF")
    end
})

CL:AddToggle("AnimFix", {
    Text = "Animation Fix",
    Default = false,
    Callback = function(v) AnimFix = v end
})

CL:AddDivider()

CL:AddDropdown("CurveMethod", {
    Values = {"camera", "dot", "backwards", "slow", "random", "accelerated", "high"},
    Default = "camera",
    Text = "Curve Method",
    Callback = function(v) CurrentCurveMethod = v end
})

-- ═══ ACCURACY SECTION ═══
CL:AddDivider()
CL:AddLabel("Parry Accuracy")

CL:AddSlider("Accuracy", {
    Text = "Accuracy",
    Default = 50,
    Min = 1,
    Max = 100,
    Rounding = 1,
    Callback = function(v)
        accuracy = v
        update_divisor()
        N("Accuracy", v .. "%")
    end
})

CL:AddToggle("RandomizeAccuracy", {
    Text = "Randomize Accuracy",
    Default = false,
    Callback = function(v)
        randomized_accuracy_enabled = v
        if v then update_randomized_accuracy() end
        N("Randomize Accuracy", v and "ON" or "OFF")
    end
})

-- MANUAL SPAM
CR:AddToggle("ManualSpamToggle", {
    Text = "Manual Spam",
    Default = false,
    Callback = function(v)
        ManualSpam = v
        SpamBtn.Visible = v
        if not v then setSpamActive(false) end
        N("Manual Spam", v and "ON" or "OFF")
    end
})

CR:AddSlider("SpamCPS", {
    Text = "CPS",
    Default = 200,
    Min = 1,
    Max = 400,
    Rounding = 0,
    Callback = function(v) spamInterval = 1 / v end
})

local spamKeyRow = CR:AddLabel("Spam Key: E")
CR:AddButton({
    Text = "Set Spam Key",
    Func = function()
        if waitingSpamKey then return end
        waitingSpamKey = true
        spamKeyRow:SetText("Spam Key: [...]")
        N("Spam Key", "Waiting for key...")
        local conn
        conn = UserInputService.InputBegan:Connect(function(inp, gp)
            if gp then return end
            if inp.UserInputType == Enum.UserInputType.Keyboard then
                SpamKey = inp.KeyCode
                spamKeyRow:SetText("Spam Key: [" .. inp.KeyCode.Name .. "]")
                N("Spam Key", "Set: " .. inp.KeyCode.Name)
                waitingSpamKey = false
                conn:Disconnect()
            end
        end)
    end
})

CR:AddToggle("AutoJump", {
    Text = "Auto Jump",
    Default = false,
    Callback = function(v)
        AutoJump = v
        N("Auto Jump", v and "ON" or "OFF")
    end
})

CR:AddButton({
    Text = "Remote Status",
    Func = function()
        N("Remote", remoteHooked and "✅ Hooked!" or "❌ Not Found!")
    end
})

-- ═══ DETECTION TAB ═══
local DL = Tabs.Detect:AddLeftGroupbox("Detections")
local DR = Tabs.Detect:AddRightGroupbox("Slashes of Fury")

DL:AddToggle("DetInfinity", {
    Text = "Infinity",
    Default = false,
    Callback = function(v)
        detections.infinity = v
        N("Infinity", v and "ON" or "OFF")
    end
})

DL:AddToggle("DetDeathSlash", {
    Text = "Death Slash",
    Default = false,
    Callback = function(v)
        detections.deathslash = v
        N("Death Slash", v and "ON" or "OFF")
    end
})

DL:AddToggle("DetTimeHole", {
    Text = "Time Hole",
    Default = false,
    Callback = function(v)
        detections.timehole = v
        N("Time Hole", v and "ON" or "OFF")
    end
})

DL:AddToggle("DetPhantom", {
    Text = "Anti-Phantom",
    Default = false,
    Callback = function(v)
        detections.phantom = v
        N("Anti-Phantom", v and "ON" or "OFF")
    end
})

DR:AddToggle("DetSoF", {
    Text = "Slashes of Fury",
    Default = false,
    Callback = function(v)
        detections.slashesoffury = v
        N("SoF", v and "ON" or "OFF")
    end
})

DR:AddSlider("SofDelay", {
    Text = "Parry Delay (ms)",
    Default = 5,
    Min = 5,
    Max = 25,
    Rounding = 0,
    Callback = function(v) parryDelay = v / 100 end
})

DR:AddSlider("SofMax", {
    Text = "Max Parry Count",
    Default = 36,
    Min = 1,
    Max = 36,
    Rounding = 0,
    Callback = function(v) maxParryCount = v end
})

-- ═══ VISUALS TAB ═══
local VL = Tabs.Visuals:AddLeftGroupbox("Display")
local VR = Tabs.Visuals:AddRightGroupbox("Effects")

VL:AddToggle("BallStats", {
    Text = "Ball Stats",
    Default = false,
    Callback = function(v)
        ShowBallStats = v
        if not v then peakVel = 0 end
        N("Ball Stats", v and "ON" or "OFF")
    end
})

VL:AddToggle("AbilityESP", {
    Text = "Ability ESP",
    Default = false,
    Callback = function(v)
        getgenv().AbilityESP = v
        for _, l in pairs(billboardLabels) do
            if l then l.Visible = v end
        end
        N("Ability ESP", v and "ON" or "OFF")
    end
})

VL:AddToggle("HeadlessKorblox", {
    Text = "Headless & Korblox",
    Default = false,
    Callback = function(v)
        getgenv().HeadlessKorbloxEnabled = v
        local char = LocalPlayer.Character
        if char then
            if v then
                Byte_Library.Headless(char)
                Byte_Library.Korblox(char)
            else
                Byte_Library.Restore_Head(char)
                Byte_Library.Restore_Leg(char)
            end
        end
        if v then
            if not headlessKorblox_conn then
                headlessKorblox_conn = LocalPlayer.CharacterAdded:Connect(function(char)
                    task.wait(0.5)
                    if getgenv().HeadlessKorbloxEnabled then
                        Byte_Library.Headless(char)
                        Byte_Library.Korblox(char)
                    end
                end)
            end
        else
            if headlessKorblox_conn then
                headlessKorblox_conn:Disconnect()
                headlessKorblox_conn = nil
            end
        end
        N("Headless & Korblox", v and "ON" or "OFF")
    end
})

VL:AddToggle("LowGraphics", {
    Text = "Low Graphics",
    Default = false,
    Callback = function(v)
        setLowGraphics(v)
        N("Low Graphics", v and "ON" or "OFF")
    end
})

VR:AddToggle("FOVEnabled", {
    Text = "FOV Changer",
    Default = false,
    Callback = function(v)
        getgenv().CameraEnabled = v
        local Cam = Workspace.CurrentCamera
        if v then
            getgenv().CameraFOV = getgenv().CameraFOV or 70
            Cam.FieldOfView = getgenv().CameraFOV
            if not getgenv().FOVLoop then
                getgenv().FOVLoop = RunService.RenderStepped:Connect(function()
                    if getgenv().CameraEnabled then
                        Cam.FieldOfView = getgenv().CameraFOV
                    end
                end)
            end
        else
            Cam.FieldOfView = 70
            if getgenv().FOVLoop then
                getgenv().FOVLoop:Disconnect()
                getgenv().FOVLoop = nil
            end
        end
    end
})

VR:AddSlider("CameraFOV", {
    Text = "FOV",
    Default = 70,
    Min = 50,
    Max = 120,
    Rounding = 1,
    Callback = function(v)
        getgenv().CameraFOV = v
        if getgenv().CameraEnabled then
            Workspace.CurrentCamera.FieldOfView = v
        end
    end
})

-- ═══ PLAYER TAB ═══
local PL = Tabs.Player:AddLeftGroupbox("Movement")

PL:AddToggle("FlyToggle", {
    Text = "Fly",
    Default = false,
    Callback = function(v)
        getgenv().FlyEnabled = v
        if v then
            local char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum.PlatformStand = true end
            if getgenv().FlyBV then getgenv().FlyBV:Destroy() end
            getgenv().FlyBV = Instance.new("BodyVelocity")
            getgenv().FlyBV.Velocity = Vector3.zero
            getgenv().FlyBV.MaxForce = Vector3.new(1e5, 1e5, 1e5)
            getgenv().FlyBV.Parent = hrp
            if getgenv().FlyConn then getgenv().FlyConn:Disconnect() end
            getgenv().FlyConn = RunService.RenderStepped:Connect(function()
                if not getgenv().FlyEnabled then return end
                local c2 = LocalPlayer.Character
                local r2 = c2 and c2:FindFirstChild("HumanoidRootPart")
                if not r2 then return end
                local cam = Workspace.CurrentCamera
                local md = Vector3.zero
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then md = md + cam.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then md = md - cam.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then md = md - cam.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then md = md + cam.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then md = md + Vector3.new(0, 1, 0) end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then md = md - Vector3.new(0, 1, 0) end
                if getgenv().FlyBV and getgenv().FlyBV.Parent then
                    getgenv().FlyBV.Velocity = md.Magnitude > 0 and md.Unit * (getgenv().FlySpeed or 50) or Vector3.zero
                end
            end)
        else
            if getgenv().FlyConn then
                getgenv().FlyConn:Disconnect()
                getgenv().FlyConn = nil
            end
            if getgenv().FlyBV then
                getgenv().FlyBV:Destroy()
                getgenv().FlyBV = nil
            end
            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum then hum.PlatformStand = false end
        end
        N("Fly", v and "ON" or "OFF")
    end
})

PL:AddSlider("FlySpeed", {
    Text = "Fly Speed",
    Default = 50,
    Min = 10,
    Max = 300,
    Rounding = 0,
    Callback = function(v) getgenv().FlySpeed = v end
})

PL:AddDivider()

PL:AddToggle("SpeedHack", {
    Text = "Speed Custom",
    Default = false,
    Callback = function(v)
        getgenv().SpeedEnabled = v
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = v and (getgenv().SpeedVal or 30) or 16 end
        N("Speed", v and "ON" or "OFF")
    end
})

PL:AddSlider("SpeedVal", {
    Text = "Walk Speed",
    Default = 30,
    Min = 16,
    Max = 150,
    Rounding = 0,
    Callback = function(v)
        getgenv().SpeedVal = v
        if getgenv().SpeedEnabled then
            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = v end
        end
    end
})

PL:AddDivider()

PL:AddToggle("HighJump", {
    Text = "High Jump",
    Default = false,
    Callback = function(v)
        getgenv().HJEnabled = v
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then
            pcall(function() hum.JumpHeight = v and (getgenv().HJVal or 120) or 7.2 end)
            pcall(function() hum.JumpPower = v and (getgenv().HJVal or 120) or 50 end)
        end
        N("High Jump", v and "ON" or "OFF")
    end
})

PL:AddSlider("HJVal", {
    Text = "Jump Height",
    Default = 120,
    Min = 8,
    Max = 500,
    Rounding = 0,
    Callback = function(v)
        getgenv().HJVal = v
        if getgenv().HJEnabled then
            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum then
                pcall(function() hum.JumpHeight = v end)
                pcall(function() hum.JumpPower = v end)
            end
        end
    end
})

-- ═══ SKIN TAB ═══
local SL = Tabs.Skin:AddLeftGroupbox("Skin Changer")

SL:AddToggle("SkinChanger", {
    Text = "Skin Changer",
    Default = false,
    Callback = function(v)
        getgenv().skinChangerEnabled = v
        getgenv().changeSwordModel = v
        getgenv().changeSwordAnimation = v
        getgenv().changeSwordFX = v
        if getgenv().updateSword then getgenv().updateSword() end
        N("Skin Changer", v and "ON" or "OFF")
    end
})

SL:AddInput("SwordName", {
    Default = "",
    Numeric = false,
    Finished = true,
    Text = "Sword Name",
    Placeholder = "Sword Name",
    Callback = function(v)
        getgenv().swordModel = v
        getgenv().swordAnimations = v
        getgenv().swordFX = v
        if getgenv().updateSword then getgenv().updateSword() end
        if getgenv().saveLastEquippedSword then
            pcall(getgenv().saveLastEquippedSword, v)
        end
    end
})

SL:AddToggle("SaveLastSword", {
    Text = "Save Last Sword",
    Default = true,
    Callback = function(v)
        getgenv().autoLoadLastSword = v
        if v and getgenv().swordModel and getgenv().swordModel ~= "" then
            if getgenv().saveLastEquippedSword then
                pcall(getgenv().saveLastEquippedSword, getgenv().swordModel)
            end
        end
    end
})

-- ═══ SETTINGS TAB ═══
local UG = Tabs.Settings:AddLeftGroupbox("Menu", "wrench")

UG:AddToggle("ShowCustomCursor", {
    Text = "Custom Cursor",
    Default = true,
    Callback = function(v) Library.ShowCustomCursor = v end
})

UG:AddDivider()
UG:AddLabel("Menu Keybind"):AddKeyPicker("MenuKeybind", {
    Default = "RightShift",
    NoUI = true,
    Text = "Menu keybind"
})

UG:AddButton("Unload", function() Library:Unload() end)

Library.ToggleKeybind = Options.MenuKeybind

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({"MenuKeybind"})
ThemeManager:SetFolder("EagleHubX")
SaveManager:SetFolder("EagleHubX/settings")
SaveManager:BuildConfigSection(Tabs.Settings)
ThemeManager:ApplyToTab(Tabs.Settings)
SaveManager:LoadAutoloadConfig()

-- ========== BALL STATS GUI ==========
local StatsGui = Instance.new("ScreenGui", CoreGui)
StatsGui.Name = "EagleBallStats"
StatsGui.ResetOnSpawn = false
StatsGui.IgnoreGuiInset = true

local StatsFrame = Instance.new("Frame", StatsGui)
StatsFrame.Size = UDim2.new(0, 175, 0, 110)
StatsFrame.Position = UDim2.new(0, 20, 0.5, -55)
StatsFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
StatsFrame.BorderSizePixel = 0
StatsFrame.Visible = false
Instance.new("UICorner", StatsFrame).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", StatsFrame).Color = Color3.fromRGB(255, 140, 0)

local STitle = Instance.new("TextLabel", StatsFrame)
STitle.Size = UDim2.new(1, 0, 0, 28)
STitle.Text = " BALL STATS"
STitle.TextColor3 = Color3.fromRGB(255, 140, 0)
STitle.BackgroundTransparency = 1
STitle.Font = Enum.Font.GothamBold
STitle.TextSize = 13
STitle.TextXAlignment = Enum.TextXAlignment.Left

local VLog = Instance.new("TextLabel", StatsFrame)
VLog.Position = UDim2.new(0.08, 0, 0.38, 0)
VLog.Size = UDim2.new(0.8, 0, 0, 26)
VLog.Text = "0.0"
VLog.TextColor3 = Color3.new(1, 1, 1)
VLog.BackgroundTransparency = 1
VLog.Font = Enum.Font.GothamBold
VLog.TextSize = 24
VLog.TextXAlignment = Enum.TextXAlignment.Left

local VLabel = Instance.new("TextLabel", StatsFrame)
VLabel.Position = UDim2.new(0.08, 0, 0.27, 0)
VLabel.Size = UDim2.new(0.8, 0, 0, 14)
VLabel.Text = "Current"
VLabel.TextColor3 = Color3.fromRGB(130, 130, 130)
VLabel.BackgroundTransparency = 1
VLabel.Font = Enum.Font.Gotham
VLabel.TextSize = 10
VLabel.TextXAlignment = Enum.TextXAlignment.Left

local PLog = Instance.new("TextLabel", StatsFrame)
PLog.Position = UDim2.new(0.08, 0, 0.76, 0)
PLog.Size = UDim2.new(0.8, 0, 0, 18)
PLog.Text = "0.0"
PLog.TextColor3 = Color3.fromRGB(50, 220, 80)
PLog.BackgroundTransparency = 1
PLog.Font = Enum.Font.GothamBold
PLog.TextSize = 14
PLog.TextXAlignment = Enum.TextXAlignment.Left

local PLabel = Instance.new("TextLabel", StatsFrame)
PLabel.Position = UDim2.new(0.08, 0, 0.67, 0)
PLabel.Size = UDim2.new(0.8, 0, 0, 12)
PLabel.Text = "Peak"
PLabel.TextColor3 = Color3.fromRGB(130, 130, 130)
PLabel.BackgroundTransparency = 1
PLabel.Font = Enum.Font.Gotham
PLabel.TextSize = 10
PLabel.TextXAlignment = Enum.TextXAlignment.Left

Library.Toggles["BallStats"]:OnChanged(function()
    local v = Library.Toggles["BallStats"].Value
    ShowBallStats = v
    StatsFrame.Visible = v
    if not v then peakVel = 0; VLog.Text = "0.0"; PLog.Text = "0.0" end
end)

-- ========== NOTIFICATIONS ==========
task.spawn(function()
    while not remoteHooked do
        task.wait(0.1)
    end
    N("Eagle Hub X", "Remote hooked!")
end)

N("Eagle Hub X", "Loaded | RightShift = Toggle UI")

-- ========== MAIN HEARTBEAT ==========
local lastBallCheck = 0
local cachedBall = nil
local lastHrpCache = 0
local cachedHrp = nil
local frameCount = 0
local ajLastOnGround = false

RunService.Heartbeat:Connect(function()
    local now = tick()
    frameCount = frameCount + 1
    
    if now - lastHrpCache > 0.15 then
        local ch = LocalPlayer.Character
        cachedHrp = ch and ch:FindFirstChild("HumanoidRootPart")
        lastHrpCache = now
    end
    local hrp = cachedHrp
    if not hrp then return end
    
    if now - lastBallCheck > 0.08 then
        cachedBall = nil
        local bc = Workspace:FindFirstChild("Balls")
        if bc then
            for _, b in pairs(bc:GetChildren()) do
                if b:IsA("BasePart") and b:GetAttribute("realBall") then
                    cachedBall = b
                    break
                end
            end
        end
        lastBallCheck = now
    end
    
    local ball = cachedBall
    local inGame = isInGame()
    
    -- AUTO JUMP
    if AutoJump then
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then
            local onGround = hum.FloorMaterial ~= Enum.Material.Air
            if onGround and not ajLastOnGround then
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
            end
            ajLastOnGround = onGround
        end
    else
        ajLastOnGround = false
    end
    
    -- Speed maintain
    if getgenv().SpeedEnabled then
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum and hum.WalkSpeed ~= (getgenv().SpeedVal or 30) then
            hum.WalkSpeed = getgenv().SpeedVal or 30
        end
    end
    
    -- High Jump maintain
    if getgenv().HJEnabled then
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then
            pcall(function()
                if hum.JumpHeight ~= (getgenv().HJVal or 120) then
                    hum.JumpHeight = getgenv().HJVal or 120
                end
            end)
            pcall(function()
                if hum.JumpPower ~= (getgenv().HJVal or 120) then
                    hum.JumpPower = getgenv().HJVal or 120
                end
            end)
        end
    end
    
    if ball and ball:IsA("BasePart") then
        local vel = ball.Velocity.Magnitude
        
        if ShowBallStats and frameCount % 3 == 0 then
            VLog.Text = string.format("%.1f", vel)
            if vel > peakVel then
                peakVel = vel
                PLog.Text = string.format("%.1f", peakVel)
            end
        end
        
        local Ping = 0.08
        pcall(function()
            Ping = StatsService.Network.ServerStatsItem["Data Ping"]:GetValue() / 1000
        end)
        
        local target = ball:GetAttribute("target") or ball:GetAttribute("Target") or ball:GetAttribute("targetPlayer") or ball:GetAttribute("TargetPlayer")
        local isMyBall = (target == LocalPlayer.Name) or (target == LocalPlayer.UserId) or (target == tostring(LocalPlayer.UserId))
        local speed = vel
        local dist = (hrp.Position - ball.Position).Magnitude
        
        -- AUTO PARRY
        if AutoParry and remoteHooked and isMyBall then
            local blocked = (detections.infinity and infinity_active) or
                            (detections.deathslash and deathslash_active) or
                            (detections.timehole and timehole_active)
            if not blocked then
                local bID = ball:GetDebugId()
                if not parried_balls[bID] then
                    local shouldParry = false
                    local Zoomies = ball:FindFirstChild("zoomies")
                    if Zoomies then
                        local Vel = Zoomies.VectorVelocity
                        local Dir = (hrp.Position - ball.Position).Unit
                        local Dot = Dir:Dot(Vel.Unit)
                        
                        local ping_factor = Ping * 0.3
                        local dot_threshold = 0.15 - ping_factor
                        
                        if Dot >= dot_threshold then
                            local accuracy_factor = accuracy / 100
                            local speed_factor = speed * (Ping + 0.016) * 3
                            local dist_threshold = (speed_factor * accuracy_factor) + (ParryDist * (1 - accuracy_factor * 0.5))
                            
                            if dist <= dist_threshold or dist <= ParryDist then
                                shouldParry = true
                            end
                        end
                    else
                        if dist <= ParryDist and speed > 0.5 then
                            shouldParry = true
                        end
                    end
                    if shouldParry then
                        fireParry()
                        parried_balls[bID] = true
                        task.spawn(function()
                            ball:GetAttributeChangedSignal("target"):Wait()
                            parried_balls[bID] = nil
                        end)
                    end
                end
            end
        end
    else
        if ShowBallStats and frameCount % 3 == 0 then
            VLog.Text = "0.0"
        end
    end
    
    -- MANUAL SPAM
    if ManualSpam and spamActive and remoteHooked and inGame then
        if now - lastSpamTime >= spamInterval then
            lastSpamTime = now
            fireParry()
            if AnimFix then task.spawn(SpamParry_Animation) end
        end
    end
    if not inGame and spamActive then
        setSpamActive(false)
    end
end)

print("Eagle Hub X loaded!")
