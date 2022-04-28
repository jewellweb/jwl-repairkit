--[[
           _______________________________________________
  ________|                 Jewell Scripts               |_______
  \       |              Developed by Zelensky#3162      |      /
   \      |          Discord: discord.gg/contralera      |     /
   /      |______________________________________________|     \
  /__________)                                        (_________\

]]--

local Keys = {
  ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
  ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
  ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
  ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
  ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
  ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
  ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
  ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
  ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local QBCore = exports['qb-core']:GetCoreObject()
local CurrentAction	= nil
local PlayerData = {}

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

-----------------REPAIR KISMI-------------------

RegisterNetEvent('jwl-repairkit:RepairVeh')
AddEventHandler('jwl-repairkit:RepairVeh', function()
	local playerPed	= GetPlayerPed(-1)
	local coords = GetEntityCoords(playerPed)

	if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 3.1) then
		local vehicle = nil

		if IsPedInAnyVehicle(playerPed, false) then
			vehicle = GetVehiclePedIsIn(playerPed, false)
		else
			vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 3.1, 0, 71)
		end

		if DoesEntityExist(vehicle) then
			if Config.IgnoreAbort then
				TriggerServerEvent('jwl-repairkit:removeKit')
			end
			TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_BUM_BIN", 0, true)
			QBCore.Functions.Progressbar("repair", "Araç Tamir Ediliyor..", 15000, false, true, {
				disableMovement = true,
				disableCarMovement = true,
				disableMouse = false,
				disableCombat = true,
			})

			Citizen.CreateThread(function()
				ThreadID = GetIdOfThisThread()
				CurrentAction = 'repair'

				Citizen.Wait(Config.RepairTime * 1000)

				if CurrentAction ~= nil then
					SetVehicleFixed(vehicle)
					SetVehicleDeformationFixed(vehicle)
					SetVehicleUndriveable(vehicle, false)
					SetVehicleEngineOn(vehicle, true, true)
					ClearPedTasksImmediately(playerPed)

					QBCore.Functions.Notify('Aracı tamir ettin..', 'success')
				end

				if not Config.IgnoreAbort then
					TriggerServerEvent('jwl-repairkit:removeKit')
				end

				CurrentAction = nil
				TerminateThisThread()
			end)
		end

		Citizen.CreateThread(function()
			Citizen.Wait(0)

			if CurrentAction ~= nil then
				if IsControlJustReleased(0, Keys["X"]) then
					TerminateThread(ThreadID)
					QBCore.Functions.Notify('Tamir iptal edildi!', 'error')
					CurrentAction = nil
				end
			end

		end)
	else
		QBCore.Functions.Notify('Yakında araç yok!', 'error')
	end
end)

-----------------TEMIZLIK KISMI-------------------

RegisterNetEvent('jwl-repairkit:CleanVeh')
AddEventHandler('jwl-repairkit:CleanVeh', function()
	local playerPed	= GetPlayerPed(-1)
	local coords = GetEntityCoords(playerPed)

	if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 3.1) then
		local vehicle = nil

		if IsPedInAnyVehicle(playerPed, false) then
			vehicle = GetVehiclePedIsIn(playerPed, false)
		else
			vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 3.1, 0, 71)
		end

		if DoesEntityExist(vehicle) then
			if Config.IgnoreAbort then
				TriggerServerEvent('jwl-repairkit:removeCKit')
			end
			TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_MAID_CLEAN", 0, true)
			QBCore.Functions.Progressbar("clean", "Araç Temizleniyor..", 10000, false, true, {
				disableMovement = true,
				disableCarMovement = true,
				disableMouse = false,
				disableCombat = true,
			})

			Citizen.CreateThread(function()
				ThreadID = GetIdOfThisThread()
				CurrentAction = 'clean'

				Citizen.Wait(Config.CleanTime * 1000)

				if CurrentAction ~= nil then
					SetVehicleDirtLevel(vehicle, 0)
					ClearPedTasksImmediately(playerPed)

					QBCore.Functions.Notify('Aracı temizledin..', 'success')
				end

				if not Config.IgnoreAbort then
					TriggerServerEvent('jwl-repairkit:removeCKit')
				end

				CurrentAction = nil
				TerminateThisThread()
			end)
		end

		Citizen.CreateThread(function()
			Citizen.Wait(0)

			if CurrentAction ~= nil then
				if IsControlJustReleased(0, Keys["X"]) then
					TerminateThread(ThreadID)
					QBCore.Functions.Notify('Temizlik iptal edildi!', 'error')
					CurrentAction = nil
				end
			end

		end)
	else
		QBCore.Functions.Notify('Yakında araç yok!', 'error')
	end
end)