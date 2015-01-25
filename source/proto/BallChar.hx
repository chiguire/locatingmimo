package proto;

import flixel.addons.nape.FlxNapeSprite;
import flixel.addons.nape.FlxNapeState;
import nape.callbacks.CbType;
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
	public var accel (default, null) : Vec2 = new Vec2(200, 2000);
	public var is_in_water : Bool = false;
	public var is_in_algae : Bool = false;
	
	public var max_speed : Vec2 = new Vec2(400, 2000);
	
	public var distance_ : Float = 0;
	public var minimum_distance : Float = 45;
	public var maximum_distance : Float = 60;
	
	public var name : String;
	
	public function new(X:Float=0, Y:Float=0, url:String, name:String, collision_type:CbType) 
	{
		super(X, Y, null, false, false);
		
		loadGraphic(url, true, 40, 40);
		
		animation.add("quiet", [1], 30, true);
		animation.add("moving0", [1, 2, 3, 4], 10, true);
		animation.add("moving1", [1, 2, 3, 4], 20, true);
		animation.play("quiet");
		
		createCircularBody(18, BodyType.DYNAMIC);
		
		setBodyMaterial(0.5, 0.4, 0.7, 1, 5);
		
		var interactionFilter : InteractionFilter = new InteractionFilter();
		interactionFilter.collisionGroup = 2;
		interactionFilter.collisionMask = 1;
		interactionFilter.sensorGroup = 1;
		interactionFilter.fluidGroup = 2;
		body.setShapeFilters(interactionFilter);
		body.position.y = Y;
		body.position.x = X;
		body.inertia = 5000;
		body.userData.flxSprite = this;
		body.cbTypes.add(collision_type);
		
		physicsEnabled = true;
		
		this.name = name;
		
		//FlxG.watch.add(this, "is_in_water");
		//FlxG.watch.add(this.body, "force");
		//FlxG.watch.add(this.body, "angularVel");
		//FlxG.watch.add(this.body.position, "y", name + " y");
		//FlxG.watch.add(this, "distance_", name + " dist");
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
		
		is_in_water = body.position.y >= 465;
	}
	
	public function move(movement : Int, force_movement : Bool = false) : Void
	{
		var force:Vec2 = Vec2.weak();
		
		if (is_in_algae)
		{
			accel.y = 1000;
		}
		else
		{
			accel.y = 2000;
		}
		
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
	
	public function seek(target:FlxNapeSprite) : Void
	{
		var temp_force : Vec2 = Vec2.weak();
		var temp_force2 = Vec2.weak();
		distance_ = Vec2.distance(target.body.position, body.position);
		
		temp_force.x = (target.body.position.x + (target.width/2.0)) - (body.position.x + (this.width/2.0)); // desired velocity
		temp_force.y = (target.body.position.y + (target.width/2.0)) - (body.position.y + (this.width/2.0));
		temp_force = temp_force.normalise();
		
		temp_force2.setxy(temp_force.x * max_speed.x, temp_force.y * max_speed.y).subeq(body.velocity);
		
		if (distance_ < maximum_distance)
		{
			temp_force2.muleq((distance_ - minimum_distance) / minimum_distance);
		}
		
		if (body.position.y < 463)
		{
			temp_force2.y = 0;
		}
		body.force = temp_force2;
	}
}