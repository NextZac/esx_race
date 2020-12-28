ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx:serverjob')
AddEventHandler("esx:serverjob", function()
    TriggerClientEvent("esx:getjob", -1, xPlayer)
end)