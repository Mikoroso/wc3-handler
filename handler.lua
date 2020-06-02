Handles = {

    MaxCounter = 40, -- How many useless object can be on each Handles.Useless."type"

    Useful = {
        Image = {},
        Timer = {},
        Group = {},
        Trigger = {}
    },

    Useless = {
        Image = {},
        Timer = {},
        Group = {},
        Trigger = {}
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

    },

    Create = {
        Image = function (i) 
            return BlzCreateSimpleFrame("NWU_SimpleImageFrame", fr.Parent, i)
        end,

        Text = function (i) 
            return BlzCreateSimpleFrame("NWU_SimpleStringFrame", fr.Parent, i)
        end
    },

    Modify = {
        Image = function (framedata,params)
            local frame = framedata[1]
            local id = framedata[2]
        
            table.insert(Handles.Useful.Image, framedata)
        
            ShowFrame           (frame)
            BlzFrameSetParent   (frame, fr.Parent)
            BlzFrameSetSize     (frame, params.width*0.0005, params.height*0.0005)
            BlzFrameSetXY       (frame, params.x, params.y)
            BlzFrameSetTexture  (BlzGetFrameByName("NWU_SimpleImageTexture",id), params.texture, 0, true)
            BlzFrameSetLevel    (frame, params.tier)
        
            return frame
        end,

        Text = function (framedata,params)
            local frame = framedata[1]
            local id = framedata[2]
            local textframe = BlzGetFrameByName("NWU_SimpleStringText",id)

            table.insert(Handles.Useful.Text, framedata)

            ShowFrame               (frame)
            BlzFrameSetParent       (frame, fr.Parent)
            BlzFrameClearAllPoints  (frame)
            BlzFrameSetSize         (frame, params.width*0.0005, params.height*0.0005)
            BlzFrameSetXY           (frame, params.x, params.y)
            BlzFrameSetLevel        (frame, params.tier)

            BlzFrameSetAllPoints    (textframe, frame)
            BlzFrameSetText         (textframe, params.text)
            BlzFrameSetFont         (textframe, "Font-AnimeAce.ttf", params.fontscale, 1)
            BlzFrameSetTextAlignment(textframe, TEXT_JUSTIFY_TOP,    params.align)

            return frame
        end
    }

}

function HideFrame  (frame)     BlzFrameSetVisible(frame, false) end
function ShowFrame  (frame)     BlzFrameSetVisible(frame, true) end
function SetFrameXY (frame,x,y) BlzFrameSetAbsPoint(frame, FRAMEPOINT_BOTTOM, x * 0.0005, y * 0.0005) end

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
        object = _G["Create" .. type]()
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


-- ************************************************
-- Used for get frame for future work
-- @params      | string with frame type(Image,Text,Button)
-- @params      | strings with groups accept for clean ex:("Dialog Part", "Heropick Part", ...)
function CleanFrame(type, ...)
    local t_useless = Handles.Useless[type]
    local t_useful = Handles.Useful[type]
    local length = #t_useful

    msg("Before Iterations, length = " .. length)
    for i = #t_useful, 1, -1 do
        local isUseless = false
        local framename = t_useful[i][3]
        
        msg("index = " .. i .. ", length = " .. #t_useful.. ", lengthless = " .. #t_useless)

        if framename ~= nil then msg(framename) end

        for k, value in ipairs({...}) do

            if framename == value then
                msg("its useless")
                isUseless = true

                break 
            end
        
        end

        
        if isUseless then

            (function ()
                local frame = t_useful[i][1]
                HideFrame           (frame)
                BlzFrameSetSize     (frame, 10*0.0005, 10*0.0005)
                BlzFrameSetAbsPoint (frame, FRAMEPOINT_BOTTOM, -2000*0.0005, 10*0.0005)
            end)()

            msg("Remove" .. framename)

            -- this
            table.insert(t_useless, t_useful[i]) 
 
            -- same as ???
            --t_useless:insert(t_useful[i])
            
            if i ~= #t_useful then
                local last = t_useful[#t_useful]
                t_useful[i] = last
            end

            t_useful[i] = nil

        end

    end

    msg("number of start elements" .. length)
end




-- ************************************************
-- Used for get frame for future work
-- @params      | string
-- @params      | string with group name
-- @params      | table with frame XYWH and another data
-- @returns     | frame
function NewFrame(type,name,frameparams)
    local useless = Handles.Useless[type]
    local useful = Handles.Useful[type]
    local t  
    local frame
    
    if #useless > 0 then
        msg("Use Useless Image")
        t = table.remove(useless)
    else
        msg("Creates New Image")
        local i = #useful + #useless + 1
        frame = Handles.Create[type](i)       --BlzCreateSimpleFrame("NWU_SimpleImageFrame", fr.Parent, i)

        t = {frame,i}    --Handles.Create[type]()

        msg("Creates New Image")
    end

    t[3] = name
    frame = Handles.Modify[type](t,frameparams)

    return frame
end