package;

import flixel.addons.display.FlxBackdrop;
import flixel.addons.effects.FlxWaveSprite;
import flixel.addons.nape.FlxNapeState;
import flixel.addons.nape.FlxNapeSprite;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.group.FlxTypedGroup;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxRandom;
import flixel.FlxCamera;
import flixel.util.FlxTimer;
import haxe.macro.ExprTools.ExprArrayTools;
import nape.callbacks.Callback;
import nape.callbacks.CbEvent;
import nape.callbacks.CbType;
import nape.callbacks.InteractionCallback;
import nape.callbacks.InteractionListener;
import nape.callbacks.InteractionType;
import nape.constraint.Constraint;
import nape.constraint.DistanceJoint;
import nape.constraint.PivotJoint;
import nape.dynamics.InteractionFilter;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.phys.Material;
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
import proto.FreeFishAnimation;
import proto.SplashHard;
import proto.SplashSoft;

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
	var algas : Array<FlxNapeSprite>;
	var sea_body : Body;
	var background : FlxBackdrop;
	var wharf : FlxSprite;
	var sprite_group : FlxGroup;
	
	var sea_line : Int = 472;
	
	var algae_listener_begin : InteractionListener;
	var algae_listener_end : InteractionListener;
	var fish_collision_type : CbType = new CbType();
	var algae_collision_type : CbType = new CbType();
	var water_collision_type : CbType = new CbType();
	
	var current_fish : Int;
	
	var game_over : Bool;
	var game_over_timer : FlxTimer;
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();
		
		napeDebugEnabled = true;
		
		createWalls(0, -1000, 6000, 800);
		
		background = new FlxBackdrop(AssetPaths.background_1__png, 1, 1, true, false);
		add(background);
		
		create_clouds();
		
		var sea_interaction_filters : InteractionFilter = new InteractionFilter();
		sea_interaction_filters.collisionMask = 0;
		sea_interaction_filters.fluidMask = 2;
		var sea_shape : Polygon = new Polygon(Polygon.rect(-3000, -328/2.0, 6000, 328));
		sea_shape.fluidEnabled = true;
		sea_shape.cbTypes.add(water_collision_type);
		sea_shape.filter = sea_interaction_filters;
		sea_shape.fluidProperties.density = 2.4;
		sea_shape.fluidProperties.viscosity = 3;
		
		sea_body = new Body(BodyType.STATIC, Vec2.weak(0, sea_line+328/2.0));
		sea_shape.body = sea_body;
		sea_body.space = FlxNapeState.space;
		
		var wharf_shape : Polygon = new Polygon(Polygon.rect( -320 / 2.0, -24 / 2.0, 320, 24));
		var wharf_body = new Body(BodyType.STATIC, Vec2.weak(320 / 2.0, 388 + 12));
		wharf_shape.body = wharf_body;
		wharf_body.space = FlxNapeState.space;
		
		wharf = new FlxSprite(0, 388, AssetPaths.wharf__png);
		add(wharf);
		
		balls = new Array<BallChar>();
		
		sprite_group = new FlxGroup();
		add(sprite_group);
		
		var fishies_bolsis : Array<String> = [ AssetPaths.bolsis_clown__png, AssetPaths.bolsis_red__png, AssetPaths.bolsis_star__png, AssetPaths.bolsis_gold__png, AssetPaths.bolsis_tiburoncin__png, AssetPaths.bolsis_hippo__png, AssetPaths.bolsis_tuna__png ];
		var fishies_names : Array<String> = ["clown", "red", "star", "gold", "tiburoncin", "hippo", "tuna"];
		for (i in 0...7)
		{
			var ball = new BallChar(288 - (6-i) * 45, 368, fishies_bolsis[6-i], fishies_names[6-i], fish_collision_type);
			sprite_group.add(ball);
			balls.push(ball);
		}
		
		create_creatures();
		
		create_algae();
		
		create_overlay();
		
		current_fish = 6;
		game_over = false;
		
		var overlayCamera = new FlxCamera(0, 0, FlxG.width, FlxG.height);
		overlayCamera.setBounds(0, 0, 6000, 800, false);
		overlayCamera.follow(balls[current_fish], FlxCamera.STYLE_PLATFORMER, 1);
		FlxG.cameras.reset(overlayCamera);
		
		FlxNapeState.space.gravity.setxy(0, 600);
		
		algae_listener_begin = new InteractionListener(CbEvent.BEGIN, InteractionType.ANY, fish_collision_type, algae_collision_type, fish_to_algae, 0);
		algae_listener_end = new InteractionListener(CbEvent.END, InteractionType.ANY, fish_collision_type, algae_collision_type, fish_to_algae, 0);
		FlxNapeState.space.listeners.add(algae_listener_begin);
		FlxNapeState.space.listeners.add(algae_listener_end);
		FlxNapeState.space.listeners.add(new InteractionListener(CbEvent.BEGIN, InteractionType.ANY, fish_collision_type, water_collision_type, fish_to_water, 0));
		FlxNapeState.space.listeners.add(new InteractionListener(CbEvent.END, InteractionType.ANY, fish_collision_type, water_collision_type, fish_to_water, 0));
		
		FlxG.watch.add(balls[6].body.velocity, "y");
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
		
		if (FlxG.keys.justPressed.R)
		{
			FlxG.resetState();
			return;
		}
		
		if (FlxG.keys.justPressed.ESCAPE)
		{
			FlxG.switchState(new MenuState());
			return;
		}
		
		if (FlxG.keys.justPressed.SPACE)
		{
			free_fish();
		}
		
		var movement : Int = 0;
		
		for (k in player1_key_mapping.keys())
		{
			if (FlxG.keys.anyPressed(k))
			{
				movement |= player1_key_mapping.get(k);
			}
		}
		
		balls[current_fish].move(movement);
		
		if (current_fish > 5)
		{
			balls[5].seek(balls[6]);
		}
		if (current_fish > 4)
		{
			balls[4].seek(balls[5]);
		}
		if (current_fish > 3)
		{
			balls[3].seek(balls[4]);
		}
		if (current_fish > 2)
		{
			balls[2].seek(balls[3]);
		}
		if (current_fish > 1)
		{
			balls[1].seek(balls[2]);
		}
		if (current_fish > 0)
		{
			balls[0].seek(balls[1]);
		}
		if (current_fish < 0)
		{
			game_over = true;
			game_over_timer = new FlxTimer(5, game_over_callback, 1);
		}
	}
	
	private function add_algae(X: Int, url:String) : Void
	{
		var algae = new Algae(url, X, algae_collision_type);
		sprite_group.add(algae);
		algas.push(algae);
	}
	
	private function create_algae()
	{
		var names : Array<String> = [AssetPaths.alga0__png, AssetPaths.alga1__png, AssetPaths.alga2__png, AssetPaths.alga3__png, AssetPaths.alga4__png];
		var positions : Array<Int> = [250 , 500, 750, 1000, 1250, 1500, 1750, 2000, 2250, 2500, 2750, 3000, 3250, 3500, 3750, 4000, 4250, 4500, 4750, 5000, 5250, 5500, 5750];
		algas = new Array<FlxNapeSprite>();
		
		for (i in 0...positions.length)
		{
			add_algae(positions[i] + FlxRandom.intRanged( -200, 200), FlxRandom.getObject(names));
		}
	}
	
	private function create_overlay()
	{
		var overlay : FlxSprite = new FlxSprite(0, sea_line, null);
		overlay.makeGraphic(800, 800 - sea_line, 0xff2891bd);
		overlay.alpha = 0.33;
		overlay.scrollFactor.set(0, 1);
		add(overlay);
	}
	
	private function create_clouds()
	{
		var positions : Array<Int> = [250 , 500, 750, 1000, 1250, 1500, 1750, 2000, 2250, 2500, 2750, 3000, 3250, 3500, 3750, 4000, 4250, 4500, 4750, 5000, 5250, 5500, 5750];
		algas = new Array<FlxNapeSprite>();
		
		for (i in 0...positions.length)
		{
			var cloud = new FlxSprite(positions[i] + FlxRandom.intRanged( -200, 200), FlxRandom.intRanged(100, 300), AssetPaths.cloud__png);
			
			var tween_options : TweenOptions = { startDelay: FlxRandom.floatRanged(0, 3), ease: FlxEase.quadInOut, type: FlxTween.PINGPONG, loopDelay: FlxRandom.floatRanged(0, 3) };
			
			FlxTween.cubicMotion(cloud, cloud.x, cloud.y, cloud.x + 200, cloud.y, cloud.x + 400, cloud.y, cloud.x + 600, cloud.y, 60, tween_options);
			add(cloud);
		}
	}
	
	public function create_creatures()
	{
		
	}
	
	private function fish_to_algae(collision:InteractionCallback)
	{
		if (collision.int1.cbTypes.has(fish_collision_type) && collision.int2.cbTypes.has(algae_collision_type))
		{
			if (collision.event == CbEvent.BEGIN)
			{
				var fish = cast(collision.int1.userData.flxSprite, BallChar);
				fish.is_in_algae = true;
				
				var algae = cast(collision.int2.userData.flxSprite, Algae);
				algae.shake = true;
				
			}
			else if (collision.event == CbEvent.END)
			{
				var fish = cast(collision.int1.userData.flxSprite, BallChar);
				fish.is_in_algae = false;
				
				var algae = cast(collision.int2.userData.flxSprite, Algae);
				algae.shake = false;
			}
		}
	}
	
	private function fish_to_water(collision:InteractionCallback)
	{
		if (collision.int1.cbTypes.has(fish_collision_type) && collision.int2.cbTypes.has(water_collision_type))
		{
			if (Math.abs(collision.int1.castBody.velocity.y) > 300)
			{
				var splash : SplashHard = new SplashHard(collision.int1.castBody.position.x - 114/2, sea_line - 46);
				sprite_group.add(splash);
			}
			else if (Math.abs(collision.int1.castBody.velocity.y) > 120)
			{
				var splash : SplashSoft = new SplashSoft(collision.int1.castBody.position.x - 99/2, sea_line - 24);
				sprite_group.add(splash);
			}
		}
	}
	
	private function game_over_callback(Timer:FlxTimer) : Void {
		FlxG.switchState(new MenuState());
	}
	
	private function free_fish() : Void
	{
		var current_ball : BallChar = balls[current_fish];
		var fishies_bolsis : Array<String> = [ AssetPaths.clown__png, AssetPaths.red__png, AssetPaths.star__png, AssetPaths.gold__png, AssetPaths.tiburoncin__png, AssetPaths.hippo__png, AssetPaths.tuna__png ];
		
		var bolsis : FreeFishAnimation = new FreeFishAnimation(current_ball.body.position.x, current_ball.body.position.y);
		add(bolsis);
		
		var fish : FlxSprite = new FlxSprite(current_ball.body.position.x, current_ball.body.position.y, fishies_bolsis[6 - current_fish]);
		add(fish);
		FlxTween.linearMotion(fish, fish.x, fish.y, fish.x + FlxG.width, fish.y, 1, true, { ease: FlxEase.quadOut, complete: function (t:FlxTween) { fish.destroy();  } } );
		
		current_ball.destroy();
		
		current_fish--;
		FlxG.camera.follow(balls[current_fish], FlxCamera.STYLE_PLATFORMER, 1);
	}
}