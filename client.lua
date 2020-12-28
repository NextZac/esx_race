local racing = false
local epressed = false
local source = source
local timer = 0
local MARKER_SIZE = 5.0
local vehicle = GetVehiclePedIsUsing(player)
local Hud_color = {238, 198, 78, 255}

ESX								= nil
local PlayerData = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	Citizen.Wait(5000)
	PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer   
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)

function notify(msg)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(msg)
    DrawNotification(true,false)
end

function helpMessage(text, duration)
    BeginTextCommandDisplayHelp("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayHelp(0, false, true, duration or 5000)
end

RegisterNetEvent('esx:getjob')
AddEventHandler('esx:getjob', function(xPlayer)
  Citizen.Trace(tostring(PlayerData.job.name))
end)

RegisterCommand('test', function()
    local xPlayer = ESX.GetPlayerFromId(source)
        Citizen.Trace(tostring(xPlayer.getJob("name")))
    
end)

Citizen.CreateThread(function()
while true do
    Wait(0)
    DrawMarker(1, 3706.38, -6519.92, 2190.73 - 1.0, 0, 0, 0, 0, 0, 0, MARKER_SIZE, MARKER_SIZE, 1.0, 255, 165, 0, 96, 0, 0, 0, 0, 0, 0, 0)
        -- Check distance from map marker and draw text if close enough
                if GetDistanceBetweenCoords(3706.38, -6519.92, 2190.73, GetEntityCoords(GetPlayerPed(-1))) < 100.0 then
                    -- Draw race name
                    Draw3DText(3706.38, -6519.92, 2190.73-0.600, "Nurburgring Grand Prix", Hud_color, 4, 0.3, 0.3)
                end
                if GetDistanceBetweenCoords(3706.38, -6519.92, 2190.73, GetEntityCoords(GetPlayerPed(-1))) < MARKER_SIZE then
                    helpMessage("Press E to join Team 1")
                    if IsControlJustReleased(0, 182) then
                        TriggerEvent("esx:setJob", "team1")
                        notify("Changed Job!")
                    end
                    if IsControlJustReleased(0, 153) then
                        TriggerEvent("esx:setJob", "unemployed")
                        notify("Changed Job!")
                    end
                end
     
end
end)

function teleportToCoord(x, y, z, heading)
    Citizen.Wait(1)
    local player = GetPlayerPed(-1)
    if IsPedInAnyVehicle(player, true) then
        SetEntityCoords(GetVehiclePedIsUsing(player), x, y, z)
        Citizen.Wait(100)
        SetEntityHeading(GetVehiclePedIsUsing(player), heading)
    else
        SetEntityCoords(player, x, y, z)
        Citizen.Wait(100)
        SetEntityHeading(player, heading)
    end
end

function Draw3DText(x,y,z,textInput,colour,fontId,scaleX,scaleY)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)
    local scale = (1/dist)*20
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov

    SetTextScale(scaleX*scale, scaleY*scale)
    SetTextFont(fontId)
    SetTextProportional(1)
    local colourr,colourg,colourb,coloura = table.unpack(colour)
    SetTextColour(colourr,colourg,colourb, coloura)
    SetTextDropshadow(2, 1, 1, 1, 255)
    SetTextEdge(3, 0, 0, 0, 150)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(textInput)
    SetDrawOrigin(x,y,z+2, 0)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end
