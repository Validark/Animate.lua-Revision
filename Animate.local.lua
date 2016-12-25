-- @author Narrev
-- Rescripted!

-- Config
local JumpDuration = 0.3
local FallTransitionTime = 0.3

-- Localize Functions
local WaitForChild = game.WaitForChild

-- Wait For Character To Load
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
local CurrentAnimInstance
local CurrentAnimationStopped
local CurrentAnimationSpeed = 1

local AnimationParent = Instance.new("Folder")
AnimationParent.Name = "Animations"

local Cheer = Instance.new("Animation", AnimationParent)
Cheer.AnimationId = "rbxassetid://129423030"
Cheer.Name = "Cheer"

local Climb = Instance.new("Animation", AnimationParent)
Climb.AnimationId = "rbxassetid://180436334"
Climb.Name = "Climb"

local Dance1A = Instance.new("Animation", AnimationParent)
Dance1A.AnimationId = "rbxassetid://182435998"
Dance1A.Name = "Dance1A"

local Dance1B = Instance.new("Animation", AnimationParent)
Dance1B.AnimationId = "rbxassetid://182491037"
Dance1B.Name = "Dance1B"

local Dance1C = Instance.new("Animation", AnimationParent)
Dance1C.AnimationId = "rbxassetid://182491065"
Dance1C.Name = "Dance1C"

local Dance2A = Instance.new("Animation", AnimationParent)
Dance2A.AnimationId = "rbxassetid://182436842"
Dance2A.Name = "Dance2A"

local Dance2B = Instance.new("Animation", AnimationParent)
Dance2B.AnimationId = "rbxassetid://182491248"
Dance2B.Name = "Dance2B"

local Dance2C = Instance.new("Animation", AnimationParent)
Dance2C.AnimationId = "rbxassetid://182491277"
Dance2C.Name = "Dance2C"

local Dance3A = Instance.new("Animation", AnimationParent)
Dance3A.AnimationId = "rbxassetid://182436935"
Dance3A.Name = "Dance3A"

local Dance3B = Instance.new("Animation", AnimationParent)
Dance3B.AnimationId = "rbxassetid://182491368"
Dance3B.Name = "Dance3B"

local Dance3C = Instance.new("Animation", AnimationParent)
Dance3C.AnimationId = "rbxassetid://182491423"
Dance3C.Name = "Dance3C"

local Fall = Instance.new("Animation", AnimationParent)
Fall.AnimationId = "rbxassetid://180436148"
Fall.Name = "Fall"

local IdleA = Instance.new("Animation", AnimationParent)
IdleA.AnimationId = "rbxassetid://180435571"
IdleA.Name = "IdleA"

local IdleB = Instance.new("Animation", AnimationParent)
IdleB.AnimationId = "rbxassetid://180435792"
IdleB.Name = "IdleB"

local Jump = Instance.new("Animation", AnimationParent)
Jump.AnimationId = "rbxassetid://125750702"
Jump.Name = "Jump"

local Laugh = Instance.new("Animation", AnimationParent)
Laugh.AnimationId = "rbxassetid://129423131"
Laugh.Name = "Laugh"

local Point = Instance.new("Animation", AnimationParent)
Point.AnimationId = "rbxassetid://128853357"
Point.Name = "Point"

local Run = Instance.new("Animation", AnimationParent)
Run.AnimationId = "run.xml"
Run.Name = "Run"

local Sit = Instance.new("Animation", AnimationParent)
Sit.AnimationId = "rbxassetid://178130996"
Sit.Name = "Sit"

local Walk = Instance.new("Animation", AnimationParent)
Walk.AnimationId = "rbxassetid://180426354"
Walk.Name = "Walk"

local Wave = Instance.new("Animation", AnimationParent)
Wave.AnimationId = "rbxassetid://128777973"
Wave.Name = "Wave"

AnimationParent.Parent = Character

local Animations = {
	cheer = {
		{
			AnimationObject = Cheer;
			Weight = 10
		};
		Connections = {};
		TotalWeight = 10
	};

	climb = {
		{
			AnimationObject = Climb;
			Weight = 10
		};
		Connections = {};
		TotalWeight = 10
	};

	dance1 = {
		{
			AnimationObject = Dance1A;
			Weight = 10
		};
		{
			AnimationObject = Dance1B;
			Weight = 10
		};
		{
			AnimationObject = Dance1C;
			Weight = 10
		};
		Connections = {};
		TotalWeight = 30
	};

	dance2 = {
		{
			AnimationObject = Dance2A;
			Weight = 10
		};
		{
			AnimationObject = Dance2B;
			Weight = 10
		};
		{
			AnimationObject = Dance2C;
			Weight = 10
		};
		Connections = {};
		TotalWeight = 30
	};

	dance3 = {
		{
			AnimationObject = Dance3A;
			Weight = 10
		};
		{
			AnimationObject = Dance3B;
			Weight = 10
		};
		{
			AnimationObject = Dance3C;
			Weight = 10
		};
		Connections = {};
		TotalWeight = 30
	};

	fall = {
		{
			AnimationObject = Fall;
			Weight = 10
		};
		Connections = {};
		TotalWeight = 10
	};

	idle = {
		{
			AnimationObject = IdleA;
			Weight = 9
		};
		{
			AnimationObject = IdleB;
			Weight = 1
		};
		Connections = {};
		TotalWeight = 10
	};

	jump = {
		{
			AnimationObject = Jump;
			Weight = 10
		};
		Connections = {};
		TotalWeight = 10
	};

	laugh = {
		{
			AnimationObject = Laugh;
			Weight = 10
		};
		Connections = {};
		TotalWeight = 10
	};

	point = {
		{
			AnimationObject = Point;
			Weight = 10
		};
		Connections = {};
		TotalWeight = 10
	};

	run = {
		{
			AnimationObject = Run;
			Weight = 10
		};
		Connections = {};
		TotalWeight = 10
	};

	sit = {
		{
			AnimationObject = Sit;
			Weight = 10
		};
		Connections = {};
		TotalWeight = 10
	};

	walk = {
		{
			AnimationObject = Walk;
			Weight = 10
		};
		Connections = {};
		TotalWeight = 10
	};

	wave = {
		{
			AnimationObject = Wave;
			Weight = 10
		};
		Connections = {};
		TotalWeight = 10
	};
}

