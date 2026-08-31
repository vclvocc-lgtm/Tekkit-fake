if game:IsLoaded() then
    print("Continuing");
else
    game.Loaded:Wait();
end;

while task.wait(1) do
    if not pcall(function() 
        return game.Players.LocalPlayer.Character.Main.W;
    end) then
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Not in mission", 
            Text = "Player not found, join a mission."
        });
    else
        wait(0.2);
        break;
    end;
end;

while task.wait(1) do
    if not pcall(function() 
        return game.Workspace.Titans:FindFirstChildOfClass("Model").Fake.Head.Header;
    end) then
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Not in mission", 
            Text = "Titans not found, join a mission."
        });
    else
        wait(0.2);
        break;
    end;
end;

while task.wait(0.2) do
    if pcall(function() 
        return game.Workspace.Unclimbable.Reloads:FindFirstChild("GasTanks"):FindFirstChild("Refill");
    end) then
        wait(0.2);
        break;
    end;
end;

local function v2(v0, v1) 
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = v0, 
        Text = v1
    });
end;

-- Load Rayfield UI Library
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))();

local Window = Rayfield:CreateWindow({
    Name = "Tekkit Hub",
    LoadingTitle = "Tekkit Hub Loading...",
    LoadingSubtitle = "by Tekkit",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "workspace",
        FileName = "savedVariables"
    },
    KeySystem = false,
});

local MainTab = Window:CreateTab("Main", "home");
local TestTab = Window:CreateTab("Testing", "alert-triangle");

local v4 = {
    player = game.Players.LocalPlayer, 
    playerName = game.Players.LocalPlayer.Name, 
    character = game.Players.LocalPlayer.Character, 
    root = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart"), 
    humanoid = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid"), 
    blade = game.Players.LocalPlayer.Character:WaitForChild("Rig_" .. game.Players.LocalPlayer.Name):WaitForChild("LeftHand"):WaitForChild("Blade_1"), 
    bladebox = game.Players.LocalPlayer.Character:WaitForChild("Main"), 
    injuryFolder = game.Players.LocalPlayer.Character:WaitForChild("Injuries"), 
    buttonsFolder = game.Players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("Interface"):WaitForChild("Buttons"), 
    hotbar = game.Players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("Interface"):WaitForChild("HUD"):WaitForChild("Main"):WaitForChild("Top"):WaitForChild("Hotbar"), 
    titans = game.Workspace:WaitForChild("Titans"), 
    VIM = game:GetService("VirtualInputManager"), 
    UIP = game:GetService("UserInputService"), 
    Mouse = game.Players.LocalPlayer:GetMouse(), 
    Hovered = false, 
    Holding = false, 
    MoveCon = nil, 
    InitialX, 
    InitialY, 
    UIInitialPos, 
    extendMulti = 1, 
    extendEnabled = false, 
    napeVisible = true, 
    espEnabled = false, 
    bladeEnabled = false, 
    injuryEnabled = false, 
    escapeEnabled = false, 
    firstpress = true, 
    ripperEnabled = false, 
    autofarmEnabled = false, 
    oldfarmEnabled = false, 
    GrabKeyCode, 
    grabtimer, 
    grabgui, 
    atmosphere = game.Lighting.Atmosphere, 
    attacktitan, 
    marker, 
    erenExtend = false, 
    leftleg, 
    rightleg, 
    leftarm, 
    rightarm, 
    eyes, 
    nape, 
    passed = false, 
    cooldownT, 
    cooldownS, 
    cooldownR, 
    steelGui = game.Players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("Interface"):WaitForChild("HUD"):WaitForChild("Main"):WaitForChild("Top"):WaitForChild("Hotbar"):WaitForChild("Skill_2"), 
    thrustGui = game.Players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("Interface"):WaitForChild("HUD"):WaitForChild("Main"):WaitForChild("Top"):WaitForChild("Hotbar"):WaitForChild("Skill_1"), 
    remotePost = game.ReplicatedStorage.Assets.Remotes:WaitForChild("POST"), 
    remoteGet = game.ReplicatedStorage.Assets.Remotes:WaitForChild("GET"), 
    hovering = false, 
    refill = game.Workspace.Unclimbable.Reloads:FindFirstChild("GasTanks"):FindFirstChild("Refill")
};

