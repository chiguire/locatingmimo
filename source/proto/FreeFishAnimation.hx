package proto;

import flixel.FlxSprite;
import flixel.FlxG;

/**
 * ...
 * @author Ciro Duran
 */
class FreeFishAnimation extends FlxSprite
{

	public function new(X:Float=0, Y:Float=0) 
	{
		super(X - 40/2, Y - 80);
		
		loadGraphic(AssetPaths.bolsita_break__png, true, 98, 99);
		
		animation.add("normal", [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], 20, false);
		animation.play("normal");
		animation.callback = check_finished;
		
		FlxG.sound.play(AssetPaths.win2__mp3, 1, false, true);
	}
	
	private function check_finished(frame_name:String, frame_number:Int, frame_index:Int) : Void
	{
		if (frame_number == 5)
		{
			kill();
		}
	}
	
}