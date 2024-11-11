local cas = game:GetService("ContextActionService")
local rs = game:GetService("ReplicatedStorage")

local events = rs:WaitForChild("Events")
local hitboxevent = events:WaitForChild("Hitbox")


local plr = game.Players.LocalPlayer
local character = plr.Character or plr.CharacterAdded:Wait()
local hum = character:WaitForChild("Humanoid")
local animator = hum:WaitForChild("Animator")

local leftPunch = animator:LoadAnimation(script:WaitForChild("soco1"))
local rightPunch = animator:LoadAnimation(script:WaitForChild("soco2"))
local atk3 = animator:LoadAnimation(script:WaitForChild("atk3"))
local atk4 = animator:LoadAnimation(script:WaitForChild("atk4"))
local Uc = animator:LoadAnimation(script:WaitForChild("uc"))
local Dl = animator:LoadAnimation(script:WaitForChild("dl"))

local isuc = false

local currentPunch = 0 
local lastPunch = 0
local debounce = false

local function punch(actionName, inputState, inputObject)
	if debounce then return end
	if tick() - lastPunch > 1.5 then
		currentPunch = 1
	end
	--ataques
	debounce = true
	--UpperCut


	

	if currentPunch == 1 then
		leftPunch:Play()
		hitboxevent:FireServer(Vector3.new(3,3,3), Vector3.new(2), 10, 0.3)
		task.wait(0.4)
		debounce = false

	elseif currentPunch == 2 then
		rightPunch:Play()
		hitboxevent:FireServer(Vector3.new(3,3,3), Vector3.new(2), 10, 0.3)
		task.wait(0.8)

		debounce = false		
	elseif currentPunch == 3 then
		atk3:Play()
		hitboxevent:FireServer(Vector3.new(3,3,3), Vector3.new(2), 10, 0.3)
		task.wait(0.8)
		debounce = false

	elseif currentPunch == 4 then
		atk4:Play()
		hitboxevent:FireServer(Vector3.new(3,3,3), Vector3.new(2), 10, 0.3)
		task.wait(0.8)
		debounce = false

	end
	print(currentPunch)
	if currentPunch == 4 then
		currentPunch = 1
	else
		currentPunch += 1 

	end
	lastPunch = tick()
end

cas:BindAction("Punch", punch, true, Enum.UserInputType.MouseButton1)