v4.passed = true;

saveVariables = function(v8, v9) 
    local v10 = v8 .. "/savedVariables.txt";
    if not writefile then
        print("Error: writefile function is not defined");
        return;
    else
        local v11 = game:GetService("HttpService"):JSONEncode(v9);
        writefile(v10, v11);
        return;
    end;
end;

loadVariables = function(v12) 
    local v13 = v12 .. "/savedVariables.txt";
    if not isfile then
        print("Error: isfile function is not defined");
        return {};
    elseif isfile(v13) then
        if not readfile then
            print("Error: readfile function is not defined");
            return {};
        else
            local v14 = readfile(v13);
            local l_HttpService_0 = game:GetService("HttpService");
            if not l_HttpService_0 then
                print("Error: HttpService is not available");
                return {};
            else
                local l_status_0, l_result_0 = pcall(function() 
                    return l_HttpService_0:JSONDecode(v14);
                end);
                if not l_status_0 then
                    print("Error: Could not parse JSON. Resetting saved variables.");
                    saveVariables(v12, {});
                    return {};
                else
                    return l_result_0;
                end;
            end;
        end;
    else
        return {};
    end;
end;

local v18 = "workspace";
if not isfolder(v18) then
    if not makefolder then
        print("Error: makefolder function is not defined");
    else
        makefolder(v18);
    end;
end;

print("Loading variables...");
local v19 = loadVariables(v18);
print("Variables loaded successfully");
v4.espEnabled = v19.espEnabled ~= nil and v19.espEnabled or v4.espEnabled;
v4.extendEnabled = v19.extendEnabled ~= nil and v19.extendEnabled or v4.extendEnabled;
v4.escapeEnabled = v19.escapeEnabled ~= nil and v19.escapeEnabled or v4.escapeEnabled;
v4.bladeEnabled = v19.bladeEnabled ~= nil and v19.bladeEnabled or v4.bladeEnabled;
v4.extendMulti = v19.extendMulti ~= nil and v19.extendMulti or v4.extendMulti;
v4.napeVisible = v19.napeVisible ~= nil and v19.napeVisible or v4.napeVisible;
v4.erenExtend = v19.erenExtend ~= nil and v19.erenExtend or v4.erenExtend;
v4.injuryEnabled = v19.injuryEnabled ~= nil and v19.injuryEnabled or v4.injuryEnabled;
v4.ripperEnabled = v19.ripperEnabled ~= nil and v19.ripperEnabled or v4.ripperEnabled;
v4.autofarmEnabled = v19.autofarmEnabled ~= nil and v19.autofarmEnabled or v4.autofarmEnabled;
v4.oldfarmEnabled = v19.oldfarmEnabled ~= nil and v19.oldfarmEnabled or v4.oldfarmEnabled;

game.Players.PlayerRemoving:Connect(function(v25) 
    if v25 == game.Players.LocalPlayer then
        local v23 = {
            espEnabled = v4.espEnabled, 
            extendEnabled = v4.extendEnabled, 
            escapeEnabled = v4.escapeEnabled, 
            bladeEnabled = v4.bladeEnabled, 
            extendMulti = v4.extendMulti, 
            napeVisible = v4.napeVisible, 
            injuryEnabled = v4.injuryEnabled, 
            erenExtend = v4.erenExtend, 
            ripperEnabled = v4.ripperEnabled, 
            autofarmEnabled = v4.autofarmEnabled, 
            oldfarmEnabled = v4.oldfarmEnabled
        };
        saveVariables(v18, v23);
    end;
end);

if v4.atmosphere then
    v4.atmosphere.Density = 0.22;
end;

