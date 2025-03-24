local car = script.Parent

local chasedPlayer = nil
local chasedPlayerHumanoidRootPart = nil

game:GetService("Players").PlayerAdded:Connect(function(player)
	print(player.Name .. " wchodzi do gry!")
	player.CharacterAdded:Connect(function(character)
		local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
		chasedPlayer = player
		chasedPlayerHumanoidRootPart = humanoidRootPart
	end)
end)

if not car.PrimaryPart then
	warn("Wybrany model samochodu nie ma PrimaryPart i skrypt nie zadziała!")
	return
end

local function onTouch(otherPart)
	local character = otherPart.Parent
	if character and character:FindFirstChild("Humanoid") then
		print("Samochód uderzył w gracza: " .. character.Name)
		character:FindFirstChild("Humanoid").Health = 0
	end
end

for _, part in ipairs(car:GetDescendants()) do
	if part:IsA("BasePart") then
		part.Touched:Connect(onTouch)
		part.CanCollide = true
	end
end

local RunService = game:GetService("RunService")
RunService.Heartbeat:Connect(function()
	if chasedPlayer and chasedPlayerHumanoidRootPart then
		local carPosition = car.PrimaryPart.Position
		local targetPosition = chasedPlayerHumanoidRootPart.Position

		local direction = (targetPosition - carPosition).Unit
		local speed = 0.3

		local lookAt = CFrame.lookAt(carPosition, Vector3.new(targetPosition.X, carPosition.Y, targetPosition.Z))
		local newPosition = carPosition + direction * speed

		car:SetPrimaryPartCFrame(lookAt + direction * speed)
	end
end)
