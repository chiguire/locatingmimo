package ;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;

/**
 * ...
 * @author Ciro Duran
 */
class CreditsState extends FlxState
{

	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();
		
		var bg = new FlxSprite(0, 0, AssetPaths.Credits__png);
		add(bg);
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		if (FlxG.keys.justPressed.ANY)
		{
			FlxG.switchState(new MenuState());
		}
	}
}