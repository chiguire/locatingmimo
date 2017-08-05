package proto;
import flixel.FlxG;
import flixel.FlxSprite;

typedef AnimInfo = {
	?url : String,
	?width : Float,
	?height : Float,
}

/**
 * ...
 * @author Ciro Duran
 */
class DeadFishAnimation extends FlxSprite
{
	private var name_map : Map<String, AnimInfo> =
	[
		"clown" 	=> {url: AssetPaths.clown_dead__png, width: 295/5, height: 179},
		"red" 		=> {url: AssetPaths.red_dead__png, width: 295/5, height: 179},
		"star" 		=> {url: AssetPaths.star_dead__png, width: 345/5, height: 204},
		"gold" 		=> {url: AssetPaths.gold_dead__png, width: 345/5, height: 204},
		"tiburoncin" 	=> {url: AssetPaths.tiburon_dead__png, width: 335/5, height: 204},
		"hippo" 	=> {url: AssetPaths.hippo_dead__png, width: 340/5, height: 204},
		"tuna" 		=> {url: AssetPaths.tuna_dead__png, width: 340/5, height: 204},
	];
	
	public function new(X:Float=0, Y:Float=0, name:String) 
	{
		super(X - 40/2, Y - 80);
		
		var anim_info = name_map.get(name);
		
		loadGraphic(anim_info.url, true, Std.int(anim_info.width), Std.int(anim_info.height));
		
		animation.add("normal", [1, 2, 3, 4, 5], 20, false);
		animation.play("normal");
		animation.callback = check_finished;
		
		FlxG.sound.play(AssetPaths.fail__mp3, 1, false, true);
	}
	
	private function check_finished(frame_name:String, frame_number:Int, frame_index:Int) : Void
	{
		//FlxG.log.add("Hola: " + frame_number);
		if (frame_number == 3)
		{
			animation.pause();
			destroy();
		}
	}
	
}