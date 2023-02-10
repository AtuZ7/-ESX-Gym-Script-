--------------------------SUPPORT----------------------------------------
-------------- https://discord.gg/fkM22XjMns ----------------------------
-------------------------------------------------------------------------
local isNearExersices = false
local isAtExersice = false
local isTraining = false

Citizen.CreateThread(function()

	if Config.EnableBlip then
		local blip = AddBlipForCoord( Config.MapBlip.Pos.x,  Config.MapBlip.Pos.y,  Config.MapBlip.Pos.z)
		SetBlipSprite (blip,  Config.MapBlip.Sprite)
		SetBlipDisplay(blip,  Config.MapBlip.Display)
		SetBlipScale  (blip,  Config.MapBlip.Scale)
		SetBlipColour (blip,  Config.MapBlip.Colour)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(Config.MapBlip.Name)
		EndTextCommandSetBlipName(blip)
	end

	while true do
		Citizen.Wait(350)
		local playerPed = PlayerPedId()
		local playerCoords = GetEntityCoords(GetPlayerPed(-1), false)

		isNearExersices = false
		isAtExersice = false
		lib.hideTextUI()

		for k, v in pairs(Config.Exersices) do
			local distance = Vdist(playerCoords, v.x, v.y, v.z)
			if distance < 20.0 then
				isNearExersices = true
			end
			if distance < 0.7 then
				isAtExersice = true
				currentExersice = v
			
			end
		end
		
	end
end)




Citizen.CreateThread(function()
	while true do
	  Citizen.Wait(0)
	  if isNearExersices then
  
		for k, v in pairs(Config.Exersices) do
  
		  DrawMarker(21, v.x, v.y, v.z, 0, 0, 0, 0, 0, 0, 0.301, 0.301, 0.3001, 0, 10, 10, 255, 0, 0, 0, 0)
		end
	  end
  
	  if isAtExersice then
		if not isTraining then
		  lib.showTextUI(Config.ExersiceString)
		else
		  --lib.showTextUI(Config.AbortString)
		end
  
		if IsControlJustReleased(0, Config.ExersiceKey) then
  
		  if not isTraining then
			if currentExersice.type == 'chins' then
			  SetEntityCoords(PlayerPedId(), currentExersice.fixedChinPos.x, currentExersice.fixedChinPos.y, currentExersice.fixedChinPos.z - 1)
			  SetEntityHeading(PlayerPedId(), currentExersice.fixedChinPos.rot)
			end
			isTraining = true
			TaskStartScenarioInPlace(PlayerPedId(), currentExersice.scenario, 0, true)
			if lib.progressBar({
			  duration = 10000,
			  label = 'Pumpad minna',
			  useWhileDead = false,
			  canCancel = false,
			  disable = {
				car = true,
				mouse = true,
				combat = true,
				move = true
			  }
			}) then
			  isTraining = false
			  ClearPedTasksImmediately(PlayerPedId())
			  ClearPedSecondaryTask(PlayerPedId())
			  lib.notify({
				title = 'Gym!',
				description = Config.FinishString,
				type = 'success'
			  })
			  exports["B1-skillz"]:UpdateSkill("Löögitugevus", 0.15)
			end
			
		  end
  
		end
	  end
	end
  end)
  



function ShowNotification(text)
	SetNotificationTextEntry('STRING')
    AddTextComponentString(text)
	DrawNotification(false, true)
end

function showInfobar(msg)

	CurrentActionMsg  = msg
	SetTextComponentFormat('STRING')
	AddTextComponentString(CurrentActionMsg)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)

end