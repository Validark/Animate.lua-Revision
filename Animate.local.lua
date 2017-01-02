-- @author Validark
-- Animate.local.lua
-- This should be in a localscript called `Animate`
-- This should be placed in StarterPlayer.StarterCharacterScripts

-- Config
local JumpDuration = 0.3
local FallTransitionTime = 0.3

-- Helper
local Destroy = game.Destroy
local WaitForChild = game.WaitForChild

-- Random Seed
math.randomseed(tick())

-- Yield until Character Loads
local Character = script.Parent
local Torso = WaitForChild(Character, "Torso")
local Neck = WaitForChild(Torso, "Neck")
local LeftHip = WaitForChild(Torso, "Left Hip")
local Humanoid = WaitForChild(Character, "Humanoid")
local RightHip = WaitForChild(Torso, "Right Hip")
local LeftShoulder = WaitForChild(Torso, "Left Shoulder")
local RightShoulder = WaitForChild(Torso, "Right Shoulder")

-- Localize Functions
local newInstance = Instance.new
local random = math.random
local sine = math.sin

local LoadAnimation = Humanoid.LoadAnimation
local SetDesiredAngle = RightShoulder.SetDesiredAngle

local Climb, AnimationParent do
	local ClimbObject = newInstance("Animation", Character)
	ClimbObject.AnimationId = "rbxassetid://180436334"
	ClimbObject.Name = "Climb"

	Climb = LoadAnimation(Humanoid, ClimbObject) -- Create Animator Object to put stuff in
	AnimationParent = Humanoid.Animator
	ClimbObject.Parent = AnimationParent
end

-- AnimationTrack / RBXScriptSignal functions
local Play = Climb.Play
local Stop = Climb.Stop
local Destroy = Climb.Destroy
local Connect = Climb.KeyframeReached.Connect
local AdjustSpeed = Climb.AdjustSpeed

local function Disconnect(self)
	if self then
		Disconnect = self.Disconnect
		Disconnect(self)
	end
end

local function newAnimation(AnimationName, AnimationId)
	local Animation = newInstance("Animation")
	Animation.AnimationId = AnimationId
	Animation.Name = AnimationName
	Animation.Parent = AnimationParent
	return LoadAnimation(Humanoid, Animation)
end

-- Create Animation Instances
local Sit = newAnimation("Sit", "rbxassetid://178130996")
local Fall = newAnimation("Fall", "rbxassetid://180436148")
local Idle = newAnimation("Idle", "rbxassetid://180435571")
local Jump = newAnimation("Jump", "rbxassetid://125750702")
local Walk = newAnimation("Walk", "rbxassetid://180426354")
local IdleB = newAnimation("IdleB", "rbxassetid://180435792")

--[[ EMOTES
Cheer:   129423030
Laugh:   129423131
Point:   128853357
Wave:    128777973

Dance1:  182435998
Dance1B: 182491037
Dance1C: 182491065

Dance2:  182436842
Dance2B: 182491248
Dance2C: 182491277

Dance3:  182436935
Dance3B: 182491368
Dance3C: 182491423
--]]

-- Data
local Pose = "Standing"
local CurrentAnimationTrack = Idle
local CurrentAnimationStopped
local CurrentAnimationSpeed = 1
local JumpAnimationTime = 0

-- functions
local function SetAnimationSpeed(AnimationSpeed)
	if AnimationSpeed ~= CurrentAnimationSpeed then
		CurrentAnimationSpeed = AnimationSpeed
		AdjustSpeed(CurrentAnimationTrack, CurrentAnimationSpeed)
	end
end

local PlayAnimation

local function CurrentAnimationKeyFrameReached(KeyFrameName)
	if KeyFrameName == "End" then
		PlayAnimation(CurrentAnimationTrack, 0, CurrentAnimationSpeed)
	end
end