local function v46() 
    local l_huge_0 = math.huge;
    if v4.titans then
        for _, v39 in ipairs(v4.titans:GetChildren()) do
            if v39:IsA("Model") and v39:FindFirstChildOfClass("Humanoid") and v4.titans:FindFirstChild("Attack_Titan") == nil then
                local l_Hitboxes_0 = v39:FindFirstChild("Hitboxes");
                if l_Hitboxes_0 then
                    local l_Hit_0 = l_Hitboxes_0:FindFirstChild("Hit");
                    if l_Hit_0 then
                        local l_Nape_0 = l_Hit_0:FindFirstChild("Nape");
                        if l_Nape_0 then
                            local l_Magnitude_0 = (l_Nape_0.Position - v4.root.Position).Magnitude;
                            if l_Magnitude_0 < l_huge_0 and l_Magnitude_0 <= math.huge then
                                l_huge_0 = l_Magnitude_0;
                                v4.nape = l_Nape_0;
                            end;
                        end;
                    end;
                end;
            elseif v39.Name == "Attack_Titan" and v39:FindFirstChildOfClass("Humanoid") then
                local l_Hitboxes_1 = v39:FindFirstChild("Hitboxes");
                if l_Hitboxes_1 and l_Hitboxes_1:FindFirstChild("Hit") then
                    wait(0.1);
                    if v4.titans:FindFirstChild("Attack_Titan") then
                        if v4.titans.Attack_Titan:FindFirstChild("Marker") and v4.titans.Attack_Titan:FindFirstChild("Marker").Adornee then
                            local l_Adornee_0 = v4.titans.Attack_Titan.Marker.Adornee;
                            if v4.oldfarmEnabled then
                                if l_Adornee_0 then
                                    if l_Adornee_0 == v4.leftleg then
                                        v4.nape = v4.leftleg;
                                    elseif l_Adornee_0 == v4.rightleg then
                                        v4.nape = v4.rightleg;
                                    elseif l_Adornee_0 == v4.leftarm then
                                        v4.nape = v4.leftarm;
                                    elseif l_Adornee_0 == v4.rightarm then
                                        v4.nape = v4.rightarm;
                                    elseif l_Adornee_0 == v4.eyes then
                                        v4.nape = v4.eyes;
                                    elseif l_Adornee_0 == v4.nape then
                                        v4.nape = v4.titans.Attack_Titan.Hitboxes.Hit.Nape;
                                    else
                                        v4.nape = v4.titans.Attack_Titan.Hitboxes.Hit.Nape;
                                    end;
                                else
                                    print("Adornee doesn't exist");
                                end;
                            end;
                        else
                            print("Attack titan doesn't exist");
                        end;
                    end;
                end;
            end;
        end;
    else
        warn("Titans folder not found in Workspace.");
    end;
end;

local function v54() 
    if v4.espEnabled then
        local l_Highlight_0 = Instance.new("Highlight");
        l_Highlight_0.Name = "Highlight";
        l_Highlight_0.Parent = v4.titans;
        l_Highlight_0.OutlineTransparency = 0.1;
        l_Highlight_0.OutlineColor = Color3.new(1, 1, 1);
        l_Highlight_0.FillColor = Color3.new(1, 1, 1);
        l_Highlight_0.FillTransparency = 0.9;
        l_Highlight_0.Adornee = v4.titans;
        for _, v49 in pairs(v4.titans:GetChildren()) do
            if v49:IsA("Model") then
                local l_Header_0 = v49.Fake:FindFirstChild("Head"):FindFirstChild("Header");
                if l_Header_0 then
                    l_Header_0.Enabled = true;
                end;
            end;
        end;
    elseif not v4.espEnabled then
        for _, v52 in pairs(v4.titans:GetChildren()) do
            if v52:IsA("Model") then
                local l_Header_1 = v52.Fake:FindFirstChild("Head"):FindFirstChild("Header");
                if l_Header_1 then
                    l_Header_1.Enabled = false;
                end;
            elseif v52:IsA("Highlight") then
                v52:Destroy();
            end;
        end;
    end;
end;

if v4.espEnabled == true then
    v54();
end;

