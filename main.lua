-- Load Rayfield Library
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Tekkit Hub | Rayfield UI",
    LoadingTitle = "Tekkit Hub is loading...",
    LoadingSubtitle = "by Tekkit",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "TekkitHub",
        FileName = "savedVariables"
    },
    KeySystem = false,
});

-- Tabs
local MainTab = Window:CreateTab("Main", 4483362458)
local TestingTab = Window:CreateTab("Testing (Risky)", 4483362458)
local MiscTab = Window:CreateTab("Misc", 4483362458)

-- Biến lưu trạng thái logic
local v4 = {
    player = game.Players.LocalPlayer, 
    character = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait(),
    root = nil,
    titans = game.Workspace:WaitForChild("Titans"),
    extendMulti = 1, 
    extendEnabled = false, 
    napeVisible = true, 
    espEnabled = false, 
    bladeEnabled = false, 
    injuryEnabled = false, 
    escapeEnabled = false, 
    passed = true, 
    ripperEnabled = false, 
    autofarmEnabled = false, 
    oldfarmEnabled = false, 
    erenExtend = false, 
    refill = game.Workspace:WaitForChild("Unclimbable", 5) and game.Workspace.Unclimbable.Reloads:FindFirstChild("GasTanks"):FindFirstChild("Refill")
};

-- Cập nhật RootPart khi nhân vật hồi sinh
v4.player.CharacterAdded:Connect(function(char)
    v4.character = char
    v4.root = char:WaitForChild("HumanoidRootPart")
end)
if v4.character then
    v4.root = v4.character:FindFirstChild("HumanoidRootPart")
end

local function notify(title, text)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = title, 
        Text = text
    });
end

-- === MAIN TAB ===
MainTab:CreateSection("Features")

MainTab:CreateToggle({
    Name = "Titan ESP",
    CurrentValue = v4.espEnabled,
    Flag = "espEnabled",
    Callback = function(Value)
        v4.espEnabled = Value
        if v4.espEnabled then
            local highlight = Instance.new("Highlight");
            highlight.Name = "Highlight";
            highlight.Parent = v4.titans;
            highlight.OutlineTransparency = 0.1;
            highlight.OutlineColor = Color3.new(1, 1, 1);
            highlight.FillColor = Color3.new(1, 1, 1);
            highlight.FillTransparency = 0.9;
            highlight.Adornee = v4.titans;
            for _, v in pairs(v4.titans:GetChildren()) do
                if v:IsA("Model") then
                    local header = v.Fake:FindFirstChild("Head"):FindFirstChild("Header");
                    if header then header.Enabled = true; end;
                end;
            end;
        else
            for _, v in pairs(v4.titans:GetChildren()) do
                if v:IsA("Model") then
                    local header = v.Fake:FindFirstChild("Head"):FindFirstChild("Header");
                    if header then header.Enabled = false; end;
                elseif v:IsA("Highlight") then
                    v:Destroy();
                end;
            end;
        end;
    end,
})

MainTab:CreateToggle({
    Name = "Auto Grab Escape",
    CurrentValue = v4.escapeEnabled,
    Flag = "escapeEnabled",
    Callback = function(Value) v4.escapeEnabled = Value end,
})

MainTab:CreateToggle({
    Name = "Blade Refill",
    CurrentValue = v4.bladeEnabled,
    Flag = "bladeEnabled",
    Callback = function(Value) v4.bladeEnabled = Value end,
})

MainTab:CreateToggle({
    Name = "Nape extend",
    CurrentValue = v4.extendEnabled,
    Flag = "extendEnabled",
    Callback = function(Value) v4.extendEnabled = Value end,
})

MainTab:CreateInput({
    Name = "Nape Multi (0 - 2)",
    CurrentValue = tostring(v4.extendMulti),
    PlaceholderText = "1",
    RemoveTextAfterFocusLost = false,
    Flag = "extendMulti",
    Callback = function(Text)
        local num = tonumber(Text)
        if num and num >= 0 and num <= 2 then
            v4.extendMulti = num
        end
    end,
})

