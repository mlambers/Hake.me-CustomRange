-----------------------------------
--- CustomRange.lua Version 0.3 ---
-----------------------------------

local CustomRange = {}

CustomRange.OptionEnable = Menu.AddOption({"mlambers", "Custom Range"}, "1. Enable", "Enable this script.")
CustomRange.OptionRadius = Menu.AddOption({"mlambers", "Custom Range"}, "2. Radius", "", 100, 2000, 25)

local MyHero = nil
local MyPlayerId = nil
CustomRange.CurrentParticle = nil

function CustomRange.OnScriptLoad()
	MyHero = nil
    MyPlayerId = nil
	CustomRange.CurrentParticle = nil
    
	Console.Print("[" .. os.date("%I:%M:%S %p") .. "] - - [ CustomRange.lua ] [ Version 0.3 ] Script load.")
end

function CustomRange.OnMenuOptionChange(option, old, new)
    if Engine.IsInGame() == false then return end
    if MyHero == nil then return end
	
    if option == CustomRange.OptionEnable then
        if old ~= 1 then return end
        
        MyHero = nil
        MyPlayerId = nil
    end
    
    if CustomRange.CurrentParticle ~= 0 then
        Particle.Destroy(CustomRange.CurrentParticle)
        collectgarbage("collect")
    end
    
    CustomRange.CurrentParticle = 0
end

--[[
    Handle hero dead and denied.
--]]
function CustomRange.OnChatEvent(chatEvent)
    if Menu.IsEnabled(CustomRange.OptionEnable) == false then return end
    if chatEvent.type < 0 or chatEvent.type > 1 then return end
    if chatEvent.players[1] ~= MyPlayerId then return end
    
    if CustomRange.CurrentParticle ~= 0 then
        Particle.Destroy(CustomRange.CurrentParticle)
        CustomRange.CurrentParticle = 0
        collectgarbage("collect")
    end
end

function CustomRange.OnUpdate()
    
    if Menu.IsEnabled(CustomRange.OptionEnable) == false then return end
    
    if MyHero == nil or MyHero ~= Heroes.GetLocal() then
        MyHero = Heroes.GetLocal()
        MyPlayerId = Player.GetPlayerID(Players.GetLocal())
        CustomRange.CurrentParticle = 0
        
        return
    end
    
    if Entity.IsAlive(MyHero) == false then return end
    
    if CustomRange.CurrentParticle == 0 then
		local RangeParticle = Particle.Create("particles/ui_mouseactions/range_display.vpcf", Enum.ParticleAttachment.PATTACH_ABSORIGIN_FOLLOW, MyHero)
		CustomRange.CurrentParticle = RangeParticle
			
		Particle.SetControlPoint(CustomRange.CurrentParticle, 0, Entity.GetAbsOrigin(MyHero))
		Particle.SetControlPoint(CustomRange.CurrentParticle, 1, Vector(Menu.GetValue(CustomRange.OptionRadius), 1, 1))
	end
end

return CustomRange