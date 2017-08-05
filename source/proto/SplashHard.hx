package proto;

import flixel.FlxSprite;
import flixel.FlxG;
/**
 * ...
 * @author Ciro Duran
 */
class SplashHard extends FlxSprite
{

	public function new(X:Float=0, Y:Float=0) 
	{
		super(X, Y);
		
		loadGraphic(AssetPaths.splash_hard__png, true, 114, 46);
		
		animation.add("normal", [1, 2, 3, 4, 5, 6, 7, 8, 8], 10, false);
		animation.play("normal");
		animation.callback = check_finished;
		
		FlxG.sound.play(AssetPaths.splash__mp3, 0.6, false, true);
	}
	
	private function check_finished(frame_name:String, frame_number:Int, frame_index:Int) : Void
	{
		if (frame_index == 6)
		{
			kill();
		}
	}
	
}