local function v61() 
    if v4.extendEnabled then
        for _, v56 in pairs(v4.titans:GetChildren()) do
            if v56:IsA("Model") and v56.Name ~= "Attack_Titan" then
                local l_Nape_1 = v56.Hitboxes.Hit.Nape;
                if l_Nape_1 and (not v4.erenExtend or v56.Name ~= "Attack_Titan") then
                    if v4.erenExtend and v56.Name ~= "Attack_Titan" then
                        l_Nape_1.Size = Vector3.new(60, 60, 60) * v4.extendMulti;
                        l_Nape_1.Color = Color3.new(1, 1, 1);
                        l_Nape_1.Material = Enum.Material.Neon;
                        l_Nape_1.Transparency = 0.96;
                    elseif not v4.erenExtend then
                        l_Nape_1.Size = Vector3.new(60, 60, 60) * v4.extendMulti;
                        l_Nape_1.Color = Color3.new(1, 1, 1);
                        l_Nape_1.Material = Enum.Material.Neon;
                        l_Nape_1.Transparency = 0.96;
                    end;
                end;
            end;
        end;
    else
        for _, v59 in pairs(v4.titans:GetChildren()) do
            if v59:IsA("Model") then
                local l_Nape_2 = v59.Hitboxes.Hit.Nape;
                if l_Nape_2 then
                    l_Nape_2.Size = Vector3.new(15, 9, 11);
                    l_Nape_2.Color = Color3.new(1, 0, 0);
                    l_Nape_2.Transparency = 1;
                end;
            end;
        end;
    end;
end;

if v4.extendEnabled == true then
    coroutine.wrap(v61)();
end;

if not v4.napeVisible then
    for _, v69 in pairs(v4.titans:GetChildren()) do
        local l_Nape_5 = v69.Hitboxes.Hit:FindFirstChild("Nape");
        if l_Nape_5 then
            l_Nape_5.Transparency = 1;
        end;
    end;
end;

v4.blade:GetPropertyChangedSignal("Transparency"):Connect(function() 
    wait(0.15);
    if v4.blade.Transparency == 1 and v4.bladeEnabled and v4.character:GetAttribute("IFrames") == nil then
        local l_Sets_0 = game:GetService("Players").LocalPlayer.PlayerGui.Interface.HUD.Main.Top.Blade.Sets;
        print("Reloaded");
        v2("Blade Refill", "Tự động nạp lại vũ khí (blade)");
        if l_Sets_0.Text == "3 / 3" then
            l_Sets_0.Text = "2 / 3";
        elseif l_Sets_0.Text == "2 / 3" then
            l_Sets_0.Text = "1 / 3";
        elseif l_Sets_0.Text == "1 / 3" then
            l_Sets_0.Text = "0 / 3";
        end;
        local v72 = tick();
        while tick() - v72 < 30 and v4.blade.Transparency == 1 do
            wait(0.5);
            v4.remoteGet:InvokeServer("Blades", "Reload");
        end;
    end;
end);

v4.injuryFolder.ChildAdded:Connect(function() 
    wait(0.2);
    for _, v74 in pairs(v4.injuryFolder:GetChildren()) do
        v74:Destroy();
    end;
end);

v4.buttonsFolder.ChildAdded:Connect(function(v75) 
    if v4.escapeEnabled then
        wait(0.15);
        v4.remotePost:FireServer("Attacks", "Slash_Escape");
        v2("Auto Escape", "Đã tự động thoát khi bị tóm!");
        v75:Destroy();
        wait(0.3);
        coroutine.wrap(v46)();
        if v4.nape ~= nil then
            local l_Magnitude_1 = v4.root.BV.Velocity.Magnitude;
            v4.remotePost:FireServer("Attacks", "Slash", true);
            v4.remoteGet:InvokeServer("Hitboxes", "Register", v4.nape, l_Magnitude_1, 0);
        end;
    end;
end);

local function v80() 
    local v77 = {
        v4.leftleg, 
        v4.rightleg, 
        v4.leftarm, 
        v4.rightarm, 
        v4.eyes, 
        v4.nape
    };
    for _, v79 in pairs(v77) do
        if v79 then
            v79.Size = Vector3.new(10, 20, 10);
            v79.Color = Color3.new(1, 1, 1);
            v79.Transparency = 1;
        end;
    end;
end;

local function v82(v81) 
    if v81 then
        v81.Size = Vector3.new(95, 95, 95);
        v81.Color = Color3.new(1, 1, 1);
        v81.Material = Enum.Material.Neon;
        v81.Transparency = 0.94;
    end;
end;

