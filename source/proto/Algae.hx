package proto;

import flixel.addons.effects.FlxWaveSprite;
import flixel.addons.nape.FlxNapeSprite;
import flixel.addons.nape.FlxNapeState;
import flixel.FlxSprite;
import nape.callbacks.CbType;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.shape.Polygon;
import nape.geom.Vec2;
import nape.dynamics.InteractionFilter;

/**
 * ...
 * @author Ciro Duran
 */
class Algae extends FlxNapeSprite
{
	public var shake : Bool = false;
	
	private var sign : Int = 1;
	private var counter : Int = 3;
	
	public function new(url:String, X:Float, algae_collision_type:CbType) 
	{
		var algae_sprite0 : FlxSprite = new FlxSprite(0, 0, url);
		super(X, 800 - algae_sprite0.frameHeight / 2.0, url, true, true);
		body.type = BodyType.KINEMATIC;
		body.shapes.at(0).fluidEnabled = true;
		body.shapes.at(0).fluidProperties.density = 0.2;
		body.shapes.at(0).fluidProperties.viscosity = 20;
		body.shapes.at(0).userData.flxSprite = this;
		
		var interaction_filters : InteractionFilter = new InteractionFilter(1, 0, 1, -1, 2, -1);
		body.setShapeFilters(interaction_filters);
		body.shapes.at(0).cbTypes.add(algae_collision_type);
		
		algae_sprite0.destroy();
	}
	
	override public function update():Void 
	{
		super.update();
		
		if (shake)
		{
			velocity.x = sign * 100;
			counter--;
			
			if (counter <= 0)
			{
				counter = 3;
				sign = -1 * sign;
			}
		}
		else
		{
			velocity.x = 0;
		}
	}
}