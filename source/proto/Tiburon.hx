package proto;

import flixel.addons.nape.FlxNapeSprite;

/**
 * ...
 * @author Ciro Duran
 */
class Tiburon extends FlxNapeSprite
{

	public function new(X:Float=0, Y:Float=0, ?SimpleGraphic:Dynamic, CreateRectangularBody:Bool=true, EnablePhysics:Bool=true) 
	{
		super(X, Y, null, false, false);
		
		loadGraphic(AssetPaths.seagull__png, true, 75, 44);
		
		createRectangularBody(61, 53, BodyType.KINEMATIC);
		
		animation.add("normal", [1, 2, 3], 10, true);
		animation.play("normal");
		
		physicsEnabled = true;
	}
	
	override public function update():Void 
	{
		super.update();
		
		
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
		body.force = temp_force2;
	}
}