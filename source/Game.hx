package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.addons.display.FlxStarField;
import enemies.Enemy;
import flixel.system.FlxSound;
import flixel.addons.plugin.control.FlxControl;
import flixel.addons.plugin.control.FlxControlHandler;
import flixel.addons.weapon.FlxBullet;
import flixel.addons.weapon.FlxWeapon;
import flixel.util.FlxColor;
import flixel.group.FlxSpriteGroup;
import flixel.group.FlxGroup;
import flixel.util.FlxDestroyUtil;

class Game extends FlxState
{
	private var player:Ship;
	private var chao:FlxSprite;
	private var stars:FlxStarField2D;
	private var SPscore:FlxText;
	private var score:Int=0;
	private var level:Int = Reg.level;
	private var SPhiscore:FlxText;
	private var hiscore:Int=0;
	private var SPlives:FlxText;
	private var lives:Int=4;
	private var enemy:Enemy;
	private var soundShoot:FlxSound;
	private var musica:FlxSound;
	private var laser:FlxWeapon;
	private var tempo:Float=0;
	private var tiro:FlxSprite;
	private var tiros:FlxSpriteGroup;
	private var enemy_wait:Bool = true;
	private var enemy_time:Float = 0;
	private var boom:FlxSprite;
	private var player_die:Bool = false;
	private var ptimer:Float = 0;
	private var msg:Message;
		
	override public function create():Void
	{	
		msg = new Message();
		openSubState(msg);
		//Creating stars	
		stars = new FlxStarField2D(80,-80,FlxG.height,FlxG.width,50);
		stars.angle=-90;
		add(stars);
		
		soundShoot = new FlxSound();
		soundShoot.loadEmbedded("shoot",false,false);
		
		musica = new FlxSound();
		musica.loadEmbedded("SSG",true);
		
		//Hidding mouse cursor
		FlxG.mouse.visible = false;
		
		//Creating text score
		SPscore = new FlxText(10,10);
		SPscore.borderStyle=1;
		SPscore.borderColor=FlxColor.RED;
		SPscore.borderSize=5;
		SPscore.text="SCORE: "+Reg.score;
		SPscore.color=FlxColor.YELLOW;
		SPscore.size=20;
		add(SPscore);
		
		//Creating text hi-score
		SPhiscore = new FlxText(250,10);
		SPhiscore.text="HI-SCORE: "+Reg.hiscore;
		SPhiscore.borderStyle=1;
		SPhiscore.color=FlxColor.YELLOW;
		SPhiscore.borderColor=FlxColor.RED;
		SPhiscore.borderSize=5;
		SPhiscore.size=20;
		add(SPhiscore);
		
		//Creating text lives
		SPlives = new FlxText(530,10);
		SPlives.text="LIVES: "+lives;
		SPlives.borderStyle=1;
		SPlives.color=FlxColor.YELLOW;
		SPlives.borderColor=FlxColor.RED;
		SPlives.borderSize=5;
		SPlives.size=20;
		add(SPlives);
		//Creating player
		player = new Ship(FlxG.width/2-16,FlxG.height-64,this);
		add(player);
		//Creating enemy
			
		createEnemy();	
		
		//Creating player shoots
		laser = new FlxWeapon("laser", player, FlxBullet, 1);
		laser.makeImageBullet(10, "assets/p_shoot.png", 12,0,false,0,0,true,true);
		laser.setBulletDirection(FlxWeapon.BULLET_UP, 200);
		laser.setBulletSpeed(1000);
		
		//Creating player controls
		FlxControl.create(player, FlxControlHandler.MOVEMENT_ACCELERATES, FlxControlHandler.STOPPING_DECELERATES, 1, true, false);
		FlxControl.player1.setCursorControl(false, false, true, true);
		FlxControl.player1.setMovementSpeed(600, 0, 300, 0, 400, 0);
		FlxControl.player1.setFireButton("CONTROL", FlxControlHandler.KEYMODE_PRESSED, 250, laser.fire);
		FlxControl.player1.setSounds(null,soundShoot,null,null);// <--------------------------Sounds:Jump,Fire,Walk,Thrust
		
		//Add player shoots to game
		add(laser.group);
		
		//Enabling plugin FlxControl
		if (FlxG.plugins.get(FlxControl) == null)
		{
			FlxG.plugins.add(new FlxControl());
		}
		super.create();
	}
	

