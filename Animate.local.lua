-- @author Narrev
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

-- Data
local Pose = "Standing"
local Halfpi = 0.5 * math.pi
local CurrentAnimation = ""
local CurrentAnimationTrack
local CurrentAnimationStopped
local CurrentAnimationSpeed = 1

-- Localize Functions
local newInstance = Instance.new
local random = math.random
local sine = math.sin

local LoadAnimation = Humanoid.LoadAnimation
local SetDesiredAngle = RightShoulder.SetDesiredAngle

local Cheer, AnimationParent, Dance1, Dance2, Dance3 do
	local CheerObject = newInstance("Animation", Character)
	CheerObject.AnimationId = "rbxassetid://129423030"
	CheerObject.Name = "Cheer"

	Cheer = LoadAnimation(Humanoid, CheerObject) -- Create Animator Object to put stuff in
	AnimationParent = Humanoid.Animator
	CheerObject.Parent = AnimationParent

	local Dance1A = newInstance("Animation")
	Dance1A.AnimationId = "rbxassetid://182435998"
	Dance1A.Name = "Dance1A"
	Dance1A.Parent = AnimationParent

	local Dance1B = newInstance("Animation")
	Dance1B.AnimationId = "rbxassetid://182491037"
	Dance1B.Name = "Dance1B"
	Dance1B.Parent = AnimationParent

	local Dance1C = newInstance("Animation")
	Dance1C.AnimationId = "rbxassetid://182491065"
	Dance1C.Name = "Dance1C"
	Dance1C.Parent = AnimationParent

	local Dance2A = newInstance("Animation")
	Dance2A.AnimationId = "rbxassetid://182436842"
	Dance2A.Name = "Dance2A"
	Dance2A.Parent = AnimationParent

	local Dance2B = newInstance("Animation")
	Dance2B.AnimationId = "rbxassetid://182491248"
	Dance2B.Name = "Dance2B"
	Dance2B.Parent = AnimationParent

	local Dance2C = newInstance("Animation")
	Dance2C.AnimationId = "rbxassetid://182491277"
	Dance2C.Name = "Dance2C"
	Dance2C.Parent = AnimationParent

	local Dance3A = newInstance("Animation")
	Dance3A.AnimationId = "rbxassetid://182436935"
	Dance3A.Name = "Dance3A"
	Dance3A.Parent = AnimationParent

	local Dance3B = newInstance("Animation")
	Dance3B.AnimationId = "rbxassetid://182491368"
	Dance3B.Name = "Dance3B"
	Dance3B.Parent = AnimationParent

	local Dance3C = newInstance("Animation")
	Dance3C.AnimationId = "rbxassetid://182491423"
	Dance3C.Name = "Dance3C"
	Dance3C.Parent = AnimationParent

	Dance1 = {LoadAnimation(Humanoid, Dance1A), LoadAnimation(Humanoid, Dance1B), LoadAnimation(Humanoid, Dance1C)}
	Dance2 = {LoadAnimation(Humanoid, Dance2A), LoadAnimation(Humanoid, Dance2B), LoadAnimation(Humanoid, Dance2C)}
	Dance3 = {LoadAnimation(Humanoid, Dance3A), LoadAnimation(Humanoid, Dance3B), LoadAnimation(Humanoid, Dance3C)}
end

-- AnimationTrack / RBXScriptSignal functions
local Play = Cheer.Play
local Stop = Cheer.Stop
local Destroy = Cheer.Destroy
local Connect = Cheer.KeyframeReached.Connect
local AdjustSpeed = Cheer.AdjustSpeed

local function Disconnect(self)
	Disconnect = self.Disconnect
	Disconnect(self)
end

-- Create Animation Instances
local Climb = newInstance("Animation")
Climb.AnimationId = "rbxassetid://180436334"
Climb.Name = "Climb"
Climb.Parent = AnimationParent
Climb = LoadAnimation(Humanoid, Climb)

local Fall = newInstance("Animation")
Fall.AnimationId = "rbxassetid://180436148"
Fall.Name = "Fall"
Fall.Parent = AnimationParent
Fall = LoadAnimation(Humanoid, Fall)

local IdleA = newInstance("Animation")
IdleA.AnimationId = "rbxassetid://180435571"
IdleA.Name = "IdleA"
IdleA.Parent = AnimationParent
IdleA = LoadAnimation(Humanoid, IdleA)

local IdleB = newInstance("Animation")
IdleB.AnimationId = "rbxassetid://180435792"
IdleB.Name = "IdleB"
IdleB.Parent = AnimationParent
IdleB = LoadAnimation(Humanoid, IdleB)

local Jump = newInstance("Animation")
Jump.AnimationId = "rbxassetid://125750702"
Jump.Name = "Jump"
Jump.Parent = AnimationParent
Jump = LoadAnimation(Humanoid, Jump)

local Laugh = newInstance("Animation")
Laugh.AnimationId = "rbxassetid://129423131"
Laugh.Name = "Laugh"
Laugh.Parent = AnimationParent
Laugh = LoadAnimation(Humanoid, Laugh)

local Point = newInstance("Animation")
Point.AnimationId = "rbxassetid://128853357"
Point.Name = "Point"
Point.Parent = AnimationParent
Point = LoadAnimation(Humanoid, Point)

local Sit = newInstance("Animation")
Sit.AnimationId = "rbxassetid://178130996"
Sit.Name = "Sit"
Sit.Parent = AnimationParent
Sit = LoadAnimation(Humanoid, Sit)

local Walk = newInstance("Animation")
Walk.AnimationId = "rbxassetid://180426354"
Walk.Name = "Walk"
Walk.Parent = AnimationParent
Walk = LoadAnimation(Humanoid, Walk)

