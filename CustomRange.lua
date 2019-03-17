-----------------------------------
--- CustomRange.lua Version 0.2 ---
-----------------------------------

local CustomRange = {}

CustomRange.OptionEnable = Menu.AddOption({"mlambers", "Custom Range"}, "1. Enable", "Enable this script.")
CustomRange.OptionRadius = Menu.AddOption({"mlambers", "Custom Range"}, "2. Radius", "", 150, 1500, 50)

CustomRange.CurrentParticle = nil
CustomRange.NeedInit = nil

local MyHero = nil

function CustomRange.OnMenuOptionChange(option, old, new)
	if option == CustomRange.OptionEnable or option == CustomRange.OptionRadius then
		if Engine.IsInGame() == false then return end
		
		if CustomRange.CurrentParticle ~= 0 then
           Particle.Destroy(CustomRange.CurrentParticle)
		end
		
		CustomRange.CurrentParticle = 0
	end
end

function CustomRange.OnScriptLoad()
	CustomRange.CurrentParticle = 0
	MyHero = nil
	CustomRange.NeedInit = true
	
	Console.Print("[" .. os.date("%I:%M:%S %p") .. "] - - [ CustomRange.lua ] [ Version 0.2 ] Script load.")
end

function CustomRange.OnGameEnd()
	CustomRange.CurrentParticle = 0
	MyHero = nil
	CustomRange.NeedInit = true
	
	collectgarbage("collect")
	
	Console.Print("[" .. os.date("%I:%M:%S %p") .. "] - - [ CustomRange.lua ] [ Version 0.2 ] Game end. Reset all variable.")
end
	
function CustomRange.OnDraw()
	if Menu.IsEnabled(CustomRange.OptionEnable) == false then return end
	if Engine.IsInGame() == false then return end
	if (GameRules.GetGameState() < 4) or (GameRules.GetGameState() > 5) then return end
	
	MyHero = Heroes.GetLocal()
	if MyHero == nil then return end
	
	if CustomRange.NeedInit == true then	
		CustomRange.CurrentParticle = 0
		CustomRange.NeedInit = false
		
		Console.Print("[" .. os.date("%I:%M:%S %p") .. "] - - [ CustomRange.lua ] [ Version 0.2 ] Game started, init script done.")
	end
	
	if Entity.IsAlive(MyHero) then
		if CustomRange.CurrentParticle == 0 then
			local RangeParticle = Particle.Create("particles/ui_mouseactions/range_display.vpcf", Enum.ParticleAttachment.PATTACH_ABSORIGIN_FOLLOW, MyHero)
			CustomRange.CurrentParticle = RangeParticle
			
			Particle.SetControlPoint(CustomRange.CurrentParticle, 0, Entity.GetAbsOrigin(MyHero))
			Particle.SetControlPoint(CustomRange.CurrentParticle, 1, Vector(Menu.GetValue(CustomRange.OptionRadius), 1, 1))
		end
	else
		if CustomRange.CurrentParticle ~= 0 then
           Particle.Destroy(CustomRange.CurrentParticle)
		end
		
		CustomRange.CurrentParticle = 0
		--collectgarbage("collect")
	end
end

return CustomRange