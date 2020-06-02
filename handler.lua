Handles = {

    MaxCounter = 40, -- How many useless object can be on each Handles.Useless."type"

    Useful = {
        Timer = {}
    },

    Useless = {
        Timer = {}
    },

    Clean = {

        Timer = function (timer)
            PauseTimer(timer)
        end,

        Group = function (group)
            GroupClear(group)
        end,

        Trigger = function (trig)
            TriggerClearActions(trig)
        end

    }

}

-- **Creates or use useless object from Handles.Useless table
-- @params | object type
-- @returns | object
function New(type)
    local useless = Handles.Useless[type]
    local useful = Handles.Useful[type]
    local object

    if #useless > 0 then
        -- msg("Launch Useless " .. type)
        object = useless[#useless]
        useless[#useless] = nil
    else
        -- msg("Create New Timer")
        object = loadstring("Create" .. type)()
    end

    table.insert(useful,object)

    return object
end


-- **Clean and Replave/Remove handle
-- @params | object type
-- @params | object
function Clean(type,object)
    local useless = Handles.Useless[type]
    local useful = Handles.Useful[type]

    Handles.Clean[type](object)

    for i = 1, #useful do

        if object == useful[i] then

            local last = useful[#useful]
            local uselessObj = useful[i]

            -- msg("Timer with index :" .. i .. " was removed")
            useful[i] = last
            useful[#useful] = nil

            if #useless <= Handles.MaxCounter then
                table.insert(useless, uselessObj)
            else 
                Handles.Clean[type](object)
            end

            break

        end
    end
end