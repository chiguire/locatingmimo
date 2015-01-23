package proto;

import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.util.FlxColor;

/**
 * ...
 * @author Ciro Duran
 */
class BallChar extends FlxSprite
{

	public function new(X:Float=0, Y:Float=0, ?SimpleGraphic:Dynamic) 
	{
		super(X, Y, SimpleGraphic);
		
		makeGraphic(40, 40, FlxColor.MAUVE);
	}
	
	public override function update()
	{
		super.update();
	}
	
	public function move(movement : Int) : Void
	{
		if (movement == 0)
		{
			return;
		}
		
		if (movement & FlxObject.LEFT != 0)
		{
			x -= 1;
		}
		else if (movement & FlxObject.RIGHT != 0)
		{
			x += 1;
		}
		
		if (movement & FlxObject.UP != 0)
		{
			y -= 1;
		}
		else if (movement & FlxObject.DOWN != 0)
		{
			y += 1;
		}
	}
}