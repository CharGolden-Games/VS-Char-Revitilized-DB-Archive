function songNameToTrigger(songName)
    if songName == 'dad-battle' then
        return 'Triggers Dad Battle'
    end
end

function doTrigger(songTrigger, strumTime, value1, value2)
    if songTrigger == 'Triggers Dad Battle' then
        if value1 == 0 then
            debugPrint('Dad Battle!')
        end
    end
    if songTrigger == 'Triggers philly-nice' then
        if value1 == 0 then
            debugPrint('Philly Nice!')
        end
    end
end