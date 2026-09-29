local seated = false
local debugMode = Config.Debug

-- model hash -> name, so /sitdebug can say which chair you hit
local modelNames = {}
for _, name in ipairs(Config.Models) do
    modelNames[joaat(name)] = name
end

local overrides = {}
for name, data in pairs(Config.Overrides) do
    overrides[joaat(name)] = data
end

-- override z first, then the name patterns, then the default
local function getSeatHeight(model, ov)
    if ov.z then return ov.z end
    local name = modelNames[model]
    if name then
        for _, p in ipairs(Config.PatternHeights) do
            if name:find(p.pattern, 1, true) then return p.z end
        end
    end
    return Config.SeatHeight
end

local function seatTaken(seatPos)
    local myPed = PlayerPedId()
    for _, ped in ipairs(GetGamePool('CPed')) do
        if ped ~= myPed and #(GetEntityCoords(ped) - seatPos) < Config.OccupiedRadius then
            return true
        end
    end
    return false
end

local function standUp()
    seated = false
    lib.hideTextUI()
    ClearPedTasks(PlayerPedId())
end

local function sitOn(chair)
    if seated or not chair or not DoesEntityExist(chair) then return end
    local ped = PlayerPedId()
    if IsPedInAnyVehicle(ped, false) then return end

    local model    = GetEntityModel(chair)
    local coords   = GetEntityCoords(chair)
    local ov       = overrides[model] or {}
    local scenario = ov.scenario or Config.Scenario

    -- measure from the bottom of the model, origins are all over the place
    local seatHeight = getSeatHeight(model, ov)
    local min = GetModelDimensions(model)
    local seatZ = coords.z + min.z + seatHeight
    local seatPos = vec3(coords.x, coords.y, seatZ)
    local heading = (GetEntityHeading(chair) + (ov.heading or Config.HeadingFlip)) % 360.0

    if debugMode then
        local name = modelNames[model] or ('unknown (%s)'):format(model)
        print(('[rr-sitonchairs] model=%s seatHeight=%.2f seatZ=%.2f heading=%.1f'):format(name, seatHeight, seatZ, heading))
    end

    if seatTaken(seatPos) then
        lib.notify({ description = 'That seat is taken.', type = 'error' })
        return
    end

    TaskStartScenarioAtPosition(ped, scenario, seatPos.x, seatPos.y, seatPos.z, heading, 0, true, true)
    seated = true

    CreateThread(function()
        lib.showTextUI('[E] Stand up', { position = 'left-center', icon = 'chair' })
        Wait(1200) -- give the sit anim time to start

        while seated do
            Wait(0)
            local p = PlayerPedId()

            if IsControlJustReleased(0, Config.StandControl) then
                standUp()
                break
            end

            -- got knocked out of the seat some other way
            if IsPedDeadOrDying(p, true) or IsPedRagdoll(p)
                or IsPedInAnyVehicle(p, false) or not IsPedUsingScenario(p, scenario) then
                seated = false
                lib.hideTextUI()
                break
            end
        end
    end)
end

exports.ox_target:addModel(Config.Models, {
    {
        name     = 'rr_sitonchairs_sit',
        icon     = 'fa-solid fa-chair',
        label    = 'Sit Down',
        distance = Config.TargetDistance,
        canInteract = function()
            return not seated
        end,
        onSelect = function(data)
            sitOn(data.entity)
        end,
    },
})

RegisterCommand('sitdebug', function()
    debugMode = not debugMode
    lib.notify({ description = ('Sit debug %s'):format(debugMode and 'ON' or 'OFF'), type = 'inform' })
end, false)

AddEventHandler('onResourceStop', function(res)
    if res ~= GetCurrentResourceName() then return end
    if seated then
        lib.hideTextUI()
        ClearPedTasks(PlayerPedId())
    end
    exports.ox_target:removeModel(Config.Models, 'rr_sitonchairs_sit')
end)
