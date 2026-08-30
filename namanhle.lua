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

-- Biến cấu hình trạng thái và thông số tùy chỉnh
local autoAttackEnabled = false
local napeExtendEnabled = false
local napeMultiValue = 1.5
local safeHeight = 3
local safeDistance = 4

-- Vòng lặp xử lý logic ngầm (Auto Attack & Nape Extend)
task.spawn(function()
    while task.wait(0.1) do
        local player = game.Players.LocalPlayer
        local character = player.Character
        local rootPart = character and character:FindFirstChild("HumanoidRootPart")
        local titans = workspace:FindFirstChild("Titans")
        
        if titans then
            for _, titan in pairs(titans:GetChildren()) do
                if titan:IsA("Model") then
                    local hitboxes = titan:FindFirstChild("Hitboxes")
                    local hit = hitboxes and hitboxes:FindFirstChild("Hit")
                    local nape = hit and hit:FindFirstChild("Nape")
                    
                    if nape then
                        -- 1. Phóng to Hitbox gáy Titan với giá trị tùy chỉnh
                        if napeExtendEnabled then
                            nape.Size = Vector3.new(4 * napeMultiValue, 4 * napeMultiValue, 4 * napeMultiValue)
                            nape.Transparency = 0.8
                        else
                            nape.Size = Vector3.new(3, 3, 3)
                        end
                        
                        -- 2. Auto Attack với chiều cao và khoảng cách tùy chỉnh
                        if autoAttackEnabled and rootPart then
                            local distance = (nape.Position - rootPart.Position).Magnitude
                            if distance < 150 then
                                -- Sử dụng biến safeHeight và safeDistance người dùng tự nhập
                                local safePosition = nape.CFrame * CFrame.new(0, safeHeight, safeDistance)
                                rootPart.CFrame = safePosition
                            end
                        end
                    end
                end
            end
        end
    end
end)

-- === MAIN TAB ===
MainTab:CreateSection("Tính năng chiến đấu")

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
    Name = "Auto Attack Titan (Tự động bám gáy)",
    CurrentValue = false,
    Flag = "auto_attack_toggle",
    Callback = function(Value)
        autoAttackEnabled = Value
        if Value then
            notify("Auto Attack", "Đã bật tự động bám gáy an toàn!")
        else
            notify("Auto Attack", "Đã tắt tự động chém.")
        end
    end,
})

MainTab:CreateInput({
    Name = "Độ cao an toàn (Safe Height)",
    CurrentValue = "3",
    PlaceholderText = "Mặc định: 3",
    RemoveTextAfterFocusLost = false,
    Flag = "safe_height_input",
    Callback = function(Text)
        local num = tonumber(Text)
        if num then
            safeHeight = num
        end
    end,
})

MainTab:CreateInput({
    Name = "Khoảng cách lùi sau (Safe Distance)",
    CurrentValue = "4",
    PlaceholderText = "Mặc định: 4",
    RemoveTextAfterFocusLost = false,
    Flag = "safe_distance_input",
    Callback = function(Text)
        local num = tonumber(Text)
        if num then
            safeDistance = num
        end
    end,
})

MainTab:CreateToggle({
    Name = "Nape Extend (Phóng to Hitbox gáy)",
    CurrentValue = false,
    Flag = "extend_toggle",
    Callback = function(Value)
        napeExtendEnabled = Value
        if Value then
            notify("Nape Extend", "Đã phóng to gáy Titan!")
        else
            notify("Nape Extend", "Đã trả về kích thước gốc.")
        end
    end,
})

MainTab:CreateInput({
    Name = "Nape Multi (1 - 3)",
    CurrentValue = "1.5",
    PlaceholderText = "Nhập từ 1 đến 3",
    RemoveTextAfterFocusLost = false,
    Flag = "multi_input",
    Callback = function(Text)
        local num = tonumber(Text)
        if num and num >= 1 and num <= 3 then
            napeMultiValue = num
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

-- === TESTING TAB ===
TestingTab:CreateSection("Tính năng thử nghiệm")

TestingTab:CreateButton({
    Name = "TP To Refill (Tự động theo Map)",
    Callback = function()
        local foundRefill = nil
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
 
