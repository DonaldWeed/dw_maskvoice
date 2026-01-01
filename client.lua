-- dw_maskvoice
-- Voice distortion when wearing a mask
-- Author: donald weed
-- License: MIT

local maskSubmix = nil
local usingMaskVoice = false

-- Create audio submix
CreateThread(function()
    maskSubmix = CreateAudioSubmix("dw_maskvoice")

    SetAudioSubmixEffectRadioFx(maskSubmix, 0)
    SetAudioSubmixEffectParamInt(maskSubmix, 0, `default`, 1)
    SetAudioSubmixEffectParamFloat(maskSubmix, 0, `freq_low`, 100.0)
    SetAudioSubmixEffectParamFloat(maskSubmix, 0, `freq_hi`, 3000.0)

    AddAudioSubmixOutput(maskSubmix, 0)
end)

-- Check if player wears a mask (component 1)
local function isWearingMask()
    local ped = PlayerPedId()
    local drawable = GetPedDrawableVariation(ped, 1)
    return drawable ~= 0
end

-- Main loop
CreateThread(function()
    while true do
        Wait(500)

        local hasMask = isWearingMask()
        local myServerId = GetPlayerServerId(PlayerId())

        if hasMask and not usingMaskVoice then
            MumbleSetSubmixForServerId(myServerId, maskSubmix)
            usingMaskVoice = true

        elseif not hasMask and usingMaskVoice then
            MumbleSetSubmixForServerId(myServerId, -1)
            usingMaskVoice = false
        end
    end
end)

