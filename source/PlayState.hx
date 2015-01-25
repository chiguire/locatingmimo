package;

import flixel.addons.effects.FlxWaveSprite;
import flixel.addons.nape.FlxNapeState;
import flixel.addons.nape.FlxNapeSprite;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.group.FlxTypedGroup;
import flixel.util.FlxRandom;
import flixel.FlxCamera;
import haxe.macro.ExprTools.ExprArrayTools;
import nape.constraint.Constraint;
import nape.constraint.DistanceJoint;
import nape.constraint.PivotJoint;
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
import proto.Algae;

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
	
	var balls : Array<BallChar>;
	//var constraints : Array<Constraint>;
	var algas : Array<Algae>;
	var sea_body : Body;
	var background : FlxSprite;
	var sprite_group : FlxGroup;
	
	var sea_line : Int = 300;
	public var algae_scale : Float = 1.4;
	
	var keyboard_record_map : Array<Int>;
	var time_elapsed : Float;
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();
		
		napeDebugEnabled = true;
		
		createWalls(0, 0, 6000, 800);
		
		background = new FlxSprite(0, 0, AssetPaths.background__png);
		add(background);
		
		var sea_interaction_filters : InteractionFilter = new InteractionFilter();
		sea_interaction_filters.collisionMask = 0;
		sea_interaction_filters.fluidMask = 2;
		var sea_fluid_properties : FluidProperties = new FluidProperties(3, 6);
		var sea_shape : Polygon = new Polygon(Polygon.rect(-3000, -328/2.0, 6000, 328));
		sea_shape.fluidEnabled = true;
		sea_shape.filter = sea_interaction_filters;
		sea_shape.fluidProperties.density = 2;
		sea_shape.fluidProperties.viscosity = 3;
		
		sea_body = new Body(BodyType.STATIC, Vec2.weak(0, 472+328/2.0));
		sea_shape.body = sea_body;
		sea_body.space = FlxNapeState.space;
		
		balls = new Array<BallChar>();
		
		sprite_group = new FlxGroup();
		add(sprite_group);
		
		algas = new Array<Algae>();
		add_algae(20, AssetPaths.alga0__png);
		add_algae(30, AssetPaths.alga1__png);
		add_algae(40, AssetPaths.alga2__png);
		
		var fishies_bolsis : Array<String> = [ AssetPaths.bolsis_clown__png, AssetPaths.bolsis_red__png, AssetPaths.bolsis_star__png, AssetPaths.bolsis_gold__png, AssetPaths.bolsis_tiburoncin__png, AssetPaths.bolsis_hippo__png, AssetPaths.bolsis_tuna__png ];
		
		for (i in 0...7)
		{
			var ball = new BallChar(400 - (6-i) * 50, sea_line - 100, fishies_bolsis[6-i]);
			sprite_group.add(ball);
			balls.push(ball);
		}
		/*
		constraints = new Array<Constraint>();
		for (i in 0...6)
		{
			var constraint : Constraint = new DistanceJoint(balls[i].body, balls[i+1].body, Vec2.weak(), Vec2.weak(), 0, 45);
			constraint.stiff = false;
			constraint.frequency = 20.0;
			constraint.damping = 1.0;
			constraint.space = FlxNapeState.space;
			
			constraints.push(constraint);
		}*/
		
		var overlayCamera = new FlxCamera(0, 0, FlxG.width, FlxG.height);
		overlayCamera.setBounds(0, 0, 6000, 800, false);
		overlayCamera.follow(balls[6], FlxCamera.STYLE_PLATFORMER, 1);
		FlxG.cameras.reset(overlayCamera);
		
		time_elapsed = 0.0;
		keyboard_record_map = new Array();
		
		FlxNapeState.space.gravity.setxy(0, 600);
		FlxG.watch.add(this.keyboard_record_map, "length");
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
		
		time_elapsed += FlxG.elapsed;
		
		if (FlxG.keys.justPressed.G)
		{
			napeDebugEnabled = !napeDebugEnabled;
		}
		
		balls[6].is_in_water = sea_body.contains(balls[6].body.position);
		
		var movement : Int = 0;
		
		for (k in player1_key_mapping.keys())
		{
			if (FlxG.keys.anyPressed(k))
			{
				movement |= player1_key_mapping.get(k);
			}
		}
		
		balls[6].move(movement);
		
		keyboard_record_map.push(movement);
		
		if (keyboard_record_map.length > 30)
		{
			balls[5].move(keyboard_record_map[keyboard_record_map.length - 30], true);
		}
		if (keyboard_record_map.length > 60)
		{
			balls[4].move(keyboard_record_map[keyboard_record_map.length - 60], true);
		}
		if (keyboard_record_map.length > 90)
		{
			balls[3].move(keyboard_record_map[keyboard_record_map.length - 90], true);
		}
		if (keyboard_record_map.length > 120)
		{
			balls[2].move(keyboard_record_map[keyboard_record_map.length - 120], true);
		}
		if (keyboard_record_map.length > 150)
		{
			balls[1].move(keyboard_record_map[keyboard_record_map.length - 150], true);
		}
		if (keyboard_record_map.length > 180)
		{
			balls[0].move(keyboard_record_map[keyboard_record_map.length - 180], true);
		}
		if (keyboard_record_map.length > 181)
		{
			keyboard_record_map.shift();
		}
	}
	
	private function add_algae(X: Int, url:String) : Void
	{
		var algae_sprite0 : FlxSprite = new FlxSprite(0, 0, url);
		var algae0 = new Algae(algae_sprite0);
		algae0.x = X;
		algae0.y = 800 - algae0.height * algae0.scale.y * algae_scale;
		sprite_group.add(algae0);
		algas.push(algae0);
	}
}