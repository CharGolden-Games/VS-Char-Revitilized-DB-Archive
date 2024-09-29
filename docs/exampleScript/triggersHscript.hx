function songNameToTrigger(songName:String):String //  This converts a song name to 'Triggers <Song Name>' to match the original Marios Madness trigger system
{
    if (songName == 'dad-battle') {
        return 'Triggers Dad Battle';
    }
}

function doTrigger(songTrigger:String, strumTime:Float, value1:Float, value2:Dynamic):Bool // Actually triggers the.. trigger.
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