local Wave = newInstance("Animation")
Wave.AnimationId = "rbxassetid://128777973"
Wave.Name = "Wave"
Wave.Parent = AnimationParent
Wave = LoadAnimation(Humanoid, Wave)

local JumpAnimationTime = 0

-- Existance in this list signifies that it is an emote, the value indicates if it is a looping emote
local Emotes = {wave = false, point = false, dance1 = true, dance2 = true, dance3 = true, laugh = false, cheer = false}

-- functions
local function StopAllAnimations()
	local PreviousAnimation = CurrentAnimation
	CurrentAnimation = ""

	-- return to idle if finishing an emote
	if Emotes[PreviousAnimation] == false then
		PreviousAnimation = "idle"
	end

	if CurrentAnimationStopped then
		Disconnect(CurrentAnimationStopped)
	end

	if CurrentAnimationTrack then
		Stop(CurrentAnimationTrack)
		Destroy(CurrentAnimationTrack)
		CurrentAnimationTrack = nil
	end

	return PreviousAnimation
end

local function SetAnimationSpeed(AnimationSpeed)
	if AnimationSpeed ~= CurrentAnimationSpeed then
		CurrentAnimationSpeed = AnimationSpeed
		AdjustSpeed(CurrentAnimationTrack, CurrentAnimationSpeed)
	end
end

local PlayAnimation

local function CurrentAnimationKeyFrameReached(KeyFrameName)
	if KeyFrameName == "End" then
		-- return to idle if finishing an emote
		if Emotes[CurrentAnimation] == false then
			CurrentAnimation = "idle"
		end

		local AnimationSpeed = CurrentAnimationSpeed
		PlayAnimation(CurrentAnimation, 0)
		SetAnimationSpeed(AnimationSpeed)
	end
end

function PlayAnimation(AnimationName, TransitionDuration) -- TODO: Check by general AnimationName at the beginning
	local Animation
	if AnimationName == "walk" then
		Animation = Walk
	elseif AnimationName == "idle" then
		if random(1, 10) == 10 then
			Animation = IdleB
		else
			Animation = IdleA
		end
	elseif AnimationName == "climb" then
		Animation = Climb
	elseif AnimationName == "fall" then
		Animation = Fall
	elseif AnimationName == "jump" then
		Animation = Jump
	elseif AnimationName == "sit" then
		Animation = Sit
	elseif AnimationName == "cheer" then
		Animation = Cheer
	elseif AnimationName == "dance1" then
		Animation = Dance1[random(1, 3)]
	elseif AnimationName == "dance2" then
		Animation = Dance2[random(1, 3)]
	elseif AnimationName == "dance3" then
		Animation = Dance3[random(1, 3)]
	elseif AnimationName == "laugh" then
		Animation = Laugh
	elseif AnimationName == "point" then
		Animation = Point
	elseif AnimationName == "wave" then
		Animation = Wave
	end

	-- switch animation
	if Animation ~= CurrentAnimationTrack then

		-- set up keyframe Name triggers
		if CurrentAnimationStopped then
			Disconnect(CurrentAnimationStopped)
		end

		if CurrentAnimationTrack then
			Stop(CurrentAnimationTrack, TransitionDuration)
			Destroy(CurrentAnimationTrack)
		end

		CurrentAnimationSpeed = 1
		CurrentAnimationTrack = Animation

		-- play the animation
		Play(CurrentAnimationTrack, TransitionDuration)
		CurrentAnimation = AnimationName
		CurrentAnimationStopped = Connect(CurrentAnimationTrack.KeyframeReached, CurrentAnimationKeyFrameReached)
	end
end

-- Connect events
Connect(Humanoid.Died, function()
	Pose = "Dead"
end)

Connect(Humanoid.Running, function(AnimationSpeed)
	if AnimationSpeed > 0.01 then
		PlayAnimation("walk", 0.1)
		if CurrentAnimationTrack == Walk then
			SetAnimationSpeed(AnimationSpeed / 14.5)
		end
		Pose = "Running"
	else
		if Emotes[CurrentAnimation] == nil then
			PlayAnimation("idle", 0.1)
			Pose = "Standing"
		end
	end
end)

Connect(Humanoid.Jumping, function()
	PlayAnimation("jump", 0.1)
	JumpAnimationTime = JumpDuration
	Pose = "Jumping"
end)

Connect(Humanoid.Climbing, function(AnimationSpeed)
	PlayAnimation("climb", 0.1)
	SetAnimationSpeed(AnimationSpeed / 12)
	Pose = "Climbing"
end)

Connect(Humanoid.GettingUp, function()
	Pose = "GettingUp"
end)

Connect(Humanoid.FreeFalling, function()
	if JumpAnimationTime <= 0 then
		PlayAnimation("fall", FallTransitionTime)
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
		PlayAnimation("fall", FallTransitionTime)
	elseif Pose == "Seated" then
		PlayAnimation("sit", 0.5)
		return
	elseif Pose == "Running" then
		PlayAnimation("walk", 0.1)
	elseif Pose == "Dead" or Pose == "GettingUp" or Pose == "FallingDown" or Pose == "Seated" or Pose == "PlatformStanding" then
		StopAllAnimations()
		local DesiredAngle = 0.1 * sine(Delta)
		SetDesiredAngle(RightShoulder, DesiredAngle)
		SetDesiredAngle(LeftShoulder, DesiredAngle)
		SetDesiredAngle(RightHip, -DesiredAngle)
		SetDesiredAngle(LeftHip, -DesiredAngle)
	end
end)
