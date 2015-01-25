package proto;

import flixel.addons.nape.FlxNapeSprite;

/**
 * ...
 * @author Ciro Duran
 */
class Crab extends FlxNapeSprite
{

	public function new(X:Float=0, Y:Float=0) 
	{
		super(X, Y, null, false, false);
		
		loadGraphic(AssetPaths.crab__png, true, 55, 34);
		
		createRectangularBody(61, 53, BodyType.KINEMATIC);
		
		animation.add("normal", [1, 2, 3], 10, true);
		animation.play("normal");
		
		physicsEnabled = true;
	}
	
	override public function update():Void 
	{
		super.update();
		
	}
	
}