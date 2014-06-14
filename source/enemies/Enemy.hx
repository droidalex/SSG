package enemies;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxRandom;
import flixel.util.FlxColor;

class Enemy extends FlxSpriteGroup
{
	private var enemy:FlxSprite;
	private var game:Game;
	private var ncolor:Int;
	private var veloc:Int=1;
	private var player:Ship;


	function new(game:Game, player:Ship)
	{
		super();
		
		this.player = player;

		for (i in 0...5) 
		{	
	
			ncolor = FlxRandom.color(0,255);
			// Put enemies in the middle side by side		
			enemy = new FlxSprite(FlxG.width/4+80*i+15,64).loadGraphic("assets/enemies.png",false,32,32,false);
			// Every enemy have his "frame" in spritesheet 
			var a:Int = (i*3);
			var b:Int = (i*3+1);
			var c:Int = (i*3+2);
			
			
			enemy.animation.add("A"+i,[a,b,c],8,true);
			
			enemy.animation.play("A"+i);
			enemy.maxVelocity.y=800;
			enemy.antialiasing=true;
			
			// Left or right?
			var sorteio:Int = FlxRandom.intRanged(1,2);
		
			var numb;
		
			// If 1 go right. Else go left.
			if (sorteio==1)
			{
				numb=200;
			}
			else
			{
				numb=-200;
			}
			enemy.velocity.x=numb;
			
		
			// Enemies should go to the bottom of screen pretty slow...
			enemy.velocity.y=veloc;
			
			//Put this born dude into enemies group.
			this.add(enemy);
						
		}
			
	}
	
	override public function update()
	{
		super.update();
		//Make each enemy do a "ping pong" in the walls
		this.forEach(zigzag);
		
	}
	
	
	public function zigzag(e:FlxSprite):Void
	{
		// If position of enemy is greater then screen (minus his width) 
		// or he will get out of screen or smaller than zero. Change direction. Else if
		// this bad guy reached the bottom of screen, reappear in top. 
		if (e.x>=FlxG.width-50 || e.x<0)
		{
			e.velocity.x=-e.velocity.x;
		}
		else if (e.y > FlxG.height+50)
		{
			e.y=-60;
		
		}
		
	}
	

	
}
