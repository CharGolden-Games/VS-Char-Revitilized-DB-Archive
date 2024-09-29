function songNameToTrigger(songName:String):String 
{
    if (songName == 'dad-battle') {
        return 'Triggers Dad Battle';
    }
}

function doTrigger(songTrigger:String, strumTime:Float, value1:Float, value2:Dynamic):Bool
{
    switch (songTrigger) {
        case 'Triggers Dad Battle':
            switch(value1) {
                case 0:
                    debugPrint('Dad Battle!');
            }
        case 'Triggers philly-nice':
            switch(value1) {
                case 0:
                    debugPrint('Philly Nice!');
            }
    }
}