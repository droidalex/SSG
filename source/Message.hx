package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.util.FlxColor;
import flixel.addons.display.FlxStarField;

class Message extends FlxSubState
{
	private var levelMsg:FlxText;
	private var timer:Float=0;
	private var wait_event:Bool = false;
	private var enable_click:Bool = false;
	private var stars:FlxStarField2D;

	
	function new(type:Null<String>=""):Void
	{
		super();
		stars = new FlxStarField2D(80,-80,FlxG.height,FlxG.width,50);
		stars.angle=-90;
		add(stars);
		
		
		
		if(type=="new level")
		{
			levelMessage();
		}
		else if (type=="game over")
		{
			gameOverMessage();
		}
		else 
		{
			titleMessage();
		}

	}

	override public function destroy():Void
	{
		super.destroy();
	}

	
	override public function update():Void
	{
		super.update();
		
		if (wait_event)
		{
			
			timer -= FlxG.elapsed;
			if (timer < -3)
			{	
				timer=0;
				wait_event=false;	
				_parentState.closeSubState();
				Reg.dontRepeat=true;
			
			}
				
		}
		
		if (enable_click)
		{
			if (FlxG.keys.anyPressed(["CONTROL", "SPACE"]))
			{	
				_parentState.closeSubState();
				enable_click=false;	
				Reg.title=false;
					
			}
			
		}
		
	
		
		

	}	
	
	
	
	public function levelMessage():Void
	{
		Reg.level++;
		levelMsg = new FlxText(FlxG.width/2 -180 , FlxG.height/2-20);
		levelMsg.text="LEVEL "+Reg.level+" COMPLETE!";
		levelMsg.color=FlxColor.YELLOW;
		levelMsg.borderStyle=1;
		levelMsg.borderColor=FlxColor.RED;
		levelMsg.borderSize=5;
		levelMsg.size=30;
		levelMsg.antialiasing=true;
		add(levelMsg);	
		wait_event=true;

		
	}
	
	public function gameOverMessage():Void
	{
		levelMsg = new FlxText(FlxG.width/2 -110 , FlxG.height/2-20);
		levelMsg.text="GAME OVER";
		levelMsg.color=FlxColor.YELLOW;
		levelMsg.borderStyle=1;
		levelMsg.borderColor=FlxColor.RED;
		levelMsg.borderSize=5;
		levelMsg.size=30;
		levelMsg.antialiasing=true;
		add(levelMsg);	
		enable_click=true;
		Reg.dontRepeat=true;

	}
	public function titleMessage():Void
	{
		FlxG.sound.play("logo");
		levelMsg = new FlxText(FlxG.width/2 -200 , FlxG.height/2 -150);
		levelMsg.text="SSG";
		levelMsg.color=FlxColor.YELLOW;
		levelMsg.borderStyle=1;
		levelMsg.borderColor=FlxColor.RED;
		levelMsg.borderSize=5;
		levelMsg.size=200;
		levelMsg.antialiasing=true;
		add(levelMsg);	
		enable_click=true;
		
		
	}
	
	
}
