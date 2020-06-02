Handles = {

    MaxCounter = 40,

    Useful = {
        Timer = {}
    },

    Useless = {
        Timer = {}
    }



}

function msg(text) DisplayTimedTextToForce(GetPlayersAll(), 5., text) end

function CreateObject(text) 
    local func = "Create" .. text
    return func()
end

CreateObject(Group)



-- **Creates or use paused timer from Wseless.Timer table
-- @returns | timer
function NewTimer()
    local useless = Handles.Useless.Timer
    local timer

    if #useless > 0 then
        -- msg("Use past timer")
        timer = useless[#useless]
        useless[#useless] = nil
    else
        -- msg("Create New Timer")
        timer = CreateTimer()
    end

    table.insert(Handles.Useful.Timer,timer)

    return timer
end

-- **Pause and Replace timer to Useless
-- @params  | target timer
function CleanTimer(timer)
    local useful = Handles.Useful.Timer

    PauseTimer(timer)

    for i = 1, #useful do

        if timer == useful[i] then

            local last = useful[#useful]
            local uselessTimer = useful[i]

            -- msg("Timer with index :" .. i .. " was removed")
            useful[i] = last
            useful[#useful] = nil

            if #Handles.Useless.Timer <= Handles.MaxCounter then
                table.insert(Handles.Useless.Timer, uselessTimer)
            else 
                DestroyTimer(timer) 
            end

            break

        end
    end
end



-- **Creates or use cleaned group from Wseless.Timer table
-- @returns | group
function NewGroup(objtype)
    --local useless = Handles.Useless
    --local useful = Handles.Useful

    --useless = useless[objtype]
    --useful = useful[objtype]




    local useless = Handles.Useless.Group
    local object

    if #useless > 0 then
        -- msg("Use past timer")
        object = useless[#useless]
        useless[#useless] = nil
    else
        -- msg("Create New Timer")
        object = CreateGroup()
    end

    table.insert(Handles.Useful.Group,object)

    return object
end

-- **Clean and Replace group to Useless
-- @params | target group
function CleanGroup(object)
    local useful = Handles.Useful.Group

    CleanGroup(object)

    for i = 1, #useful do

        if object == useful[i] then

            local last = useful[#useful]
            local uselessObject = useful[i]

            -- msg("Timer with index :" .. i .. " was removed")
            useful[i] = last
            useful[#useful] = nil

            if #Handles.Useless.Group <= Handles.MaxCounter then
                table.insert(Handles.Useless.Group, uselessObject)
            else 
                DestroyGroup(object) 
            end

            break

        end
    end
end