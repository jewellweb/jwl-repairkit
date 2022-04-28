--[[
           _______________________________________________
  ________|                 Jewell Scripts               |_______
  \       |              Developed by Zelensky#3162      |      /
   \      |          Discord: discord.gg/contralera      |     /
   /      |______________________________________________|     \
  /__________)                                        (_________\

]]--

local QBCore = exports['qb-core']:GetCoreObject()

-----------------REPAIR KISMI-------------------

QBCore.Functions.CreateUseableItem("fixkit", function(source, item)
	local _source = source
	local xPlayer = QBCore.Functions.GetPlayer(_source)
	TriggerClientEvent('jwl-repairkit:RepairVeh', _source)
end)

RegisterNetEvent('jwl-repairkit:removeKit')
AddEventHandler('jwl-repairkit:removeKit', function()
	local _source = source
	local xPlayer = QBCore.Functions.GetPlayer(_source)
	xPlayer.Functions.RemoveItem('fixkit', 1)
end)

-----------------TEMIZLIK KISMI-------------------

QBCore.Functions.CreateUseableItem("cleankit", function(source, item)
	local _source = source
	local xPlayer = QBCore.Functions.GetPlayer(_source)
	TriggerClientEvent('jwl-repairkit:CleanVeh', _source)
end)

RegisterNetEvent('jwl-repairkit:removeCKit')
AddEventHandler('jwl-repairkit:removeCKit', function()
	local _source = source
	local xPlayer = QBCore.Functions.GetPlayer(_source)
	xPlayer.Functions.RemoveItem('cleankit', 1)
end)