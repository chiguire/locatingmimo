package proto;

import flixel.addons.nape.FlxNapeSprite;
import nape.callbacks.CbType;
import nape.dynamics.InteractionFilter;
import nape.geom.Vec2;
import nape.phys.BodyType;

/**
 * ...
 * @author Ciro Duran
 */
class Tiburon extends FlxNapeSprite
{
	public var max_speed : Vec2 = new Vec2(20, 20);

	public var is_in_water : Bool = false;
	
	public var _distance : Float;
	
	public var phase : Int = 0;
	
	public function new(X:Float=0, Y:Float=0, collision_type:CbType) 
	{
		super(X, Y, null, false, false);
		
		loadGraphic(AssetPaths.tiburon__png, true, 75, 44);
		
		createRectangularBody(75, 44, BodyType.KINEMATIC);
		var interactionFilter : InteractionFilter = new InteractionFilter();
		interactionFilter.fluidMask = 0;
		interactionFilter.collisionGroup = 1;
		body.setShapeFilters(interactionFilter);
		body.shapes.at(0).cbTypes.add(collision_type);
		//body.shapes.at(0).sensorEnabled = true;
		
		animation.add("normal", [1, 2, 3, 4, 5, 6, 7, 8], 15, true);
		animation.play("normal");
		
		physicsEnabled = true;
	}
	
	override public function update():Void 
	{
		super.update();
		
		is_in_water = body.position.y >= 600;
		
		flipX = (body.velocity.x >= 0);
	}
	
	public function seek(target:FlxNapeSprite) : Void
	{
		var temp_force : Vec2 = Vec2.weak();
		var temp_force2 = Vec2.weak();
		_distance = Vec2.distance(target.body.position, body.position);
		
		if (_distance <= 300)
		{
			temp_force.x = (target.body.position.x + (target.width/2.0)) - (body.position.x + (this.width/2.0)); // desired velocity
			temp_force.y = (target.body.position.y + (target.width/2.0)) - (body.position.y + (this.width/2.0));
			temp_force = temp_force.normalise();
			
			temp_force2.setxy(temp_force.x * max_speed.x, temp_force.y * max_speed.y).subeq(body.velocity);
			if (temp_force2.x < 3)
			{
				temp_force.x = 0;
			}
		}
		else
		{
			temp_force2.x = body.velocity.x * 0.5;
			temp_force2.y = 10*Math.sin(phase * Math.PI / 180.0);
		}
		
		if (!is_in_water)
		{
			temp_force2.y = Math.max(0, temp_force2.y);
		}
		
		body.velocity = temp_force2;
	}
}