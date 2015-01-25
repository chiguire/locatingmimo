package proto;

import flixel.addons.effects.FlxWaveSprite;
import flixel.FlxSprite;

/**
 * ...
 * @author Ciro Duran
 */
class Algae extends FlxWaveSprite
{
	public function new(Target:FlxSprite) 
	{
		super(Target, WaveMode.ALL, 2, -1, 10);
		scale.set(0.5, 0.5);
		//TODO Make body
	}
	
}