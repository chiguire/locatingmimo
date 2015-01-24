package;

import flixel.addons.nape.FlxNapeState;
import flixel.addons.nape.FlxNapeSprite;
import nape.dynamics.InteractionFilter;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.shape.Polygon;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.util.FlxColor;
import nape.phys.FluidProperties;
import nape.shape.Polygon;
import proto.BallChar;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxNapeState
{
	public static var player1_key_mapping : Map<Array<String>, Int> = [
		["W"] => FlxObject.UP,
		["S"] => FlxObject.DOWN,
		["A"] => FlxObject.LEFT,
		["D"] => FlxObject.RIGHT
	];
	
	var ball0 : BallChar;
	var sea : FlxNapeSprite;
	var background : FlxSprite;
	
	var sea_line : Int = 300;
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();
		
		napeDebugEnabled = true;
		
		createWalls(0, 0, FlxG.width, FlxG.height);
		
		background = new FlxSprite(0, 0);
		background.makeGraphic(800, 600, FlxColor.AQUAMARINE);
		add(background);
		
		var sea_interaction_filters : InteractionFilter = new InteractionFilter();
		sea_interaction_filters.collisionMask = 0;
		sea_interaction_filters.fluidMask = 2;
		var sea_fluid_properties : FluidProperties = new FluidProperties(3, 6);
		var sea_shape : Polygon = new Polygon(Polygon.rect(-400, -150, 800, 300));
		sea_shape.fluidEnabled = true;
		sea_shape.filter = sea_interaction_filters;
		sea_shape.fluidProperties.density = 2;
		sea_shape.fluidProperties.viscosity = 3;
		
		var sea_body : Body = new Body(BodyType.STATIC, Vec2.weak(0, 0));
		sea_shape.body = sea_body;
		
		
		sea = new FlxNapeSprite(400, FlxG.height - sea_line/2.0 , null, false);
		sea.makeGraphic(800, 300, FlxColor.NAVY_BLUE);
		sea.addPremadeBody(sea_body);
		sea.physicsEnabled = true;
		add(sea);
		
		ball0 = new BallChar(300, sea_line - 100);
		add(ball0);
		
		FlxNapeState.space.gravity.setxy(0, 500);
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		super.update();
		
		if (FlxG.keys.justPressed.G)
		{
			napeDebugEnabled = !napeDebugEnabled;
		}
		
		ball0.is_in_water = sea.body.contains(ball0.body.position);
		
		var movement : Int = 0;
		
		for (k in player1_key_mapping.keys())
		{
			if (FlxG.keys.anyPressed(k))
			{
				movement |= player1_key_mapping.get(k);
			}
		}
		
		ball0.move(movement);
	}	
}