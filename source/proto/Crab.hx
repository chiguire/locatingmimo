package proto;

import flixel.addons.nape.FlxNapeSprite;
import flixel.math.FlxMath;
import flixel.FlxG;
import flixel.math.FlxRandom;
import nape.callbacks.CbType;
import nape.phys.BodyType;
import nape.geom.Vec2;
import nape.dynamics.InteractionFilter;

/**
 * ...
 * @author Ciro Duran
 */
class Crab extends FlxNapeSprite
{
	public var max_speed : Vec2 = new Vec2(50, 50);

	public var is_in_water : Bool = false;
	
	public var phase : Int = 0;
	
	public var _distance : Float;
	
	public function new(X:Float=0, Y:Float=0, collision_type:CbType) 
	{
		super(X, Y, null, false, false);
		
		loadGraphic(AssetPaths.crab__png, true, 55, 34);
		
		createRectangularBody(55, 34, BodyType.KINEMATIC);
		var interactionFilter : InteractionFilter = new InteractionFilter();
		interactionFilter.fluidGroup = 0;
		interactionFilter.collisionGroup = 1;
		interactionFilter.collisionMask = -1;
		body.setShapeFilters(interactionFilter);
		body.shapes.at(0).cbTypes.add(collision_type);
		//body.shapes.at(0).sensorEnabled = true;
		
		animation.add("normal", [1, 2, 3], 10, true);
		animation.play("normal");
		
		phase = FlxG.random.int(0, 360);
		
		physicsEnabled = true;
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		is_in_water = body.position.y >= 505;
		phase = (phase + 10) % 360;
	}
	
	public function seek(target:FlxNapeSprite) : Void
	{
		var temp_force : Vec2 = Vec2.weak();
		var temp_force2 = Vec2.weak();
		_distance = Vec2.distance(target.body.position, body.position);
		
		if (_distance <= 150)
		{
			temp_force.x = (target.body.position.x + (target.width/2.0)) - (body.position.x + (this.width/2.0)); // desired velocity
			temp_force.y = (target.body.position.y + (target.width/2.0)) - (body.position.y + (this.width/2.0));
			temp_force = temp_force.normalise();
			
			temp_force2.setxy(temp_force.x * max_speed.x, temp_force.y * max_speed.y).subeq(body.velocity);
		}
		else
		{
			temp_force2.x = 0;
		}
		
		temp_force2.y = 10*Math.sin(phase * Math.PI / 180.0);
		
		body.velocity = temp_force2;
	}
}