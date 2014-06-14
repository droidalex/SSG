package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import enemies.Enemy;

class Ship extends FlxSprite
{
	private var game:Game;

	public function new(x:Float, y:Float,game:Game):Void
	{
		super();
		this.x=x;
		this.y=y;
		this.game=game;
		

		
		loadGraphic("assets/ssg.png",true,32,32,false);
		animation.add("normal",[0,1,2,3,4],30,true);
		animation.play("normal");
				

	}
	

	override public function destroy():Void
	{
		super.destroy();
	}


	override public function update():Void
	{

		super.update();
	}	
	

}
