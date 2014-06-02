package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.group.FlxSpriteGroup;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.util.FlxColor;
import flixel.util.FlxRandom;

/* 
 * This is a "silly space game". 
 * The main purpose of this is to make
 * a simple haxeflixel example
 * to put in my blog, and then people
 * will see how easy is to create a game
 * with haxeflixel. 
 *  
 * It's not a serious project. 
 * It is a game! (^_^)//
 * 
 * It's 2:40 a.m. LOL!
 *
 */ 
 

class Game extends FlxState
{
	private var enemy:FlxSprite; 
	private var player:FlxSprite;
	private var fire:FlxSprite; 
	private var enemies:FlxSpriteGroup;
	private var tempo:Float=0;
	private var fired:Bool = false;
	private var SPscore:FlxText;
	private var score:Int=0;
	private var SPhiscore:FlxText;
	private var hiscore:Int=0;
	private var SPlives:FlxText;
	private var lives:Int=4;

	
	override public function create():Void
	{		
			
		super.create();
		
		//FlxG.camera.bgColor=FlxColor.GREEN;
		
		player = new FlxSprite(FlxG.width/2-16,FlxG.height-32);
		player.makeGraphic(32,32,FlxColor.BROWN);
		add(player);
		
		// Put all enemies in a "sack".
		enemies = new FlxSpriteGroup(0,0);

		// creating 5 bad guys
		for (i in 0...5) 
		{	
								// This is a messy formula to center 'em. I will change this. 		
			enemy = new FlxSprite(FlxG.width/4+80*i+15,10).makeGraphic(32,32,FlxRandom.color(0,255));
			
			// Left or right?
			var sorteio:Int = FlxRandom.intRanged(1,2);
		
			var numb;
		
			// If 1 go right. Else go left.
			if (sorteio==1)
			{
				numb=100;
			}
			else
			{
				numb=-100;
			}
			enemy.velocity.x=numb;
			
		
			// Enemies should go to the bottom of screen pretty slow...
			enemy.acceleration.y=1;
			
			//Put this born dude into enemies group.
			enemies.add(enemy);
			
		}
		//...And put the whole group in stage(scene).
		add (enemies);
		
		
		SPscore = new FlxText(10,10);
		SPscore.text="SCORE: 0";
		SPscore.size=20;
		add(SPscore);
		
		SPhiscore = new FlxText(250,10);
		SPhiscore.text="HI-SCORE: "+hiscore;
		SPhiscore.size=20;
		add(SPhiscore);
		
		SPlives = new FlxText(530,10);
		SPlives.text="LIVES: "+lives;
		SPlives.size=20;
		add(SPlives);
		
		
	}
	
	
	override public function destroy():Void
	{
		super.destroy();
	}

	
	override public function update():Void
	{
		// Updating score+hiscore
		SPscore.text="SCORE: "+score;
		SPhiscore.text="HI-SCORE: "+hiscore;
		
		if (enemies.countLiving()==0)
		{
			trace ("new Stage");
		}
		
		if (score > hiscore)
		{
			hiscore=score;
		}
		
		if (FlxG.keys.anyPressed(["A","LEFT"]))
		{
			// if the player get out of the screen show player in the other side.
			if (player.x <= -32)
			{
				player.reset(FlxG.width-32,FlxG.height-32);
			}
			player.velocity.x=-300;
		}
		else if (FlxG.keys.anyPressed(["D","RIGHT"]))
		{
			//same above
			if (player.x > FlxG.width+32)
			{		
				player.reset(0,FlxG.height-32);
			}
			player.velocity.x=300;
		}
		
		if (FlxG.keys.anyPressed(["SPACE","CONTROL","Z"]))
		{
		
			PlayerFire();
			
		}
		else if (FlxG.keys.anyJustReleased(["SPACE","CONTROL","Z"]))
		{
			// If the fire is out of screen you can shot again
			if (!fire.isOnScreen())
			{
				fire.kill();
				fired=false;
			}
			
		}
		
		
		if (FlxG.keys.anyJustReleased(["A","D","LEFT","RIGHT"]))
		{
			
			player.velocity.x=0;
						
		}
		
		
		
		
		
		//Make each enemy do a "ping pong" in the walls
		enemies.forEach(zigzag);
		
		//And make them shoot every time
		enemies.forEach(shoot);
		
		
		//---------------------------collisions
		
		enemies.forEach(enemyHit);
		

		super.update();
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
	
	// Shoot every 1 elapsed time, every enemy.
	public function shoot(e:FlxSprite):Void
	{
		tempo -= FlxG.elapsed;
		
		if (tempo <= -1 && e.exists)
		{	
			//creating a shoot graphic.	
			var tiro:FlxSprite = new FlxSprite(e.x+25,e.y+50);
			tiro.makeGraphic(3,6,FlxColor.RED);
			tiro.velocity.y=500;
			add(tiro);
			// After shoot, reload the time (reseting to 0)
			tempo=0;
		}
		
		
	}
	
	public function PlayerFire():Void
	{
		if (!fired)
		{
			fire = new FlxSprite((player.x + player.width/2) - 2, player.y);
			fire.makeGraphic(4,8,FlxColor.YELLOW);
			fire.velocity.y=-3000;
			add(fire);
			fired=true;
		}
		
		
	}
	
	public function enemyHit(enemy:FlxSprite){
		
		
		FlxG.collide(enemy, fire, dieEnemy);
		
		
	} 
	
	public function dieEnemy(e:FlxSprite, fire:FlxSprite)
	{
		
		e.kill();
		score+=10;
		
	}
	
}