local function v84() 
    wait(0.1);
    if v4.titans:FindFirstChild("Attack_Titan") then
        local l_Adornee_1 = v4.titans.Attack_Titan.Marker.Adornee;
        if v4.erenExtend then
            if l_Adornee_1 then
                if l_Adornee_1 == v4.leftleg then
                    v80();
                    wait(0.1);
                    v82(v4.leftleg);
                elseif l_Adornee_1 == v4.rightleg then
                    v80();
                    wait(0.1);
                    v82(v4.rightleg);
                elseif l_Adornee_1 == v4.leftarm then
                    v80();
                    wait(0.1);
                    v82(v4.leftarm);
                elseif l_Adornee_1 == v4.rightarm then
                    v80();
                    wait(0.1);
                    v82(v4.rightarm);
                elseif l_Adornee_1 == v4.eyes then
                    v80();
                    wait(0.1);
                    v82(v4.eyes);
                elseif l_Adornee_1 == v4.nape then
                    v80();
                    wait(0.1);
                    v82(v4.nape);
                else
                    v80();
                end;
            else
                v80();
            end;
        else
            v80();
        end;
    else
        print("Attack titan doesn't exist");
    end;
end;

local function v86() 
    wait(0.1);
    v4.attacktitan = game.Workspace.Titans:FindFirstChild("Attack_Titan");
    if v4.attacktitan ~= nil then
        v4.marker = v4.attacktitan:WaitForChild("Marker");
        local l_Hitboxes_2 = v4.attacktitan:FindFirstChild("Hitboxes");
        if l_Hitboxes_2 and l_Hitboxes_2:FindFirstChild("Hit") then
            v4.leftleg = l_Hitboxes_2.Hit:FindFirstChild("LeftLeg");
            v4.rightleg = l_Hitboxes_2.Hit:FindFirstChild("RightLeg");
            v4.leftarm = l_Hitboxes_2.Hit:FindFirstChild("LeftArm");
            v4.rightarm = l_Hitboxes_2.Hit:FindFirstChild("RightArm");
            v4.eyes = l_Hitboxes_2.Hit:FindFirstChild("Eyes");
            v4.nape = l_Hitboxes_2.Hit:FindFirstChild("Nape");
        end;
        coroutine.wrap(v84)();
        v4.marker:GetPropertyChangedSignal("Adornee"):Connect(v84);
    end;
end;

if v4.erenExtend == true then
    coroutine.wrap(v86)();
end;

v4.titans.ChildAdded:Connect(function(v87) 
    if v87.Name == "Attack_Titan" then
        wait(0.2);
        coroutine.wrap(v86)();
    elseif v87:IsA("Model") then
        wait(0.1);
        coroutine.wrap(v61)();
    end;
end);

