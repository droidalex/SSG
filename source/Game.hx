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
	private var boom:FlxSprite;
	private var fire:FlxSprite; 
	private var tiro:FlxSprite;
	private var enemies:FlxSpriteGroup;
	private var tiros:FlxSpriteGroup;
	private var tempo:Float=0;
	private var fired:Bool = false;
	private var SPscore:FlxText;
	private var score:Int=0;
	private var SPhiscore:FlxText;
	private var hiscore:Int=0;
	private var SPlives:FlxText;
	private var lives:Int=4;
	private var ncolor:Int;
	private var GameOver:Bool = true;
	private var gameTitle:FlxText;
	private var levelMsg:FlxText;
	private var gameSubTitle1:FlxText;
	private var level:Int = 1;
	private var passed:Bool = true;
	private var breath:Float = 0;
	private var ptimer:Float = 0;
	private var newStage:Bool = false;
	private var reset:Bool = false;
	private var explosion:Bool = false;
	private var veloc:Int=1;
	
	private var stars:FlxSpriteGroup;
	private var star:FlxSprite;
	
	override public function create():Void
	{		
			
		super.create();
		
		stars = new FlxSpriteGroup();
		for (f in 0...50)
		{
			star = new FlxSprite(FlxRandom.intRanged(0,FlxG.width),FlxRandom.intRanged(0,FlxG.height));
			star.makeGraphic(2,2,FlxColor.WHITE);
			stars.velocity.y=100;
			stars.add(star);
					
		}
		add(stars);
		
		
		
		//Creating text score
		SPscore = new FlxText(10,10);
		SPscore.text="SCORE: 0";
		SPscore.size=20;
		add(SPscore);
		
		//Creating text hi-score
		SPhiscore = new FlxText(250,10);
		SPhiscore.text="HI-SCORE: "+Reg.hiscore;
		SPhiscore.size=20;
		add(SPhiscore);
		
		//Creating text lives
		SPlives = new FlxText(530,10);
		SPlives.text="LIVES: "+lives;
		SPlives.size=20;
		add(SPlives);
			
		tiros = new FlxSpriteGroup();
		add(tiros);
		drawEnemies();
		drawTitle();
		
	}
	
	
	
	override public function destroy():Void
	{
		super.destroy();
		enemies=null;
		enemy=null;
		player=null;
	}

	
	override public function update():Void
	{
stars.forEach(resetStars);
				
		if (reset)
		{
			
			ptimer -= FlxG.elapsed;
			
			if (ptimer < -2)
			{
				ptimer=0;
				lives--;		
				reset=false;
				boom.kill();
				explosion=false;
				player.reset(FlxG.width/2-16,FlxG.height-64);
				
			}
			
			
		}
		
		if (lives==0)
		{
			FlxG.resetState();
			
		}
		
		if (FlxG.mouse.justPressed || newStage==true)
		{
			// Reset the enemies position
			enemies.kill();
			drawEnemies();
			// Titles Get lost! 
			gameTitle.kill();
			gameSubTitle1.kill();
			
			//Adding player	
			if (GameOver)
			{		
				player = new FlxSprite(FlxG.width/2-16,FlxG.height-64);
				player.loadGraphic("assets/ssg.png",true,32,32,false);
				player.animation.add("normal",[0,1,2,3,4],30,true);
				player.animation.play("normal");
				add(player);
			}
			//Flags
			GameOver=false;
			newStage=false;
				
			
		}
		else //Start the game stuff
		{
		
		
		// Updating score+hiscore+lives everytime
		SPscore.text="SCORE: "+score;
		//SPhiscore.text="HI-SCORE: "+hiscore;
		SPlives.text="LIVES: "+lives;

		// If all enemies are killed
		if (enemies.countLiving()==0 && passed)
		{
			//Show message
			drawLevelMsg();
			//This is a flag to avoid the level counter update.  
			passed=false;
			//Update level
			level++;	

		} 
		else if (enemies.countLiving()==0 && !passed)
		{
			// If the message was displayed as weel wait...
			gimmeTime();	
					
		}
		
		// If the score are greater then new hi-score
		if (score > hiscore)
		{
			Reg.hiscore=score;
		}
		
		// ---------------------------------------- player keys ----------------- 
		if (FlxG.keys.anyPressed(["A","LEFT"])&&!GameOver)
		{
			// if the player get out of the screen show player in the other side.
			if (player.x < 0)
			{
				player.reset(FlxG.width-32,FlxG.height-64);
			}
			player.velocity.x=-300;
		}
		else if (FlxG.keys.anyPressed(["D","RIGHT"])&&!GameOver)
		{
			//same above
			if (player.x > FlxG.width)
			{		
				player.reset(0,FlxG.height-64);
			}
			player.velocity.x=300;
		}
		
		if (FlxG.keys.anyPressed(["SPACE","CONTROL","Z"])&&!GameOver && !explosion)
		{
		
			PlayerFire();
			
		}
		else if (FlxG.keys.anyJustReleased(["SPACE","CONTROL","Z"])&&!GameOver && !explosion)
		{
			// If the fire is out of screen you can shot again
			if (!fire.isOnScreen())
			{
				fire.kill();
				fired=false;
			}
			
		}
		
		
		if (FlxG.keys.anyJustReleased(["A","D","LEFT","RIGHT"])&&!GameOver)
		{
			
			player.velocity.x=0;
						
		}
		//---------------------------------End player keys-------
		
				
		//Make each enemy do a "ping pong" in the walls
		enemies.forEach(zigzag);
		
	
		//And make them shoot every time
		enemies.forEach(shoot);
	
		
		
		//---------------------------collisions
		
		enemies.forEach(enemyHit);
		tiros.forEach(destroyTiro);
		FlxG.collide(tiros, player, Boom);
		FlxG.collide(enemy, player, Boom);

		super.update();
		
	}
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
			tiro = new FlxSprite(e.x+25,e.y+50);
			tiro.makeGraphic(3,6,FlxColor.RED);
			tiro.velocity.y=500;
			tiros.add(tiro);
			// After shoot, reload the time (reseting to 0)
			tempo=0;
		}
			
		
	}
	
	public function PlayerFire():Void
	{
		// Avoiding countless fire shoots
		if (!fired)
		{
			fire = new FlxSprite((player.x + player.width/2) - 2, player.y-64);
			fire.makeGraphic(4,10,FlxColor.YELLOW);
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
	
	public function drawEnemies():Void
	{
				// Put all enemies in a "sack".
		enemies = new FlxSpriteGroup(0,0);

		// creating 5 bad guys
		for (i in 0...5) 
		{	
	
			ncolor = FlxRandom.color(0,255);
			// Put enemies in the middle side by side		
			enemy = new FlxSprite(FlxG.width/4+80*i+15,10).loadGraphic("assets/enemies.png",false,32,32,false);
			// Every enemy have his "frame" in spritesheet 
			enemy.animation.add("A"+i,[i],1,false);
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
			enemies.add(enemy);
			
			
		}
		//...And put the whole group in stage(scene).
		add (enemies);
		
		
		
	}
	
	public function drawTitle():Void
	{
	gameTitle = new FlxText(FlxG.width/2 -200 , FlxG.height/2 -150);
	gameTitle.text="SSG";
	gameTitle.color=FlxColor.WHITE;
	gameTitle.borderStyle=1;
	gameTitle.borderColor=FlxColor.RED;
	gameTitle.borderSize=5;
	gameTitle.size=200;
	gameTitle.antialiasing=true;
	add(gameTitle);	
	
	gameSubTitle1 = new FlxText(FlxG.width/2 -250 , FlxG.height/2+100);
	gameSubTitle1.text="(MOUSE CLICK TO START)";
	gameSubTitle1.color=FlxColor.WHITE;
	gameSubTitle1.borderStyle=1;
	gameSubTitle1.borderColor=FlxColor.RED;
	gameSubTitle1.borderSize=5;
	gameSubTitle1.size=30;
	gameSubTitle1.antialiasing=true;
	add(gameSubTitle1);	
		
	}
	
	public function drawLevelMsg():Void
	{
	levelMsg = new FlxText(FlxG.width/2 -200 , FlxG.height/2-20);
	levelMsg.text="LEVEL "+level+" COMPLETE!";
	levelMsg.color=FlxColor.WHITE;
	levelMsg.borderStyle=1;
	levelMsg.borderColor=FlxColor.RED;
	levelMsg.borderSize=5;
	levelMsg.size=30;
	levelMsg.antialiasing=true;
	add(levelMsg);	
	veloc+=5;

	
	
	}
	
	public function gimmeTime():Void
	{
		breath -= FlxG.elapsed;
		
		if (breath <= -5)
		{
			newStage = true;
			drawEnemies();
			levelMsg.kill();
			passed=true;
			breath=0;
				
		}
		else
		{
			
		}
			
			
	}


	public function Boom(tiro:FlxSprite,player:FlxSprite):Void
	{
		explosion=true;
		boom = new FlxSprite(player.x,player.y);
		boom.loadGraphic("assets/boom.png",true,32,32,false);
		add(boom);
		boom.angularVelocity=300;
		player.kill();
		
		reset=true;
		
	}
	

	
	public function destroyTiro(t:FlxSprite)
	{
		if (!t.isOnScreen())
		{
			t.kill();
		}
	}
	
	public function resetStars(s:FlxSprite)
	{
		
		if (s.y >= FlxG.height)
		{			
			s.reset(FlxRandom.intRanged(0,FlxG.width),FlxRandom.intRanged(0,FlxG.height));
			
		}
		
	}
	
}
