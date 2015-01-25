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
	public var accel (default, null) : Vec2 = new Vec2(300, 2000);
	public var is_in_water : Bool = false;
	
	public function new(X:Float=0, Y:Float=0, url:String) 
	{
		super(X, Y, null, false, false);
		
		loadGraphic(url, true, 40, 40);
		
		animation.add("quiet", [1], 30, true);
		animation.add("moving0", [1, 2, 3, 4], 10, true);
		animation.add("moving1", [1, 2, 3, 4], 20, true);
		animation.play("quiet");
		
		createCircularBody(20, BodyType.DYNAMIC);
		
		setBodyMaterial(0.5, 0.2, 0.5, 1, 5);
		
		var interactionFilter : InteractionFilter = new InteractionFilter();
		interactionFilter.collisionGroup = 2;
		interactionFilter.collisionMask = 1;
		interactionFilter.fluidGroup = 2;
		body.setShapeFilters(interactionFilter);
		body.position.y = Y;
		body.position.x = X;
		
		physicsEnabled = true;
		
		//FlxG.watch.add(this, "is_in_water");
		//FlxG.watch.add(this.body, "force");
		//FlxG.watch.add(this.body, "angularVel");
		FlxG.watch.add(this, "y");
	}
	
	public override function update()
	{
		super.update();
		
		if (Math.abs(body.angularVel) < 3)
		{
			animation.play("quiet");
		}
		else if (Math.abs(body.angularVel) < 6)
		{
			animation.play("moving0");
		}
		else if (Math.abs(body.angularVel) < 9)
		{
			animation.play("moving1");
		}
	}
	
	public function move(movement : Int, force_movement : Bool = false) : Void
	{
		var force:Vec2 = Vec2.weak();
		
		if (movement & FlxObject.LEFT != 0)
		{
			force.x = -accel.x;
		}
		else if (movement & FlxObject.RIGHT != 0)
		{
			force.x = accel.x;
		}
		else
		{
			force.x = 0;
		}
		
		if (movement & FlxObject.UP != 0 && (force_movement || is_in_water))
		{
			force.y = -accel.y;
		}
		else if (movement & FlxObject.DOWN != 0 && (force_movement || is_in_water))
		{
			force.y = accel.y;
		}
		else
		{
			force.y = 0;
		}
		
		body.force = force;
	}
}