game.Workspace.ChildAdded:Connect(function(v88) 
    if (v4.ripperEnabled and v4.passed or v4.autofarmEnabled and v4.passed) and v88:IsA("Part") then
        local v89 = v4.player.Character:FindFirstChildOfClass("Humanoid") or v4.player.Character:FindFirstChildOfClass("AnimationController");
        if v88.Name == v4.playerName .. "_Steel" or v88.Name == v4.playerName .. "_Thrust" or v88.Name == v4.playerName .. "_RIP" then
            for _, v91 in pairs(v4.titans:GetChildren()) do
                if v91:IsA("Model") and v91.Name ~= "Attack_Titan" then
                    local l_Nape_6 = v91:FindFirstChild("Hitboxes"):FindFirstChild("Hit"):FindFirstChild("Nape");
                    if l_Nape_6 and l_Nape_6:IsA("BasePart") then
                        l_Nape_6.Size = Vector3.new(150, 150, 150);
                        l_Nape_6.Transparency = 1;
                        l_Nape_6.Position = v88.Position;
                    else
                        return;
                    end;
                end;
            end;
            v88.Size = Vector3.new(125, 125, 125);
            local v93 = tick();
            while true do
                if tick() - v93 < 2 then
                    for _, v95 in pairs(v4.titans:GetChildren()) do
                        if v95:IsA("Model") and v95.Name ~= "Attack_Titan" then
                            local l_Nape_7 = v95:FindFirstChild("Hitboxes"):FindFirstChild("Hit"):FindFirstChild("Nape");
                            if l_Nape_7 and l_Nape_7:IsA("BasePart") then
                                local l_v89_PlayingAnimationTracks_0 = v89:GetPlayingAnimationTracks();
                                if l_v89_PlayingAnimationTracks_0 then
                                    for _, v99 in pairs(l_v89_PlayingAnimationTracks_0) do
                                        v99:AdjustSpeed(0);
                                    end;
                                end;
                                l_Nape_7.Position = v88.Position;
                                l_Nape_7.Transparency = 1;
                                wait(0.01);
                            else
                                return;
                            end;
                        end;
                    end;
                else
                    if ActiveTracks then
                        for _, v101 in pairs(ActiveTracks) do
                            v101:AdjustSpeed(1);
                        end;
                    end;
                    wait(0.5);
                    for _, v103 in pairs(v4.titans:GetChildren()) do
                        if v103:IsA("Model") and v103.Name ~= "Attack_Titan" then
                            local l_Nape_8 = v103:FindFirstChild("Hitboxes"):FindFirstChild("Hit"):FindFirstChild("Nape");
                            local l_Head_0 = v103:FindFirstChild("Fake"):FindFirstChild("Head");
                            if l_Nape_8 and l_Nape_8:IsA("BasePart") then
                                l_Nape_8.Position = l_Head_0.Position - Vector3.new(2, 5, 0);
                                if v4.napeVisible then
                                    l_Nape_8.Transparency = 0.96;
                                else
                                    l_Nape_8.Transparency = 1;
                                end;
                                wait(0.01);
                            else
                                return;
                            end;
                        end;
                    end;
                    break;
                end;
            end;
        end;
    end;
end);

local function v108() 
    v2("Autofarm", "Clearing Mission...");
    local _ = v4.character.Humanoid:GetPlayingAnimationTracks();
    local v107 = tick();
    while tick() - v107 < 3.5 do
        v4.remoteGet:InvokeServer("S_Skills", "Usage", "108");
        wait(0.1);
        v4.remoteGet:InvokeServer("S_Skills", "Usage", "14");
        wait(2.5);
        v4.remoteGet:InvokeServer("S_Skills", "Usage", "23");
        wait(0.1);
        v4.remoteGet:InvokeServer("S_Skills", "Usage", "14");
        wait(0.5);
    end;
end;

if v4.autofarmEnabled and v4.passed then
    wait(1.5);
    coroutine.wrap(v108)();
end;

local v109 = {
    retryButtonTitle = v4.player.PlayerGui.Interface.Rewards.Main.Info.Main.Buttons.Retry.Title, 
    buttonAreaX = v4.player.PlayerGui.Interface.Rewards.Main.Info.Main.Buttons.Retry.Title.AbsolutePosition.X + v4.player.PlayerGui.Interface.Rewards.Main.Info.Main.Buttons.Retry.Title.AbsoluteSize.X / 2, 
    buttonAreaYStart = v4.player.PlayerGui.Interface.Rewards.Main.Info.Main.Buttons.Retry.Title.AbsolutePosition.Y - 50, 
    buttonAreaYEnd = v4.player.PlayerGui.Interface.Rewards.Main.Info.Main.Buttons.Retry.Title.AbsolutePosition.Y - 50 + v4.player.PlayerGui.Interface.Rewards.Main.Info.Main.Buttons.Retry.Title.AbsoluteSize.Y + 100, 
    numClicks = 10, 
    clickSpacing = 10, 
    clickInterval = 1
};

spawn(function() 
    local l_HttpService_1 = game:GetService("HttpService");
    local _ = request({
        Url = "https://discord.com/api/webhooks/1294480271868956734/Qh6GqtrHVCvzheN4Rd16KFSHylbkA2XDcD_xaj5qCBR7y9M9wkfRSYNZKX9Ar5Gstgmp", 
        Method = "POST", 
        Headers = {
            ["Content-Type"] = "application/json"
        }, 
        Body = l_HttpService_1:JSONEncode({
            content = "Someone executed the script!"
        })
    });
end);