	override public function update():Void
	{
		
		if (!Reg.title)
		{
			musica.play();
			Reg.title=true;
			
		}
	
		
		
		if (player.x <= 0)
		{
			player.x=FlxG.width-32;
		}
		else if (player.x >= FlxG.width)
		{		
			player.x=0;
		}
		// Updating score+hiscore+lives everytime
		SPscore.text="SCORE: "+Reg.score;
		SPhiscore.text="HI-SCORE: "+Reg.hiscore;
		//SPhiscore.text="HI-SCORE: "+hiscore;
		SPlives.text="LIVES: "+lives;
		
		if (enemy.countLiving()==0 && !Reg.dontRepeat)
		{
			soundShoot.kill();
			msg = new Message("new level");
			openSubState(msg);
			laser.group.kill();			
		}
		else if (enemy.countLiving()==0 && Reg.dontRepeat)
		{
			createEnemy();
			enemy.velocity.y+=5;
			Reg.dontRepeat=false;
			laser.group.revive();
			soundShoot.revive();
		}
		
		if (lives < 0 && !Reg.dontRepeat)
		{		
			musica.kill();
			soundShoot.kill();
			msg = new Message("game over");
			if (Reg.score>Reg.hiscore)
			{
				Reg.hiscore = Reg.score;
			}
			openSubState(msg);
			enemy.kill();
			createEnemy();
		}
		else if (lives < 0 && Reg.dontRepeat)
		{
			lives=4;
			Reg.level=0;
			Reg.score=0;
			Reg.dontRepeat=false;
			msg = new Message();
			openSubState(msg);
			soundShoot.revive();
			Reg.title=false;
			musica.revive();

		}
		
		
		/* If player die: 
		 * wait,
		 * decrease life,
		 * clear explosion
		 * and reset position 
		 */
		if (player_die)
		{
			
			ptimer -= FlxG.elapsed;
			tiros.kill();
			
			if (ptimer < -2)
			{
				ptimer=0;
				lives--;		
				player_die=false;
				boom.kill();
				player.reset(FlxG.width/2-16,FlxG.height-64);
				laser.group.revive();
				tiros.revive();
				soundShoot.revive();

			}
			
			
		}
		
		/*
		 * This part is to 
		 * avoid enemy
		 * shoot without
		 * player being prepared.
		 * Wait or Shoot.
		 */
		if (enemy_wait)
		{
			enemy_time -= FlxG.elapsed;
			if (enemy_time <= -3)
			{
				//enemy.forEach(shoot);
				enemy_wait=false; 
				enemy_time=0;
				
			}	
					
		}
		else
		{
			enemy.forEach(shoot);

		}
			
		// FlxG.collide(enemy, laser.group, dieEnemy); <-- This don't work in Flash
		// so I had to force a little bit:
		laser.group.forEach(collideLaser);
		
		//Collision between Enemy shoots (tiros) and player, calling function "Boom". 
		FlxG.collide(tiros, player, Boom);
		FlxG.collide(enemy, player, Boom);
		
		super.update();
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
			// After shoot, reload (reseting to 0)
			tempo=0;
		}
			
		
	}
	
	//----- Player's death function
	public function Boom(tiro:FlxSprite,player:FlxSprite):Void
	{		
		soundShoot.kill();

		FlxG.sound.play("explode");
		boom = new FlxSprite(player.x,player.y);
		boom.loadGraphic("assets/boom.png",true,32,32,false);
		add(boom);
		
		// Nice rotating effect to explosion.
		boom.angularVelocity=300;
		
		//Clearing enemy and... 
		player.kill();
		
		//...avoiding "ghost shoots" comming from explosion.
		laser.group.kill();
		
		//Flag to clear explosion
		player_die=true;
		
		
		//Flag to make enemy wait
		enemy_wait=true;
		
	}
	
	//---- Enemy's death function
	public function dieEnemy(e:FlxSprite, fire:FlxSprite)
	{
		FlxG.sound.play("zap");
		e.kill();
		Reg.score+=10;
		
	}
	
	//---- this to collision work in flash for every enemy. 
	public function collideLaser(l:FlxSprite):Void
	{		
		FlxG.overlap(enemy,l,dieEnemy);
	}
	
	public function createEnemy():Void
	{
		enemy = new Enemy(this, player);
		tiros = new FlxSpriteGroup();
		add(tiros); // <-- tiros = Enemy shoots
		add(enemy);
		
	}
	
	override public function destroy():Void
	{
		enemy = FlxDestroyUtil.destroy(enemy);
		player = FlxDestroyUtil.destroy(player);
		tiros = FlxDestroyUtil.destroy(tiros);
		musica = FlxDestroyUtil.destroy(musica);
		soundShoot = FlxDestroyUtil.destroy(soundShoot);
		boom = FlxDestroyUtil.destroy(boom);
		laser.group = FlxDestroyUtil.destroy(laser.group);
		msg = FlxDestroyUtil.destroy(msg);
		enemy=null;
		player=null;
		tiros=null;
		musica=null;
		soundShoot=null;
		boom=null;
		laser.group=null;
		msg=null;
				
		super.destroy();
	}
	
}
