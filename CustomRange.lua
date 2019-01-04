local CustomRange = {}

CustomRange.OptionEnable = Menu.AddOption({"mlambers", "Custom Range"}, "1. Enable", "Enable this script.")
CustomRange.OptionRadius = Menu.AddOption({"mlambers", "Custom Range"}, "2. Radius", "", 150, 1500, 50)

CustomRange.CurrentParticle = nil
--CustomRange.TickUpdate = nil
CustomRange.NeedInit = nil

local MyHero = nil
--local MyPos = nil

function CustomRange.OnMenuOptionChange(option, old, new)
	if option == CustomRange.OptionEnable or option == CustomRange.OptionRadius then
		if Engine.IsInGame() == false then return end
		
		if CustomRange.CurrentParticle ~= 0 then
           Particle.Destroy(CustomRange.CurrentParticle)
		end
		
		CustomRange.CurrentParticle = 0
		--collectgarbage("collect")
		--CustomRange.TickUpdate = 0
	end
end

function CustomRange.OnScriptLoad()
	CustomRange.CurrentParticle = 0
	--CustomRange.TickUpdate = 0
	
	MyHero = nil
	--MyPos = nil
	CustomRange.NeedInit = true
end

function CustomRange.OnGameStart()
	CustomRange.CurrentParticle = 0
	--CustomRange.TickUpdate = 0
	
	if MyHero == nil then
		MyHero = Heroes.GetLocal()
	end
	--MyPos = nil
	
	CustomRange.NeedInit = false
end

function CustomRange.OnGameEnd()
	CustomRange.CurrentParticle = 0
	CustomRange.TickUpdate = 0
	
	MyHero = nil
	MyPos = nil
	
	CustomRange.NeedInit = true
	
	collectgarbage("collect")
end
	
function CustomRange.OnDraw()
	if Engine.IsInGame() == false then return end
	if Menu.IsEnabled(CustomRange.OptionEnable) == false then return end
	if GameRules.GetGameState() < 4 then return end
	if GameRules.GetGameState() > 5 then return end
	
	if CustomRange.NeedInit == true then	
		CustomRange.CurrentParticle = 0
		CustomRange.TickUpdate = 0
		
		if MyHero == nil then
			MyHero = Heroes.GetLocal()
		end
		MyPos = nil
		
		CustomRange.NeedInit = false
	end
	
	if MyHero == nil then return end

	if Entity.IsAlive(MyHero) then
		--MyPos = Entity.GetAbsOrigin(MyHero)
		if CustomRange.CurrentParticle == 0 then
			local RangeParticle = Particle.Create("particles/ui_mouseactions/range_display.vpcf", Enum.ParticleAttachment.PATTACH_ABSORIGIN_FOLLOW, MyHero)
			CustomRange.CurrentParticle = RangeParticle
			
			Particle.SetControlPoint(CustomRange.CurrentParticle, 0, Entity.GetAbsOrigin(MyHero))
			Particle.SetControlPoint(CustomRange.CurrentParticle, 1, Vector(Menu.GetValue(CustomRange.OptionRadius), 0, 0))
		end
		
		--if CustomRange.TickUpdate < os.clock() then
		--	Particle.SetControlPoint(CustomRange.CurrentParticle, 0, Entity.GetAbsOrigin(MyHero))
		--	Particle.SetControlPoint(CustomRange.CurrentParticle, 1, Vector(Menu.GetValue(CustomRange.OptionRadius), 0, 0))
			
		--	CustomRange.TickUpdate = os.clock() + 1
		--end
		
	else
		if CustomRange.CurrentParticle ~= 0 then
           Particle.Destroy(CustomRange.CurrentParticle)
		end
		
		CustomRange.CurrentParticle = 0
		collectgarbage("collect")
		--CustomRange.TickUpdate = 0
	end
end

return CustomRange