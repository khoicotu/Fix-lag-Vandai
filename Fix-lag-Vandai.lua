-- Script Fix Lag: Xóa Map, Giữ lại Thực thể & Tương tác
-- Lưu ý: Chỉ nên sử dụng ở Server thường hoặc bản Client Side

local function fixLagSailor()
    local workspace = game:GetService("Workspace")
    
    -- Danh sách các tên hoặc thuộc tính cần giữ lại
    -- Bạn có thể thêm tên các NPC hoặc Boss cụ thể vào đây nếu cần
    local keepKeywords = {"Boss", "NPC", "Mob", "Monster", "Teleport", "Portal", "Gate", "Quest"}

    for _, object in pairs(workspace:GetDescendants()) do
        -- Kiểm tra xem đối tượng có phải là Part hoặc Mesh không
        if object:IsA("BasePart") or object:IsA("MeshPart") or object:IsA("Model") then
            
            local shouldKeep = false
            
            -- 1. Giữ lại nếu là nhân vật của người chơi
            if object:FindFirstAncestorOfClass("Model") and object:FindFirstAncestorOfClass("Model"):FindFirstChild("Humanoid") then
                shouldKeep = true
            end
            
            -- 2. Kiểm tra tên đối tượng dựa trên danh sách từ khóa
            for _, keyword in pairs(keepKeywords) do
                if string.find(object.Name, keyword) or (object.Parent and string.find(object.Parent.Name, keyword)) then
                    shouldKeep = true
                    break
                end
            end
            
            -- 3. Giữ lại các vật phẩm có ProximityPrompt (thứ có thể tương tác)
            if object:FindFirstChildOfClass("ProximityPrompt") or object:FindFirstChild("ClickDetector") then
                shouldKeep = true
            end

            -- Nếu không thuộc diện giữ lại, tiến hành xóa hoặc làm tàng hình
            if not shouldKeep then
                -- Kiểm tra nếu là một phần của Map (thường không có Humanoid)
                if not object:FindFirstChild("Humanoid") then
                    object:Destroy() -- Xóa hoàn toàn để giải phóng RAM
                end
            end
        end
    end
    
    -- Tối ưu thêm Lighting
    local lighting = game:GetService("Lighting")
    lighting.GlobalShadows = false
    lighting.FogEnd = 9e9
    settings().Rendering.QualityLevel = 1
end

-- Chạy script
fixLagSailor()
print("Map đã được dọn dẹp! Chỉ còn lại Boss, NPC và Cổng dịch chuyển.")