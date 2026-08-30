-- Kiểm tra và load Rayfield UI an toàn
local success, Rayfield = pcall(function()
    return loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
end)

if not success or not Rayfield then
    warn("Không thể tải Rayfield UI!")
    return
end

local Window = Rayfield:CreateWindow({
    Name = "Namanhle Hub | Rayfield UI",
    LoadingTitle = "Đang tải Namanhle Hub...",
    LoadingSubtitle = "by Namanhle",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "NamanhleHub",
        FileName = "Config"
    },
    KeySystem = false,
})

-- Tạo các Tabs
local MainTab = Window:CreateTab("Main", 4483362458)
local TestingTab = Window:CreateTab("Testing (Risky)", 4483362458)
local MiscTab = Window:CreateTab("Misc", 4483362458)

local function notify(title, text)
    Rayfield:Notify({
        Title = title,
        Content = text,
        Duration = 3,
        Image = 4483362458,
    })
end

-- Biến lưu trạng thái tính năng
local autoAttackEnabled = false

-- Vòng lặp tự động chém Titan (Auto Attack)
task.spawn(function()
    while task.wait(0.1) do
        if autoAttackEnabled then
            pcall(function()
                local player = game.Players.LocalPlayer
                local character = player.Character
                local rootPart = character and character:FindFirstChild("HumanoidRootPart")
                local titans = workspace:FindFirstChild("Titans")
                
                if rootPart and titans then
                    for _, titan in pairs(titans:GetChildren()) do
                        if titan:IsA("Model") then
                            local hitboxes = titan:FindFirstChild("Hitboxes")
                            local hit = hitboxes and hitboxes:FindFirstChild("Hit")
                            local nape = hit and hit:FindFirstChild("Nape")
                            
                            if nape then
                                local distance = (nape.Position - rootPart.Position).Magnitude
                                if distance < 30 then
                                    rootPart.CFrame = nape.CFrame + Vector3.new(0, 0, 3)
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- === MAIN TAB ===
MainTab:CreateSection("Tính năng chính")

MainTab:CreateToggle({
    Name = "Titan ESP",
    CurrentValue = false,
    Flag = "esp_toggle",
    Callback = function(Value)
        local titans = workspace:FindFirstChild("Titans")
        if not titans then return end
        if Value then
            local highlight = Instance.new("Highlight")
            highlight.Name = "Highlight"
            highlight.Parent = titans
            highlight.FillTransparency = 0.9
            highlight.Adornee = titans
            for _, v in pairs(titans:GetChildren()) do
                if v:IsA("Model") then
                    local header = v:FindFirstChild("Fake") and v.Fake:FindFirstChild("Head") and v.Fake.Head:FindFirstChild("Header")
                    if header then header.Enabled = true end
                end
            end
        else
            for _, v in pairs(titans:GetChildren()) do
                if v:IsA("Model") then
                    local header = v:FindFirstChild("Fake") and v.Fake:FindFirstChild("Head") and v.Fake.Head:FindFirstChild("Header")
                    if header then header.Enabled = false end
                elseif v.Name == "Highlight" then
                    v:Destroy()
                end
            end
        end
    end,
})

MainTab:CreateToggle({
    Name = "Auto Attack Titan (Tự động chém)",
    CurrentValue = false,
    Flag = "auto_attack_toggle",
    Callback = function(Value)
        autoAttackEnabled = Value
        if Value then
            notify("Auto Attack", "Đã bật tự động chém Titan!")
        else
            notify("Auto Attack", "Đã tắt tự động chém Titan!")
        end
    end,
})

MainTab:CreateToggle({
    Name = "Auto Grab Escape",
    CurrentValue = false,
    Flag = "escape_toggle",
    Callback = function(Value) end,
})

MainTab:CreateToggle({
    Name = "Blade Refill",
    CurrentValue = false,
    Flag = "blade_toggle",
    Callback = function(Value) end,
})

MainTab:CreateToggle({
    Name = "Nape Extend",
    CurrentValue = false,
    Flag = "extend_toggle",
    Callback = function(Value) end,
})

MainTab:CreateInput({
    Name = "Nape Multi (0 - 2)",
    CurrentValue = "1",
    PlaceholderText = "Nhập số từ 0 - 2",
    RemoveTextAfterFocusLost = false,
    Flag = "multi_input",
    Callback = function(Text)
        local num = tonumber(Text)
        if num and num >= 0 and num <= 2 then
            -- Xử lý multi
        end
    end,
})

-- === TESTING TAB ===
TestingTab:CreateSection("Tính năng thử nghiệm")

TestingTab:CreateButton({
    Name = "TP To Refill (Tự động theo Map)",
    Callback = function()
        local foundRefill = nil
        
        -- Quét thông minh tìm điểm nạp khí trên mọi map
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj.Name == "Refill" or obj.Name == "GasTank" or obj.Name == "Gas" then
                if obj:IsA("BasePart") then
                    foundRefill = obj
                    break
                elseif obj:IsA("Model") and obj.PrimaryPart then
                    foundRefill = obj.PrimaryPart
                    break
                end
            end
        end
        
        local char = game.Players.LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        
        if foundRefill and root then
            root.CFrame = CFrame.new(foundRefill.Position + Vector3.new(0, 3, 0))
            notify("Thành công", "Đã dịch chuyển tới trạm nạp khí!")
        else
            notify("Lỗi", "Map này không có hoặc chưa tìm thấy điểm nạp khí!")
        end
    end,
})

-- === MISC TAB ===
MiscTab:CreateSection("Tiện ích")

MiscTab:CreateButton({
    Name = "Check ShadowBan",
    Callback = function()
        local success, result = pcall(function()
            return game:GetService("ReplicatedStorage").Assets.Remotes.GET:InvokeServer("Data", "Get")
        end)
        if success and result then
            for v5 in pairs(result) do
                if v5:lower():match("blacklist") and v5 ~= "Is_Blacklisted" and v5 ~= "Is_Blacklisted_NEW" then
                    return notify("Kết quả", "Bạn đang bị Shadowban :(")
                end
            end
        end
        return notify("Kết quả", "Bạn hoàn toàn an toàn :)")
    end,
})

MiscTab:CreateButton({
    Name = "Copy Discord Link",
    Callback = function()
        setclipboard("https://discord.gg/CXFxhXShwt")
        notify("Discord", "Đã copy link vào clipboard!")
    end,
})

Rayfield:LoadConfiguration()
 
