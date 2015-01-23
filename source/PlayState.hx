package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.util.FlxColor;
import proto.BallChar;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	public static var player1_key_mapping : Map<Array<String>, Int> = [
		["W"] => FlxObject.UP,
		["S"] => FlxObject.DOWN,
		["A"] => FlxObject.LEFT,
		["D"] => FlxObject.RIGHT
	];
	
	var ball0 : BallChar;
	var sea : FlxSprite;
	var background : FlxSprite;
	
	var sea_line : Int = 300;
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();
		
		background = new FlxSprite(0, 0);
		background.makeGraphic(800, 600, FlxColor.AQUAMARINE);
		
		sea = new FlxSprite(0, sea_line);
		sea.makeGraphic(800, 300, FlxColor.NAVY_BLUE);
		
		ball0 = new BallChar(20, sea_line);
		
		
		add(background);
		add(sea);
		add(ball0);
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
	override public function update():Void
	{
		super.update();
		
		var movement : Int = 0;
		
		for (k in player1_key_mapping.keys())
		{
			if (FlxG.keys.anyJustPressed(k))
			{
				movement |= player1_key_mapping.get(k);
			}
		}
		
		ball0.move(movement);
	}	
}