function PlayAnimation(Animation, TransitionDuration, AnimationSpeed)
	if Animation == Idle or Animation == IdleB then
		if random(1, 10) == 10 then
			Animation = IdleB
		else
			Animation = Idle
		end
	--[[elseif Animation == Dance1 then
		local random = random(1, 3)
		if random == 2 then
			Animation = Dance1B
		elseif random == 3 then
			Animation = Dance1C
		end
	elseif Animation == Dance2 then
		local random = random(1, 3)
		if random == 2 then
			Animation = Dance2B
		elseif random == 3 then
			Animation = Dance2C
		end
	elseif Animation == Dance3 then
		local random = random(1, 3)
		if random == 2 then
			Animation = Dance3B
		elseif random == 3 then
			Animation = Dance3C
		end--]]
	end

	-- switch animation
	if Animation ~= CurrentAnimationTrack then

		Disconnect(CurrentAnimationStopped)
		Stop(CurrentAnimationTrack, TransitionDuration)

		CurrentAnimationSpeed = AnimationSpeed or 1
		CurrentAnimationTrack = Animation

		if AnimationSpeed then
			CurrentAnimationSpeed = AnimationSpeed
			AdjustSpeed(Animation, AnimationSpeed)
		else
			CurrentAnimationSpeed = 1
		end

		Play(Animation, TransitionDuration)
		CurrentAnimationStopped = Connect(Animation.KeyframeReached, CurrentAnimationKeyFrameReached)
	end
end

-- Connect events
Connect(Humanoid.Died, function()
	Pose = "Dead"
end)

Connect(Humanoid.Running, function(AnimationSpeed)
	if AnimationSpeed > 0.25 then
		PlayAnimation(Walk, 0.1, AnimationSpeed / 14.5)
		Pose = "Running"
	else
		PlayAnimation(Idle, 0.1)
		Pose = "Standing"
	end
end)

Connect(Humanoid.Jumping, function()
	PlayAnimation(Jump, 0.1)
	JumpAnimationTime = JumpDuration
	Pose = "Jumping"
end)

Connect(Humanoid.Climbing, function(AnimationSpeed)
	PlayAnimation(Climb, 0.1, AnimationSpeed / 12)
	Pose = "Climbing"
end)

Connect(Humanoid.GettingUp, function()
	Pose = "GettingUp"
end)

Connect(Humanoid.FreeFalling, function()
	if JumpAnimationTime <= 0 then
		PlayAnimation(Fall, FallTransitionTime)
	end
	Pose = "FreeFall"
end)

Connect(Humanoid.FallingDown, function()
	Pose = "FallingDown"
end)

Connect(Humanoid.Seated, function()
	Pose = "Seated"
end)

Connect(Humanoid.PlatformStanding, function()
	Pose = "PlatformStanding"
end)

Connect(Humanoid.Swimming, function(AnimationSpeed)
	if AnimationSpeed > 0 then
		Pose = "Running"
	else
		Pose = "Standing"
	end
end)

Connect(game:GetService("RunService").Heartbeat, function(Delta)
  	if JumpAnimationTime > 0 then
  		JumpAnimationTime = JumpAnimationTime - Delta
  	end

	if Pose == "FreeFall" and JumpAnimationTime <= 0 then
		PlayAnimation(Fall, FallTransitionTime)
	elseif Pose == "Seated" then
		PlayAnimation(Sit, 0.5)
		return
	elseif Pose == "Running" then
		PlayAnimation(Walk, 0.1)
	elseif Pose == "Dead" or Pose == "GettingUp" or Pose == "FallingDown" or Pose == "Seated" or Pose == "PlatformStanding" then
		Disconnect(CurrentAnimationStopped)
		Stop(CurrentAnimationTrack)

		local DesiredAngle = 0.1 * sine(Delta)
		SetDesiredAngle(RightShoulder, DesiredAngle)
		SetDesiredAngle(LeftShoulder, DesiredAngle)
		SetDesiredAngle(RightHip, -DesiredAngle)
		SetDesiredAngle(LeftHip, -DesiredAngle)
	end
end)
