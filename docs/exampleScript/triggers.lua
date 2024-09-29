function doTrigger(songTrigger, strumTime, value1, value2) -- Actually triggers the.. trigger.
    if songTrigger == 'Triggers Dad Battle' then
        if value1 == 0 then
            debugPrint('Dad Battle!')
        end
    end
    if songTrigger == 'Triggers Philly Nice' then
        if value1 == 0 then
            debugPrint('Philly Nice!')
        end
    end
end