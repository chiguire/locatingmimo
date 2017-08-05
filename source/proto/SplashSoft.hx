package proto;

import flixel.FlxG;
import flixel.FlxSprite;

/**
 * ...
 * @author Ciro Duran
 */
class SplashSoft extends FlxSprite
{

	public function new(X:Float=0, Y:Float=0) 
	{
		super(X, Y);
		
		loadGraphic(AssetPaths.splash_soft__png, true, 99, 24);
		
		animation.add("normal", [1, 2, 3, 4, 4], 10, false);
		animation.play("normal");
		animation.callback = check_finished;
		
		FlxG.sound.play(AssetPaths.splash__mp3, 0.2, false, true);
	}
	
	private function check_finished(frame_name:String, frame_number:Int, frame_index:Int) : Void
	{
		if (frame_number == 2)
		{
			kill();
		}
	}
	
}