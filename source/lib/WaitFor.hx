package lib;

import flixel.FlxState;
import flixel.FlxG;


class WaitFor extends FlxState
{
	private var time:Float;
	private var tt:Float = 0;
	
	public function new(time:Float)
	{
		super();
		this.time = time;
	}


	override public function update()
	{
		
		tt -= FlxG.elapsed;
		
		if (tt <= -time)
		{
			trace("ok!");
			tt=0;
			
		}
		else
		{
			
		}
		
		
		
	}
	
	
	
	
}
