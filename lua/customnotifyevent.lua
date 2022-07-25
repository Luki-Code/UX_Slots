

RegisterNUICallback("CustomNotifyEvent", function(data)
    local title = data.notificationTitle --dont change
    local message = data.notificationMessage --dont change
    TriggerEvent("yourcustomnotificationevent", yourargs, title, message)
end)

--pro tip: use our own notification system, because lua events are very unperformant!