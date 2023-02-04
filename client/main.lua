
local Config = {
    bankLocations = {
        vector3(150.266, -1040.203, 29.374),
        vector3(-1212.98, -330.841, 37.787),
        vector3(-2962.582, 482.627, 15.703),
        vector3(-112.202, 6469.295, 31.626),
        vector3(314.187, -278.621, 54.17),
        vector3(-351.534, -49.529, 49.042),
        vector3(242.4029, 224.9785, 106.2868),
        vector3(1175.064, 2706.644, 38.09404),
        vector3(-1215.64, -332.231, 37.881),
        vector3(-2962.6, 482.1914, 15.762),
        vector3(149.4551, -1038.95, 29.366),
		vector3(603.5552, -19.1234, 87.4867),
        vector3(-56.5870, -1752.4254, 29.4210),
        vector3(33.2338, -1347.9851, 29.4970),
        vector3(288.6678, -1256.8976, 29.4408),
        vector3(-526.6167, -1222.8680, 18.4550),
        vector3(-717.3448, -915.6942, 19.2156),
        vector3(-32.4720, -1104.1029, 27.2744),
        vector3(1154.0688, -326.7711, 69.2051),
        vector3(380.9227, 323.6923, 103.5663),
        vector3(2558.1189, 389.4745, 108.6230),
        vector3(-1827.0155, 785.1615, 138.2973),
        vector3(-3026.5698, 70.3632, 12.9167),
        vector3(-3240.8787, 1008.6340, 12.8307),
        vector3(-1826.8573, 785.2188, 138.2937),
        vector3(540.3758, 2670.7603, 42.1565),
        vector3(2682.9565, 3286.5940, 55.2411),
        vector3(1968.0956, 3743.7012, 32.3437),
        vector3(1702.8596, 4933.2891, 42.0636),
        vector3(1735.3607, 6410.6558, 35.0372),
        vector3(1701.5686, 6426.3823, 32.6378),
        vector3(174.3109, 6637.6279, 31.5730),
        vector3(315.5064, -593.8942, 43.2840),
    },
    
    atmProps = {
        "prop_fleeca_atm",
        "prop_atm_01",
        "prop_atm_02",
        "prop_atm_03"
    }
}

ESX = nil

Citizen.CreateThread(function()
    while not ESX do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

        Citizen.Wait(500)
    end

    Citizen.Wait(500)

    TriggerServerEvent('empirex:banking:loadbank')
end)

--[[
local clientConfig = {
    bankLocations = {},
    atmLocations = {};
}
]]--

local clientData = {
    firstName,
    lastName, 
    cardNumber,
    walletAmount,
    cashAmount;
}

Citizen.CreateThread(function()
    for k,v in ipairs(Config.bankLocations) do
        local blip = AddBlipForCoord(v)

        SetBlipSprite(blip, 108);
        SetBlipDisplay(blip, 4);
        SetBlipScale(blip, 0.8);
        SetBlipColour(blip, 2);
        SetBlipAsShortRange(blip, true);
        SetBlipPriority(blip, 50000);
        
        BeginTextCommandSetBlipName("STRING");
        AddTextComponentString("Bank");
        EndTextCommandSetBlipName(blip);
    end
end)

-- Main Thread
Citizen.CreateThread(function()
    --TriggerServerEvent('empirex:banking:player:connected');
    while true do
        local playerPed = PlayerPedId();
        local pedCoords = GetEntityCoords(playerPed);

        for k, v in ipairs(Config.bankLocations) do 
            local dist = #(pedCoords - vector3(v.x, v.y, v.z))
            if dist <= 1.0 then                
                ESX.ShowHelpNotification('Drücken Sie mit ~INPUT_CONTEXT~ um ihr Konto zu verwalten.');
                
                if IsControlJustPressed(0, 38) then
                    SetNuiFocus(true, true);
                    SendNUIMessage({
                        syncData = clientData,
                        toggleMenu = true
                    });
                end
            end
        end
        
        Citizen.Wait(0);
    end
end);

local curPropCoords
local curPropEntity
local curdist = 30000000

Citizen.CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local c = GetEntityCoords(ped)
        for k, v in ipairs(Config.atmProps) do     
            local entity = GetClosestObjectOfType(c, 1.0, GetHashKey(v), false, false, false)
            local e = GetEntityCoords(entity)
            local dist = #(e - c)

            if dist <= curdist then
                curPropCoords = e
                curdist = dist
                curPropEntity = entity
            end
        end
        Citizen.Wait(800)
    end
end)

Citizen.CreateThread(function()
    --TriggerServerEvent('empirex:banking:player:connected');
    while true do
        local playerPed = PlayerPedId();
        local pedCoords = GetEntityCoords(playerPed);

        --for i = 1, #Config["atmProps"] do
            --local entity = GetClosestObjectOfType(pedCoords, 1.0, GetHashKey(Config["atmProps"][i]), false, false, false)
            --local entityCoords = GetEntityCoords(entity)
        if curPropCoords ~= nil then
            local dist = #(pedCoords - curPropCoords)

            if dist <= 5.0 then
                if DoesEntityExist(curPropEntity) then                  
                    -- ESX.ShowHelpNotification('Drücken Sie mit ~INPUT_CONTEXT~ um den ATM zu benutzen.');
                    DrawText3Ds(curPropCoords.x, curPropCoords.y,curPropCoords.z+1,'Drücken Sie ~g~E~s~ um den ATM zu benutzen.')
                    if dist <= 3.0 then   
                        if IsControlJustPressed(0, 38) then
                            SetNuiFocus(true, true);
                            SendNUIMessage({
                                syncData = clientData,
                                toggleMenu = true
                            });
                        end
                    end
                end
            elseif dist >= 5.0 and dist <= 20.0 then
                Citizen.Wait(300)
            elseif dist > 20.0 and dist <= 50.0 then
                Citizen.Wait(600)
            elseif dist > 50.0 then
                Citizen.Wait(1000)
            end
        else
            Citizen.Wait(800)
        end
        --end
        
        Citizen.Wait(0);
    end
end);

function DrawText3Ds(x, y, z, text)
	local onScreen,_x,_y=World3dToScreen2d(x,y,z)
	local scale = 0.4
	if onScreen then
		SetTextScale(scale, scale)
		SetTextFont(6)
		SetTextProportional(1)
		SetTextColour(255, 255, 255, 215)
		SetTextOutline()
		SetTextEntry('STRING')
		SetTextCentre(1)
		AddTextComponentString(text)
		DrawText(_x,_y)
	end
end

RegisterNUICallback('handleInteraction', function(data)
    TriggerServerEvent('empirex:banking:player:accounts:' .. data.interaction, data.amount);
end);

RegisterNUICallback('handleTransfer', function(data)
    TriggerServerEvent('empirex:banking:player:accounts:transfer', data.id, data.amount);
end);

RegisterNUICallback('toggleFocus', function()
    SetNuiFocus(false, false);
end);

RegisterNetEvent('empirex:banking:clientTransfer:clientData')
AddEventHandler('empirex:banking:clientTransfer:clientData', function(receivedData)
    clientData = receivedData;
end);

RegisterNetEvent('empirex:banking:clientTransfer:clientConfig')
AddEventHandler('empirex:banking:clientTransfer:clientConfig', function(receivedData)
    clientConfig = receivedData;
end);

