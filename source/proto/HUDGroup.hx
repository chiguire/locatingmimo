package proto;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import haxe.macro.ExprTools.ExprArrayTools;

/**
 * ...
 * @author Ciro Duran
 */
class HUDGroup extends FlxSpriteGroup
{
	public var current_fish : Int;
	
	private var fishes : FlxSprite;
	private var saved : Array<FlxSprite>;
	private var wasted : Array<FlxSprite>;

	public function new(X:Float=0, Y:Float=0, MaxSize:Int=0) 
	{
		super(X, Y, MaxSize);
		scrollFactor.set();
		
		fishes = new FlxSprite((FlxG.width - 228)/2.0, 40, AssetPaths.life_counter__png);
		saved = new Array<FlxSprite>();
		wasted = new Array<FlxSprite>();
		
		fishes.scrollFactor.set();
		add(fishes);
		
		for (i in 0...7)
		{
			var saved_sprite = new FlxSprite(fishes.x + 205 - 35 * i, 40 + 27 / 2.0 - 34 / 2.0, AssetPaths.life_saved__png);
			saved_sprite.visible = false;
			saved.push(saved_sprite);
			add(saved_sprite);
			saved_sprite.scrollFactor.set();
			
			var wasted_sprite = new FlxSprite(fishes.x + 205 - 35 * i, 40 + 27 / 2.0 - 34 / 2.0, AssetPaths.live_wasted__png);
			wasted_sprite.visible = false;
			wasted.push(wasted_sprite);
			add(wasted_sprite);
			wasted_sprite.scrollFactor.set();
		}
		
		var text : FlxText = new FlxText(FlxG.width - 400, 10, 390, "ESC - Return / M - Mute / R - Restart", 14);
		text.alignment = "right";
		text.color = FlxColor.NAVY_BLUE;
		text.scrollFactor.set();
		add(text);
	}
	
	public function set_saved(fish_index:Int, was_saved:Bool)
	{
		if (was_saved)
		{
			saved[fish_index].visible = true;
		}
		else
		{
			wasted[fish_index].visible = true;
		}
	}
	
	public function get_num_saved()
	{
		var result : Int = 0;
		
		for (i in 0...7)
		{
			result += (saved[i].visible? 1: 0);
		}
		return result;
	}
	
}