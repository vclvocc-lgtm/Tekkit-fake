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

-- Biến cấu hình trạng thái & thông số
local autoAttackEnabled = false
local autoRefillEnabled = false
local autoReplayEnabled = false
local autoEscapeEnabled = true
local napeExtendEnabled = false
local napeMultiplier = 3 -- Giá trị phóng to gáy tùy chỉnh
local safeHeight = 5
local safeDistance = 0
local tweenSpeed = 300

local VirtualUser = game:GetService("VirtualUser")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- ==========================================
-- HÀM TWEEN MƯỢT CHỐNG RUNG TỐI ƯU TUYỆT ĐỐI
-- ==========================================
local activeTween = nil
local function smoothTweenTo(targetCFrame)
    local player = game.Players.LocalPlayer
    local character = player.Character
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end

    local distance = (targetCFrame.Position - rootPart.Position).Magnitude
    
    -- Nếu ở gần đích (dưới 5 studs), hủy tween và gán thẳng vị trí để triệt tiêu hoàn toàn rung lắc
    if distance < 5 then
        if activeTween then 
            activeTween:Cancel() 
            activeTween = nil 
        end
        rootPart.CFrame = targetCFrame
        return
    end

    -- Nếu đang tween thì giữ nguyên luồng để chuyển động mượt mà không bị ngắt quãng
    if activeTween then return end

    local timeVal = distance / tweenSpeed
    local tweenInfo = TweenInfo.new(timeVal, Enum.EasingStyle.Linear)
    activeTween = TweenService:Create(rootPart, tweenInfo, {CFrame = targetCFrame})
    
    activeTween.Completed:Connect(function()
        activeTween = nil
    end)
    
    activeTween:Play()
end

-- Vòng lặp chính xử lý AFK & Auto Attack
RunService.Heartbeat:Connect(function()
    local player = game.Players.LocalPlayer
    local character = player.Character
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    local titans = workspace:FindFirstChild("Titans")
    
    -- 1. Xử lý Nape Extend theo giá trị ô nhập
    if titans then
        for _, titan in pairs(titans:GetChildren()) do
            if titan:IsA("Model") then
                local hitboxes = titan:FindFirstChild("Hitboxes")
                local hit = hitboxes and hitboxes:FindFirstChild("Hit")
                local nape = hit and hit:FindFirstChild("Nape")
                
                if nape then
                    if napeExtendEnabled then
                        nape.Size = Vector3.new(10 * napeMultiplier, 10 * napeMultiplier, 10 * napeMultiplier)
                        nape.Transparency = 0.6
                        nape.CanCollide = false
                    else
                        nape.Size = Vector3.new(3, 3, 3)
                        nape.Transparency = 0.96
                    end
                end
            end
        end
    end

    -- 2. Xử lý Auto Attack (Săn toàn map + Tween chống rung + Tự chém)
    if autoAttackEnabled and rootPart and titans then
        pcall(function()
            local closestNape = nil
            local shortestDist = math.huge

            for _, titan in pairs(titans:GetChildren()) do
                if titan:IsA("Model") then
                    local hitboxes = titan:FindFirstChild("Hitboxes")
                    local hit = hitboxes and hitboxes:FindFirstChild("Hit")
                    local nape = hit and hit:FindFirstChild("Nape")
                    
                    if nape then
                        local dist = (nape.Position - rootPart.Position).Magnitude
                        if dist < shortestDist then
                            shortestDist = dist
                            closestNape = nape
                        end
                    end
                end
            end

            if closestNape then
                local targetCFrame = closestNape.CFrame * CFrame.new(0, safeHeight, safeDistance)
                smoothTweenTo(targetCFrame)

                -- Tự động chém
                local tool = character:FindFirstChildOfClass("Tool")
                if tool then
                    tool:Activate()
                end
                
                VirtualUser:Button1Down(Vector2.new(0,0))
                task.wait(0.05)
                VirtualUser:Button1Up(Vector2.new(0,0))
            end
        end)
    end
end)