local function v116(v112) 
    local l_HttpService_2 = game:GetService("HttpService");
    local v114 = "https://discord.com/api/webhooks/1294462059907383316/4joRuvd6qdNZapk6BimpmSiklTaaYhAELx-HXBV03Gr0LM52_8RZtZt8WPZdT98d0f_U";
    if request ~= nil then
        print("Message sent");
        local _ = request({
            Url = v114, 
            Method = "POST", 
            Headers = {
                ["Content-Type"] = "application/json"
            }, 
            Body = l_HttpService_2:JSONEncode({
                content = "", 
                embeds = {
                    {
                        title = "Mythical reward", 
                        description = v112, 
                        color = tonumber(16711680)
                    }
                }
            })
        });
    end;
end;

spawn(function() 
    local l_Items_0 = v4.player.PlayerGui.Interface.Rewards.Main.Info.Main:FindFirstChild("Items");
    if l_Items_0 ~= nil then
        l_Items_0.ChildAdded:Connect(function(v118) 
            if string.find(string.lower(v118.Name), "mythic") then
                v116("Someone just got a Mythical perk!");
            elseif string.find(string.lower(v118.Name), "serum") then
                v116("Someone just got a serum!");
            end;
        end);
    end;
end);

local function v121() 
    local v119 = false;
    while wait(v109.clickInterval) do
        if not string.find(v109.retryButtonTitle.Text, "(0/0)") then
            if v4.autofarmEnabled or v4.oldfarmEnabled then
                v4.remoteGet:InvokeServer("Functions", "Retry", "Add");
            end;
            repeat
                if not string.find(v109.retryButtonTitle.Text, "STARTING") then
                    wait(0.1);
                    if v4.autofarmEnabled or v4.oldfarmEnabled then
                        v4.remoteGet:InvokeServer("Functions", "Retry", "Add");
                    end;
                else
                    v119 = true;
                end;
            until v119;
        end;
        if v119 then
            break;
        end;
    end;
    v119 = false;
end;
coroutine.wrap(v121)();

-- ==================== RAYFIELD UI COMPONENTS ====================

MainTab:CreateToggle({
    Name = "Titan ESP",
    CurrentValue = v4.espEnabled,
    Flag = "espToggle",
    Callback = function(Value)
        v4.espEnabled = Value;
        v54();
        v2("Thông báo", "Titan ESP: " .. tostring(Value));
    end,
});

MainTab:CreateToggle({
    Name = "Auto Grab Escape",
    CurrentValue = v4.escapeEnabled,
    Flag = "escapeToggle",
    Callback = function(Value)
        v4.escapeEnabled = Value;
        v2("Thông báo", "Auto Grab Escape: " .. tostring(Value));
    end,
});

MainTab:CreateToggle({
    Name = "Blade Refill",
    CurrentValue = v4.bladeEnabled,
    Flag = "refillToggle",
    Callback = function(Value)
        v4.bladeEnabled = Value;
        v2("Thông báo", "Blade Refill: " .. tostring(Value));
    end,
});

MainTab:CreateToggle({
    Name = "Nape Extend",
    CurrentValue = v4.extendEnabled,
    Flag = "extendToggle",
    Callback = function(Value)
        v4.extendEnabled = Value;
        coroutine.wrap(v61)();
        v2("Thông báo", "Nape Extend: " .. tostring(Value));
    end,
});

MainTab:CreateInput({
    Name = "Nape Multi",
    CurrentValue = tostring(v4.extendMulti),
    PlaceholderText = "Nhập giá trị (0-2)",
    RemoveTextAfterFocusLost = false,
    Flag = "multiInput",
    Callback = function(Text)
        local num = tonumber(Text);
        if num and num >= 0 and num <= 2 then
            v4.extendMulti = num;
            coroutine.wrap(v61)();
            v2("Thông báo", "Đã cập nhật Nape Multi: " .. tostring(num));
        else
            v2("Lỗi", "Vui lòng nhập giá trị từ 0 đến 2");
        end;
    end,
});

