
function doTrigger(songTrigger:String, strumTime:Float, value1:Float, value2:Dynamic):Bool // Actually triggers the.. trigger.
{
    switch (songTrigger) {
        case 'Triggers Dad Battle':
            switch(value1) {
                case 0:
                    debugPrint('Dad Battle! Hscript');
                    return true;
            }
        case 'Triggers Philly Nice':
            switch(value1) {
                case 0:
                    debugPrint('Philly Nice! Hscript');
                    return true;
            }
    }
    return false;
}