-- Luồng phụ xử lý Auto Replay, Auto Refill & Auto Escape
task.spawn(function()
    while task.wait(0.3) do
        pcall(function()
            local player = game.Players.LocalPlayer
            local character = player.Character
            local rootPart = character and character:FindFirstChild("HumanoidRootPart")

            -- Auto Escape (Tự thoát khi bị tóm)
            if autoEscapeEnabled then
                for _, uiObj in pairs(player.PlayerGui:GetDescendants()) do
                    if uiObj:IsA("TextButton") or uiObj:IsA("ImageButton") then
                        local text = uiObj.Text:lower()
                        local name = uiObj.Name:lower()
                        if text:find("escape") or text:find("mash") or text:find("click") or name:find("escape") or name:find("grab") then
                            for _, connection in pairs(getconnections(uiObj.MouseButton1Click)) do
                                connection:Fire()
                            end
                        end
                    end
                end
            end

            -- Auto Replay (Tự chơi lại)
            if autoReplayEnabled then
                for _, uiObj in pairs(player.PlayerGui:GetDescendants()) do
                    if uiObj:IsA("TextButton") or uiObj:IsA("ImageButton") then
                        local text = uiObj.Text:lower()
                        if text:find("replay") or text:find("play again") or text:find("tiếp tục") or text:find("chơi lại") or text:find("next") then
                            for _, connection in pairs(getconnections(uiObj.MouseButton1Click)) do
                                connection:Fire()
                            end
                        end
                    end
                end
            end

            -- Auto Refill (Tự nạp gas/kiếm)
            if autoRefillEnabled and rootPart then
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
                if foundRefill then
                    rootPart.CFrame = CFrame.new(foundRefill.Position + Vector3.new(0, 3, 0))
                end
            end
        end)
    end
end)

-- === MAIN TAB ===
MainTab:CreateSection("Tính năng chiến đấu AFK")

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
    Name = "Auto Attack (Tween mượt chống rung + Tự chém)",
    CurrentValue = false,
    Flag = "auto_attack_toggle",
    Callback = function(Value)
        autoAttackEnabled = Value
        if Value then
            notify("Auto Attack", "Đã bật hệ thống tự động cày nhiệm vụ!")
        else
            if activeTween then activeTween:Cancel() activeTween = nil end
            notify("Auto Attack", "Đã tắt.")
        end
    end,
})

MainTab:CreateToggle({
    Name = "Auto Grab Escape (Tự thoát khi bị tóm)",
    CurrentValue = true,
    Flag = "escape_toggle",
    Callback = function(Value)
        autoEscapeEnabled = Value
    end,
})

MainTab:CreateToggle({
    Name = "Auto Refill (Tự động nạp gas/kiếm)",
    CurrentValue = false,
    Flag = "auto_refill_toggle",
    Callback = function(Value)
        autoRefillEnabled = Value
    end,
})

MainTab:CreateToggle({
    Name = "Auto Replay (Tự động chơi lại)",
    CurrentValue = false,
    Flag = "auto_replay_toggle",
    Callback = function(Value)
        autoReplayEnabled = Value
    end,
})

MainTab:CreateSection("Cài đặt thông số Gáy (Nape Extend)")

MainTab:CreateToggle({
    Name = "Nape Extend (Phóng to Hitbox)",
    CurrentValue = false,
    Flag = "extend_toggle",
    Callback = function(Value)
        napeExtendEnabled = Value
        if Value then
            notify("Nape Extend", "Đã bật phóng to gáy Titan!")
        else
            notify("Nape Extend", "Đã tắt.")
        end
    end,
})

-- Ô điền giá trị phóng to hitbox gáy tùy chỉnh
MainTab:CreateInput({
    Name = "Giá trị phóng to gáy (Nape Size Multiplier)",
    CurrentValue = "3",
    PlaceholderText = "Nhập số (Ví dụ: 3, 5, 8...)",
    RemoveTextAfterFocusLost = false,
    Flag = "nape_multiplier_input",
    Callback = function(Text)
        local num = tonumber(Text)
        if num and num > 0 then
            napeMultiplier = num
            notify("Cài đặt", "Đã cập nhật hệ số gáy thành: " .. num)
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

MainTab:CreateInput({
    Name = "Khoảng cách lùi sau (Safe Distance)",
    CurrentValue = "0",
    PlaceholderText = "Mặc định: 0",
    RemoveTextAfterFocusLost = false,
    Flag = "safe_distance_input",
    Callback = function(Text)
        local num = tonumber(Text)
        if num then safeDistance = num end
    end,
})

-- === TESTING TAB ===
TestingTab:CreateSection("Tính năng thử nghiệm")

TestingTab:CreateButton({
    Name = "TP To Refill",
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
            notify("Lỗi", "Không tìm thấy điểm nạp khí trên map!")
        end
    end,
})

-- === MISC TAB ===
MiscTab:CreateSection("Tính năng phụ")

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
 