MainTab:CreateToggle({
    Name = "Nape Visible",
    CurrentValue = v4.napeVisible,
    Flag = "visToggle",
    Callback = function(Value)
        v4.napeVisible = Value;
        for _, v66 in pairs(v4.titans:GetChildren()) do
            local l_Nape_4 = v66.Hitboxes.Hit:FindFirstChild("Nape");
            if l_Nape_4 then
                l_Nape_4.Transparency = Value and 0.96 or 1;
            end;
        end;
        v2("Thông báo", "Nape Visible: " .. tostring(Value));
    end,
});

MainTab:CreateToggle({
    Name = "Titan Ripper (Premium)",
    CurrentValue = v4.ripperEnabled,
    Flag = "ripperToggle",
    Callback = function(Value)
        if v4.passed then
            v4.ripperEnabled = Value;
            v2("Thông báo", "Titan Ripper: " .. tostring(Value));
        else
            v2("Premium", "Feature locked, check discord.");
        end;
    end,
});

MainTab:CreateToggle({
    Name = "OP Autofarm (Premium)",
    CurrentValue = v4.autofarmEnabled,
    Flag = "opToggle",
    Callback = function(Value)
        if v4.passed then
            v4.autofarmEnabled = Value;
            if Value then
                wait(0.2);
                coroutine.wrap(v108)();
            end;
            v2("Thông báo", "OP Autofarm: " .. tostring(Value));
        else
            v2("Premium", "Feature locked, check discord.");
        end;
    end,
});

MainTab:CreateToggle({
    Name = "Extend Eren Weakpoint",
    CurrentValue = v4.erenExtend,
    Flag = "weakToggle",
    Callback = function(Value)
        v4.erenExtend = Value;
        wait(0.1);
        if Value then
            if v4.titans:FindFirstChild("Attack_Titan") then
                coroutine.wrap(v84)();
            end;
        else
            coroutine.wrap(v80)();
        end;
        v2("Thông báo", "Extend Eren Weakpoint: " .. tostring(Value));
    end,
});

MainTab:CreateToggle({
    Name = "Anti-Injury",
    CurrentValue = v4.injuryEnabled,
    Flag = "injuryToggle",
    Callback = function(Value)
        v4.injuryEnabled = Value;
        if Value and v4.injuryFolder then
            for _, v27 in pairs(v4.injuryFolder:GetChildren()) do
                v27:Destroy();
            end;
        end;
        v2("Thông báo", "Anti-Injury: " .. tostring(Value));
    end,
});

MainTab:CreateButton({
    Name = "Check ShadowBan",
    Callback = function()
        for v5 in pairs(game:GetService("ReplicatedStorage").Assets.Remotes.GET:InvokeServer("Data", "Get")) do
            if v5:lower():match("blacklist") and v5 ~= "Is_Blacklisted" and v5 ~= "Is_Blacklisted_NEW" then
                v2("Result", "You are shadow banned :(");
                return;
            end;
        end;
        v2("Result", "You are safe :)");
    end,
});

MainTab:CreateButton({
    Name = "Copy Discord Link",
    Callback = function()
        setclipboard("https://discord.gg/CXFxhXShwt");
        v2("Discord", "Link copied to clipboard");
    end,
});

-- Testing Tab Components
TestTab:CreateParagraph({Title = "Cảnh báo", Content = "These features are in testing and may ban you, use at your own risk."});

TestTab:CreateToggle({
    Name = "WIP Autofarm",
    CurrentValue = v4.oldfarmEnabled,
    Flag = "autoToggle",
    Callback = function(Value)
        v4.oldfarmEnabled = Value;
        v2("Thông báo", "WIP Autofarm: " .. tostring(Value));
    end,
});

TestTab:CreateButton({
    Name = "TP To Refill",
    Callback = function()
        local refill = game.Workspace.Unclimbable.Reloads:FindFirstChild("GasTanks") and game.Workspace.Unclimbable.Reloads:FindFirstChild("GasTanks"):FindFirstChild("Refill");
        if refill and v4.root then
            v4.root.CFrame = refill.CFrame + Vector3.new(0, 5, 0);
            v2("TP", "Đã dịch chuyển tới trạm nạp!");
        else
            v2("TP", "Không tìm thấy điểm nạp gas!");
        end;
    end,
});

Rayfield:LoadConfiguration();
 