local dances = {
	"dance1";
	"dance2";
	"dance3";
}

local JumpAnimationTime = 0

-- Existance in this list signifies that it is an emote, the value indicates if it is a looping emote
local Emotes = {wave = false, point = false, dance1 = true, dance2 = true, dance3 = true, laugh = false, cheer = false}

-- ANIMATION

-- functions
function StopAllAnimations()
	local PreviousAnimation = CurrentAnimation
	CurrentAnimation = ""
	CurrentAnimInstance = nil

	-- return to idle if finishing an emote
	if Emotes[PreviousAnimation] == false then
		PreviousAnimation = "idle"
	end
	
	if CurrentAnimationStopped then
		CurrentAnimationStopped:Disconnect()
	end

	if CurrentAnimationTrack then
		CurrentAnimationTrack:Stop()
		CurrentAnimationTrack:Destroy()
		CurrentAnimationTrack = nil
	end
	
	return PreviousAnimation
end

function SetAnimationSpeed(AnimationSpeed)
	if AnimationSpeed ~= CurrentAnimationSpeed then
		CurrentAnimationSpeed = AnimationSpeed
		CurrentAnimationTrack:AdjustSpeed(CurrentAnimationSpeed)
	end
end

function CurrentAnimationTrackStopped()
	-- return to idle if finishing an emote
	if Emotes[CurrentAnimation] == false then
		CurrentAnimation = "idle"
	end

	local AnimationSpeed = CurrentAnimationSpeed
	PlayAnimation(CurrentAnimation, 0)
	SetAnimationSpeed(AnimationSpeed)
end

-- Preload animations
function PlayAnimation(AnimationName, TransitionDuration)

	local Animation = Animations[AnimationName]
	local NumAnimations = #Animation
	local AnimationObject
	
	if NumAnimations > 1 then
		local index = math.random(1, Animation.TotalWeight)

		for a = 1, NumAnimations do
			index = index - Animation[a].Weight
			if index <= 0 then
				AnimationObject = Animation[a].AnimationObject
				break
			end
		end
	else
		AnimationObject = Animation[1].AnimationObject
	end
	
	-- switch animation
	if AnimationObject ~= CurrentAnimInstance then

		-- set up keyframe Name triggers
		if CurrentAnimationStopped then
			CurrentAnimationStopped:Disconnect()
		end

		if CurrentAnimationTrack then
			CurrentAnimationTrack:Stop(TransitionDuration)
			CurrentAnimationTrack:Destroy()
		end

		CurrentAnimationSpeed = 1

		-- load it to the Humanoid; get AnimationTrack
		CurrentAnimationTrack = Humanoid:LoadAnimation(AnimationObject)

		-- play the animation
		CurrentAnimationTrack:Play(TransitionDuration)
		CurrentAnimation = AnimationName
		CurrentAnimInstance = AnimationObject
		
		CurrentAnimationStopped = CurrentAnimationTrack.Stopped:Connect(CurrentAnimationTrackStopped)
	end
end

-- Connect events
Humanoid.Died:Connect(function()
	Pose = "Dead"
end)

Humanoid.Running:Connect(function(speed)
	if speed > 0.01 then
		PlayAnimation("walk", 0.1)
		if CurrentAnimInstance == Walk then
			SetAnimationSpeed(speed / 14.5)
		end
		Pose = "Running"
	else
		if Emotes[CurrentAnimation] == nil then
			PlayAnimation("idle", 0.1)
			Pose = "Standing"
		end
	end
end)

Humanoid.Jumping:Connect(function()
	PlayAnimation("jump", 0.1)
	JumpAnimationTime = JumpDuration
	Pose = "Jumping"
end)

Humanoid.Climbing:Connect(function(speed)
	PlayAnimation("climb", 0.1)
	SetAnimationSpeed(speed / 12)
	Pose = "Climbing"
end)

Humanoid.GettingUp:Connect(function()
	Pose = "GettingUp"
end)

Humanoid.FreeFalling:Connect(function()
	if JumpAnimationTime <= 0 then
		PlayAnimation("fall", FallTransitionTime)
	end
	Pose = "FreeFall"
end)

Humanoid.FallingDown:Connect(function()
	Pose = "FallingDown"
end)

Humanoid.Seated:Connect(function()
	Pose = "Seated"
end)

Humanoid.PlatformStanding:Connect(function()
	Pose = "PlatformStanding"
end)

Humanoid.Swimming:Connect(function(speed)
	if speed > 0 then
		Pose = "Running"
	else
		Pose = "Standing"
	end
end)

local RunService = game:GetService("RunService")

RunService.Heartbeat:Connect(function(step)
  	if JumpAnimationTime > 0 then
  		JumpAnimationTime = JumpAnimationTime - step
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
		local DesiredAngle = 0.1 * math.sin(step)
		RightShoulder:SetDesiredAngle(DesiredAngle)
		LeftShoulder:SetDesiredAngle(DesiredAngle)
		RightHip:SetDesiredAngle(-DesiredAngle)
		LeftHip:SetDesiredAngle(-DesiredAngle)
	end
end)

-- initialize to idle
PlayAnimation("idle", 0.1)
Pose = "Standing"