MainTab:CreateToggle({
    Name = "Nape Visible",
    CurrentValue = v4.napeVisible,
    Flag = "napeVisible",
    Callback = function(Value)
        v4.napeVisible = Value
        for _, v in pairs(v4.titans:GetChildren()) do
            local nape = v.Hitboxes.Hit:FindFirstChild("Nape");
            if nape then
                nape.Transparency = v4.napeVisible and 0.96 or 1;
            end;
        end;
    end,
})

MainTab:CreateToggle({
    Name = "Anti-Injury",
    CurrentValue = v4.injuryEnabled,
    Flag = "injuryEnabled",
    Callback = function(Value)
        v4.injuryEnabled = Value
        local injuryFolder = v4.character:FindFirstChild("Injuries")
        if v4.injuryEnabled and injuryFolder then
            for _, inj in pairs(injuryFolder:GetChildren()) do
                inj:Destroy();
            end;
        end;
    end,
})

MainTab:CreateToggle({
    Name = "Extend Eren Weakpoint",
    CurrentValue = v4.erenExtend,
    Flag = "erenExtend",
    Callback = function(Value) v4.erenExtend = Value end,
})

MainTab:CreateToggle({
    Name = "Titan Ripper (Premium)",
    CurrentValue = v4.ripperEnabled,
    Flag = "ripperEnabled",
    Callback = function(Value)
        if v4.passed then v4.ripperEnabled = Value else notify("Premium", "Locked"); end;
    end,
})

MainTab:CreateToggle({
    Name = "OP Autofarm (Premium)",
    CurrentValue = v4.autofarmEnabled,
    Flag = "autofarmEnabled",
    Callback = function(Value)
        if v4.passed then v4.autofarmEnabled = Value else notify("Premium", "Locked"); end;
    end,
})

-- === TESTING TAB ===
TestingTab:CreateSection("Risky Features")

TestingTab:CreateToggle({
    Name = "WIP Autofarm",
    CurrentValue = v4.oldfarmEnabled,
    Flag = "oldfarmEnabled",
    Callback = function(Value)
        v4.oldfarmEnabled = Value
        if not v4.oldfarmEnabled and v4.root and v4.root:FindFirstChild("BodyPosition") then
            v4.root:FindFirstChild("BodyPosition"):Destroy();
        end;
    end,
})

TestingTab:CreateButton({
    Name = "TP To Refill",
    Callback = function()
        if v4.refill and v4.root then
            local targetPos = v4.refill.Position + Vector3.new(0, 2, 0);
            local distance = (targetPos - v4.root.Position).Magnitude / 225;
            local tweenInfo = TweenInfo.new(distance, Enum.EasingStyle.Linear, Enum.EasingDirection.In);
            game:GetService("TweenService"):Create(v4.root, tweenInfo, { CFrame = CFrame.new(targetPos) }):Play();
        end
    end,
})

-- === MISC TAB ===
MiscTab:CreateSection("Utilities")

MiscTab:CreateButton({
    Name = "Check ShadowBan",
    Callback = function()
        local success, result = pcall(function()
            return game:GetService("ReplicatedStorage").Assets.Remotes.GET:InvokeServer("Data", "Get")
        end)
        if success and result then
            for v5 in pairs(result) do
                if v5:lower():match("blacklist") and v5 ~= "Is_Blacklisted" and v5 ~= "Is_Blacklisted_NEW" then
                    return notify("Result", "You are shadow banned :(", 5);
                end;
            end;
        end;
        return notify("Result", "You are safe :)", 5);
    end,
})

MiscTab:CreateButton({
    Name = "Copy Discord Link",
    Callback = function()
        setclipboard("https://discord.gg/CXFxhXShwt");
        notify("Discord", "Link copied", 5);
    end,
})

Rayfield:LoadConfiguration()
