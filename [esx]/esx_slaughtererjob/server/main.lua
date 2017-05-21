local PlayersHarvestingAliveChicken = {}
local PlayersSlaughteringChicken    = {}
local PlayersPackagingChicken       = {}
local PlayersReselling              = {}

RegisterServerEvent('esx_slaughtererjob:requestPlayerData')
AddEventHandler('esx_slaughtererjob:requestPlayerData', function(reason)
	TriggerEvent('esx:getPlayerFromId', source, function(xPlayer)
		TriggerEvent('esx_skin:requestPlayerSkinInfosCb', source, function(skin, jobSkin)

			local data = {
				job       = xPlayer.job,
				inventory = xPlayer.inventory,
				skin      = skin
			}

			TriggerClientEvent('esx_slaughtererjob:responsePlayerData', source, data, reason)
		end)
	end)
end)

local function HarvestAliveChicken(source)

	SetTimeout(3000, function()

		if PlayersHarvestingAliveChicken[source] == true then

			TriggerEvent('esx:getPlayerFromId', source, function(xPlayer)

				local aliveChickenQuantity = xPlayer:getInventoryItem('alive_chicken').count

				if aliveChickenQuantity >= 20 then
					TriggerClientEvent('esx:showNotification', source, 'Vous ne pouvez plus rammasser de poulet vivant')
				else
					
					xPlayer:addInventoryItem('alive_chicken', 1)
					HarvestAliveChicken(source)
				end

			end)

		end
	end)
end

RegisterServerEvent('esx_slaughtererjob:startHarvestAliveChicken')
AddEventHandler('esx_slaughtererjob:startHarvestAliveChicken', function()
	PlayersHarvestingAliveChicken[source] = true
	TriggerClientEvent('esx:showNotification', source, 'Ramassage en cours...')
	HarvestAliveChicken(source)
end)

RegisterServerEvent('esx_slaughtererjob:stopHarvestAliveChicken')
AddEventHandler('esx_slaughtererjob:stopHarvestAliveChicken', function()
	PlayersHarvestingAliveChicken[source] = false
end)

local function SlaughterChicken(source)

	SetTimeout(5000, function()

		if PlayersSlaughteringChicken[source] == true then

			TriggerEvent('esx:getPlayerFromId', source, function(xPlayer)

				local aliveChickenQuantity = xPlayer:getInventoryItem('alive_chicken').count

				if aliveChickenQuantity <= 0 then
					TriggerClientEvent('esx:showNotification', source, 'Vous n\'avez plus de poulet à abattre')
				else
					
					xPlayer:removeInventoryItem('alive_chicken', 1)
					xPlayer:addInventoryItem('slaughtered_chicken', 1)

					SlaughterChicken(source)
				end

			end)

		end
	end)
end

RegisterServerEvent('esx_slaughtererjob:startSlaughterChicken')
AddEventHandler('esx_slaughtererjob:startSlaughterChicken', function()
	PlayersSlaughteringChicken[source] = true
	TriggerClientEvent('esx:showNotification', source, 'Abattage en cours...')
	SlaughterChicken(source)
end)

RegisterServerEvent('esx_slaughtererjob:stopSlaughterChicken')
AddEventHandler('esx_slaughtererjob:stopSlaughterChicken', function()
	PlayersSlaughteringChicken[source] = false
end)

local function PackageChicken(source)

	SetTimeout(4000, function()

		if PlayersPackagingChicken[source] == true then

			TriggerEvent('esx:getPlayerFromId', source, function(xPlayer)

				local slaughteredChickenQuantity = xPlayer:getInventoryItem('slaughtered_chicken').count
				local packagedChickenQuantity    = xPlayer:getInventoryItem('packaged_chicken'   ).count

				if slaughteredChickenQuantity <= 0 then
					TriggerClientEvent('esx:showNotification', source, 'Vous n\'avez plus de poulet à conditonner')
				elseif packagedChickenQuantity >= 100 then
					TriggerClientEvent('esx:showNotification', source, 'Vous n\'avez plus de place pour du poulet en barquette')
				else
					
					xPlayer:removeInventoryItem('slaughtered_chicken', 1)
					xPlayer:addInventoryItem('packaged_chicken', 5)
					
					PackageChicken(source)
				end

			end)

		end
	end)
end

RegisterServerEvent('esx_slaughtererjob:startPackageChicken')
AddEventHandler('esx_slaughtererjob:startPackageChicken', function()
	PlayersPackagingChicken[source] = true
	TriggerClientEvent('esx:showNotification', source, 'Conditonnement en cours...')
	PackageChicken(source)
end)

RegisterServerEvent('esx_slaughtererjob:stopPackageChicken')
AddEventHandler('esx_slaughtererjob:stopPackageChicken', function()
	PlayersPackagingChicken[source] = false
end)

local function Resell(source)

	SetTimeout(500, function()

		if PlayersReselling[source] == true then

			TriggerEvent('esx:getPlayerFromId', source, function(xPlayer)

				local packagedChickenQuantity = xPlayer:getInventoryItem('packaged_chicken').count

				if packagedChickenQuantity <= 0 then
					TriggerClientEvent('esx:showNotification', source, 'Vous n\'avez plus de poulet à vendre')
				else
					
					xPlayer:removeInventoryItem('packaged_chicken', 1)
					xPlayer:addMoney(3)
					
					Resell(source)
				end

			end)

		end
	end)
end

RegisterServerEvent('esx_slaughtererjob:startResell')
AddEventHandler('esx_slaughtererjob:startResell', function()
	PlayersReselling[source] = true
	TriggerClientEvent('esx:showNotification', source, 'Vente en cours...')
	Resell(source)
end)

RegisterServerEvent('esx_slaughtererjob:stopResell')
AddEventHandler('esx_slaughtererjob:stopResell', function()
	PlayersReselling[source] = false
end)