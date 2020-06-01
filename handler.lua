Handles = {

    Useful = {
        Timer = {}
    },

    Useless = {
        Timer = {}
    }

}


-- **Creates or use paused timer from Wseless.Timer table
-- @returns | timer
function NewTimer()
    local useless = Handles.Useless.Timer
    local timer

    if #useless > 0 then
        --msg("Use past timer")
        timer = useless[#useless]
        useless[#useless] = nil
    else
        --msg("Create New Timer")
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

            --msg("Timer with index :" .. i .. " was removed")
            useful[i] = last
            useful[#useful] = nil

            table.insert(Handles.Useless.Timer, uselessTimer)

            break
        end
    end
end