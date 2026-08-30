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

-- Biến cấu hình trạng thái
local autoAttackEnabled = false
local autoRefillEnabled = false
local autoReplayEnabled = false
local napeExtendEnabled = false
local napeMultiValue = 5 -- Mặc định to hơn hẳn để đứng trên đầu chém thoải mái
local safeHeight = 5
local safeDistance = 0

-- Hàm Tween di chuyển mượt mà tới mục tiêu
local function tweenTo(targetCFrame, speed)
    local player = game.Players.LocalPlayer
    local character = player.Character
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end

    speed = speed or 300 -- Tốc độ tween
    local distance = (targetCFrame.Position - rootPart.Position).Magnitude
    local timeVal = distance / speed
    
    local tweenInfo = TweenInfo.new(timeVal, Enum.EasingStyle.Linear)
    local tween = game:GetService("TweenService"):Create(rootPart, tweenInfo, {CFrame = targetCFrame})
    tween:Play()
end

-- Vòng lặp chính xử lý Auto Attack, Nape Extend, Auto Refill, Auto Replay
task.spawn(function()
    while task.wait(0.2) do
        pcall(function()
            local player = game.Players.LocalPlayer
            local character = player.Character
            local rootPart = character and character:FindFirstChild("HumanoidRootPart")
            local humanoid = character and character:FindFirstChild("Humanoid")
            
            -- 1. Tính năng Auto Replay (Tự động chơi lại khi hết ván)
            if autoReplayEnabled then
                for _, uiObj in pairs(player.PlayerGui:GetDescendants()) do
                    if uiObj:IsA("TextButton") or uiObj:IsA("ImageButton") then
                        local text = uiObj.Text:lower()
                        if text:find("replay") or text:find("play again") or text:find("tiếp tục") or text:find("chơi lại") then
                            -- Giả lập click nút chơi lại
                            for _, connection in pairs(getconnections(uiObj.MouseButton1Click)) do
                                connection:Fire()
                            end
                        end
                    end
                end
            end

            -- 2. Tính năng Auto Refill (Tự động nạp gas/kiếm khi hết)
            if autoRefillEnabled and rootPart then
                -- Kiểm tra nếu gas hoặc kiếm yếu (bạn có thể tinh chỉnh điều kiện nhận biết trong game)
                local needsRefill = false
                pcall(function()
                    -- Giả sử check chỉ số gas nếu có, hoặc luôn quét trạm nạp khi ở gần hết
                    if humanoid and humanoid.Health > 0 then
                        -- Tự động tìm trạm nạp trên map
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
                        -- Nếu tìm thấy và người chơi cách xa hoặc muốn chủ động nạp
                        if foundRefill then
                            -- Nếu thấy đồng hồ/thanh khí báo thấp (tùy game), ở đây làm mẫu tele khi bật auto refill
                            -- rootPart.CFrame = CFrame.new(foundRefill.Position + Vector3.new(0, 3, 0))
                        end
                    end
                end)
            end

            -- 3. Quét Titans toàn bản đồ cho Nape Extend và Auto Attack
            local titans = workspace:FindFirstChild("Titans")
            if titans and rootPart then
                for _, titan in pairs(titans:GetChildren()) do
                    if titan:IsA("Model") then
                        local hitboxes = titan:FindFirstChild("Hitboxes")
                        local hit = hitboxes and hitboxes:FindFirstChild("Hit")
                        local nape = hit and hit:FindFirstChild("Nape")
                        
                        if nape then
                            -- Phóng to Hitbox gáy cực lớn để đứng trên đầu vẫn chém được
                            if napeExtendEnabled then
                                nape.Size = Vector3.new(10 * napeMultiValue, 10 * napeMultiValue, 10 * napeMultiValue)
                                nape.Transparency = 0.7
                            else
                                nape.Size = Vector3.new(3, 3, 3)
                            end
                            
                            -- Auto Attack toàn bản đồ + Tween mượt mà + Tự động chém
                            if autoAttackEnabled then
                                local targetCFrame = nape.CFrame * CFrame.new(0, safeHeight, safeDistance)
                                -- Tween tới gáy Titan ở bất cứ khoảng cách nào trên bản đồ
                                tweenTo(targetCFrame, 350)
                                
                                -- Tự động kích hoạt hành động chém (M1 / Tool activation)
                                local tool = character:FindFirstChildOfClass("Tool")
                                if tool then
                                    tool:Activate()
                                end
                            end
                        end
                    end
                end
            end
        end)
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
    Name = "Auto Attack (Tween toàn map + Tự chém)",
    CurrentValue = false,
    Flag = "auto_attack_toggle",
    Callback = function(Value)
        autoAttackEnabled = Value
        if Value then
            notify("Auto Attack", "Đã bật tự động săn & chém Titan toàn map!")
        else
            notify("Auto Attack", "Đã tắt.")
        end
    end,
})

MainTab:CreateToggle({
    Name = "Auto Refill (Tự động nạp gas/kiếm)",
    CurrentValue = false,
    Flag = "auto_refill_toggle",
    Callback = function(Value)
        autoRefillEnabled = Value
        if Value then
            notify("Auto Refill", "Đã bật tự động tìm trạm nạp!")
        else
            notify("Auto Refill", "Đã tắt tự động nạp.")
        end
    end,
})

MainTab:CreateToggle({
    Name = "Auto Replay (Tự động chơi lại ván mới)",
    CurrentValue = false,
    Flag = "auto_replay_toggle",
    Callback = function(Value)
        autoReplayEnabled = Value
        if Value then
            notify("Auto Replay", "Đã bật tự động chơi lại!")
        else
            notify("Auto Replay", "Đã tắt tự động chơi lại.")
        end
    end,
})

MainTab:CreateInput({
    Name = "Độ cao an toàn (Safe Height)",
    CurrentValue = "5",
    PlaceholderText = "Mặc định: 5",
    RemoveTextAfterFocusLost = false,
    Flag = "safe_height_input",
    Callback = function(Text)
        local num = tonumber(Text)
        if num then safeHeight = num end
    end,
})

MainTab:CreateToggle({
    Name = "Nape Extend (Phóng to Hitbox siêu lớn)",
    CurrentValue = false,
    Flag = "extend_toggle",
    Callback = function(Value)
        napeExtendEnabled = Value
        if Value then
            notify("Nape Extend", "Đã phóng to gáy cực đại để đứng trên đầu chém!")
        else
            notify("Nape Extend", "Đã trả về mặc định.")
        end
    end,
})

MainTab:CreateInput({
    Name = "Nape Multi (1 - 300)",
    CurrentValue = "2",
    PlaceholderText = "Nhập từ 1 đến 300",
    RemoveTextAfterFocusLost = false,
    Flag = "multi_input",
    Callback = function(Text)
        local num = tonumber(Text)
        if num and num >= 1 and num <= 300 then
            napeMultiValue = num
            notify("Cài đặt", "Độ rộng gáy đã tăng gấp " .. num)
        end
    end,
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
 
