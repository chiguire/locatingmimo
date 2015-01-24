package proto;

import flixel.addons.nape.FlxNapeSprite;
import flixel.addons.nape.FlxNapeState;
import nape.dynamics.InteractionFilter;
import nape.phys.BodyType;
import nape.geom.Vec2;
import flixel.FlxObject;
import flixel.FlxG;
import flixel.util.FlxColor;

/**
 * ...
 * @author Ciro Duran
 */
class BallChar extends FlxNapeSprite
{
	public var accel (default, null) : Vec2 = new Vec2(300, 1000);
	public var is_in_water : Bool = false;
	
	public function new(X:Float=0, Y:Float=0, ?SimpleGraphic:Dynamic) 
	{
		super(X, Y, null, false, false);
		
		createCircularBody(20, BodyType.DYNAMIC);
		
		makeGraphic(40, 40, FlxColor.MAUVE);
		setBodyMaterial(0.5, 0.2, 0.5, 1, 1);
		
		var interactionFilter : InteractionFilter = new InteractionFilter();
		interactionFilter.collisionGroup = 2;
		interactionFilter.fluidGroup = 2;
		body.setShapeFilters(interactionFilter);
		body.position.y = Y;
		body.position.x = X;
		
		physicsEnabled = true;
		
		FlxG.watch.add(this, "is_in_water");
		FlxG.watch.add(this.body, "force");
	}
	
	public override function update()
	{
		super.update();
	}
	
	public function move(movement : Int) : Void
	{
		var impulse:Vec2 = Vec2.weak();
		
		if (movement & FlxObject.LEFT != 0)
		{
			impulse.x = -accel.x;
		}
		else if (movement & FlxObject.RIGHT != 0)
		{
			impulse.x = accel.x;
		}
		else
		{
			impulse.x = 0;
		}
		
		if (movement & FlxObject.UP != 0 && is_in_water)
		{
			impulse.y = -accel.y;
		}
		else if (movement & FlxObject.DOWN != 0 && is_in_water)
		{
			impulse.y = accel.y;
		}
		else
		{
			impulse.y = 0;
		}
		
		body.force = impulse;
	}
}