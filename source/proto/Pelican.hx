package proto;

import flixel.addons.nape.FlxNapeSprite;
import nape.callbacks.CbType;
import nape.phys.BodyType;
import nape.geom.Vec2;
import nape.dynamics.InteractionFilter;
import flixel.util.FlxRandom;

/**
 * ...
 * @author Ciro Duran
 */
class Pelican extends FlxNapeSprite
{

	public var max_speed : Vec2 = new Vec2(400, 2000);
	public var phase : Vec2 = new Vec2(0, 0);
	public function new(X:Float=0, Y:Float=0, collision_type:CbType) 
	{
		super(X, Y, null, false, false);
		
		loadGraphic(AssetPaths.pelican__png, true, 104, 84);
		
		createRectangularBody(104, 84, BodyType.KINEMATIC);
		var interactionFilter : InteractionFilter = new InteractionFilter();
		interactionFilter.fluidMask = 0;
		interactionFilter.collisionGroup = 1;
		body.setShapeFilters(interactionFilter);
		body.shapes.at(0).cbTypes.add(collision_type);
		body.allowRotation = false;
		
		//body.shapes.at(0).sensorEnabled = true;
		
		animation.add("normal", [1, 2, 3], 10, true);
		animation.play("normal");
		
		phase.x = FlxRandom.intRanged(0, 360);
		phase.y = FlxRandom.intRanged(0, 360);
		
		physicsEnabled = true;
	}
	
	override public function update():Void 
	{
		super.update();
		
		phase.x += 1;
		phase.y += 10;
		
		if (phase.x >= 360)
		{
			phase.x -= 360;
		}
		if (phase.y >= 360)
		{
			phase.y -= 360;
		}
		
		var temp_force2 : Vec2 = Vec2.weak(300 * Math.sin(phase.x * Math.PI / 180.0), 0);// 10 * Math.sin(phase.y * Math.PI / 180.0));
		body.velocity = temp_force2;
		
		flipX = (body.velocity.x > 0);
	}
	
	public function seek(target:FlxNapeSprite) : Void
	{
		var temp_force : Vec2 = Vec2.weak();
		var temp_force2 = Vec2.weak();
		//distance_ = Vec2.distance(target.body.position, body.position);
		
		temp_force.x = (target.body.position.x + (target.width/2.0)) - (body.position.x + (this.width/2.0)); // desired velocity
		temp_force.y = (target.body.position.y + (target.width/2.0)) - (body.position.y + (this.width/2.0));
		temp_force = temp_force.normalise();
		
		temp_force2.setxy(temp_force.x * max_speed.x, temp_force.y * max_speed.y).subeq(body.velocity);
		body.force = temp_force2;
	}
}