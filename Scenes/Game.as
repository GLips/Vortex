package Vortex.Scenes
{
	// Flash
	import flash.display.BitmapData;
	import flash.display.Bitmap;


	// Framework
	import Framework.GUI.FText;
	import Framework.GUI.Buttons.FRectButton;
	import Framework.GUI.Buttons.FCircleButton;

	import Framework.FG;
	import Framework.FGroup;
	import Framework.FScene;

	import Framework.Shapes.FRect;
	import Framework.Shapes.FCircle;

	import Framework.Utils.FCollide;
	import Framework.Utils.FNoise;
	import Framework.Utils.FColor;
	import Framework.Utils.FTimer;
	import Framework.Utils.FInterpolator;

	import Framework.Maths.FVec;
	import Framework.Maths.FPoint;
	import Framework.Maths.FMath;
	import Framework.Maths.FEasing;


	// Vortex
	import Vortex.Player;
	import Vortex.Debris;
	import Vortex.Global;

	public class Game extends GeneralScene
	{

		protected var numToAdd:int;
		protected var enemies:FGroup;
		protected var player:Player;

		protected var bd:BitmapData;
		protected var b:Bitmap;

		protected var centerButton:FCircleButton;
		protected var leftButton:FRectButton;
		protected var rightButton:FRectButton;

		// Sound!
		[Embed(source="../Sounds/click.mp3")]
        public var S_click:Class;
		[Embed(source="../Sounds/popIn_06.mp3")]
		public var S_popIn0:Class;

		// Animation stuff
		protected var exploding:Boolean;

		// Tracks when to spawn the next enemy
		protected var nextSpawn:Number;

		// Show center button or edge button?
		protected var useCenterButton:Boolean;

		// Interpolators
		protected var buttonPopInterpolator:FInterpolator;

		protected var gameStarted:Boolean;
		protected var gameDone:Boolean;

		// Track/display current round info
		protected var roundTime:Number;
		protected var roundNum:int;
		protected var timeLeft:Number;
		protected var droundNum:FText;
		protected var dtimeLeft:FText;

		// 
		protected var dtimeAdded:FText;
		protected var justAdded:Number;

		// Random colors
		protected var redAdd:Number;
		protected var greenAdd:Number;
		protected var blueAdd:Number;

		protected var offset:Number;

		protected var dinitialCountdown:FText;

		// First time instructions
		protected var enemyTracker:FText;
		protected var instructionsLeft:FText;
		protected var instructionsRight:FText;

		public function Game():void
		{
			super();
		}

		override public function Create():void
		{
			// Keep the bitmap behind everything else
			bd = new BitmapData(FG.width, FG.height, false, 0xFFFFFF);
			b = new Bitmap(bd);
			addChild(b);

			super.Create();

			enemies = new FGroup();
			Add(enemies);
			player = new Player();

			numToAdd = 0;
			nextSpawn = 0;
			roundTime = 0;

			if(!Global.hasPlayed)
			{
				enemyTracker = new FText(0,0, "Avoid debris =>");
				instructionsLeft = new FText(20,0, "<= Mouse over this bar");
				instructionsRight = new FText(FG.width - 140,0, "or this bar =>\nto start!");
				instructionsLeft.size = 20;
				instructionsRight.size = 20;
				instructionsLeft.UpdateFormat();
				instructionsRight.UpdateFormat();
				instructionsLeft.CenterY();
				instructionsRight.CenterY();
				Add(enemyTracker);
				Add(instructionsLeft);
				Add(instructionsRight);
			}

			dtimeAdded = new FText();
			dtimeAdded.alpha = 0;
			dtimeAdded.textColor = 0x33CC33;
			dtimeAdded.size = 25;
			dtimeAdded.UpdateFormat();
			dtimeAdded.CenterX(50);
			dtimeAdded.y = 25;
			Add(dtimeAdded);

			gameDone = false;

			redAdd = Math.random() * 100 + 30;
			greenAdd = Math.random() * 100 + 30;
			blueAdd = Math.random() * 100 + 30;

			offset = Math.random() * 9999;

			timeLeft = 5;		// 5 second long round
			dtimeLeft = new FText(0, 40, "5");
			dtimeLeft.size = 50;
			dtimeLeft.textAlign = FText.ALIGN_CENTER;
			dtimeLeft.UpdateFormat();
			dtimeLeft.CenterText().CenterX();
			zone_GUI.Add(dtimeLeft);

			buttonPopInterpolator = new FInterpolator();
			buttonPopInterpolator.AddValue(0.5, 1.25);
			buttonPopInterpolator.AddValue(0.75, 0.75);
			buttonPopInterpolator.ChangeMethod(FInterpolator.SPLINE);

			droundNum = new FText(0, 10, "Score: "+roundNum);
			droundNum.size = 24;
			droundNum.UpdateFormat();
			droundNum.x = FG.width - droundNum.width - 25;
			zone_GUI.Add(droundNum);

			gameStarted = true;
			newRound();
			gameStarted = false;
			roundTime = 1;
		}

		override public function Destroy():void
		{
			droundNum = null;
			dtimeLeft = null;

			centerButton = null;
			leftButton = null;
			rightButton = null;

			enemies = null;

			buttonPopInterpolator = null;
		}

		override public function Update():void
		{
			super.Update();

			if(!gameStarted)
			{
				Add(player);
				player.x = FG.mouse.x;
				player.y = FG.mouse.y;
				//zone_GUI.Remove(dinitialCountdown);
				//dinitialCountdown = null;
				gameStarted = true;
			}
			
			roundTime += FG.dt;
			justAdded += FG.dt;

			updateGUI();

			if(numToAdd > 0)
				spawnDebris();

			if(instructionsRight != null)
			{
				updateInstructions();
			}
			else
			{
				timeLeft -= FG.dt;
			}

			for each(var e:Debris in enemies.members)
			{
				e.explode = exploding;

				if(e != null && FCollide.CircleCircle(player.collision as FCircle, e.collision as FCircle))
				{
					e.Explode();
					exploding = true;
					removeButtons();
					Add(new FTimer(1, gameOver));
				}
				else
				{
					e.isColliding = false;
				}
			}

			if(timeLeft <= 0)
				gameOver();
		}

		private function updateGUI():void
		{
			dtimeLeft.UpdateText( String(FMath.Round(timeLeft, 2)) );
			//dtimeLeft.CenterText();
			droundNum.UpdateText( "Score: "+roundNum);

			if(justAdded <= 1)
			{
				dtimeAdded.alpha = 1 - justAdded;

			}
			else
			{
				dtimeAdded.alpha = 0;
			}

			if(timeLeft <= 3)
			{
				var i:FInterpolator = new FInterpolator();
				i.AddValue(0, 0.5);
				i.AddValue(0.50, 1);
				i.AddValue(1, 0.5);
				var mod:Number = i.GetValue((timeLeft%1));

				dtimeLeft.scaleX = dtimeLeft.scaleY = 2 * mod;

				if(timeLeft < 1.5)
				{
					zone_BG.graphics.clear();
					zone_BG.graphics.beginFill(FColor.RGBtoHEX(255, 255 * mod, 255 * mod));
					zone_BG.graphics.drawRect(0, 0, FG.width, FG.height);
					zone_BG.graphics.endFill();
				}
			}
			else
			{
				dtimeLeft.scaleX = dtimeLeft.scaleY = 1;

				zone_BG.graphics.clear();
				zone_BG.graphics.beginFill(0xFFFFFF);
				zone_BG.graphics.drawRect(0, 0, FG.width, FG.height);
				zone_BG.graphics.endFill();
			}

			if(roundTime < 0.25)
			{
				if(!useCenterButton)
				{
					centerButton.scaleX = centerButton.scaleY = buttonPopInterpolator.GetValue(roundTime * 4);
				}
				else
				{
					leftButton.scaleX = buttonPopInterpolator.GetValue(roundTime * 4)
					rightButton.scaleX = -buttonPopInterpolator.GetValue(roundTime * 4);
				}
			}
			else
			{
				if(!useCenterButton)
					centerButton.scaleX = centerButton.scaleY = 1;
				else
				{
					leftButton.scaleX = 1;
					rightButton.scaleX = -1;
				}
			}
		}

		private function updateInstructions():void
		{
			if(enemyTracker != null)
			{
				enemyTracker.x = enemies.members[0].x - enemyTracker.width - 10;
				enemyTracker.y = enemies.members[0].y - enemyTracker.height/2;
			}

			if(enemies.length == 2 && instructionsLeft != null)
			{
				instructionsRight.UpdateText("Now mouse back over this");
				instructionsRight.CenterX().CenterY(-100);

				Remove(instructionsLeft);
				instructionsLeft.Destroy();
				instructionsLeft = null;
			}
			else if(enemies.length == 3 && enemyTracker != null)
			{
				instructionsRight.UpdateText("Now get the high score!");
				instructionsRight.CenterX().CenterY(-100);

				Remove(enemyTracker);
				enemyTracker.Destroy();
				enemyTracker = null;
			}
			else if(enemies.length > 3)
			{
				Remove(instructionsRight);
				instructionsRight.Destroy();
				instructionsRight = null;
			}
		}

		private function gameOver():void
		{
			if(!gameDone)
			{
				Global.recentScore = roundNum;
				FG.SwitchScene(new RoundOver(), transition, 1);
				gameDone = true;
			}
		}

		private function newRound():void
		{
			if(!exploding && gameStarted)
			{
				// New round
				dtimeAdded.UpdateText("+"+FMath.Round(5 - timeLeft, 2)+"s");


				roundNum++;
				roundTime = 0;
				timeLeft = 5;
				justAdded = 0;

				placeButtons();

				FG.soundEngine.Play(new S_click());

				numToAdd += (roundNum/10) + 1;
				
				// New button location for next round
				useCenterButton = !useCenterButton;
			}
		}

		private function spawnDebris():void
		{
			// mod
			var i:Number;
			
			// colors
			var r:Number;
			var g:Number;
			var b:Number;

			var dist:Number;


			FG.soundEngine.Play(new S_popIn0());
			for(var x:int = 0; x < numToAdd; x++)
			{
				i = (enemies.length * 0.005) + offset;
				dist = noise(i*4);

				r = randColor(i + 100)// * (255 - redAdd) + redAdd;
				g = randColor(i + 200)// * (255 - greenAdd) + greenAdd;
				b = randColor(i + 300)// * (255 - blueAdd) + blueAdd;
				
				enemies.Add(new Debris(r, g, b, dist));
			}
			numToAdd = 0;
		}

		private function removeButtons():void
		{
			if(useCenterButton)
			{
				Remove(rightButton);
				Remove(leftButton);
			}
			else
			{
				Remove(centerButton);
			}
		}

		private function placeButtons():void
		{
			if(useCenterButton)
			{
				Remove(rightButton);
				Remove(leftButton);
				centerButton = new FCircleButton(0, 0, "");
				centerButton.radius = 50;
				centerButton.draws = true;
				centerButton.onOver = newRound;
				centerButton.pointToCheck = player.collision;
				centerButton.CenterX().CenterY();
				Add(centerButton);
			}
			else
			{
				if(roundNum > 1)
					Remove(centerButton);

				var buttonWidth:int = 20;
				leftButton = new FRectButton(0, 0, buttonWidth, FG.height);
				// Make the collision box larger in case player goes off screen
				leftButton.collision = new FRect(-buttonWidth * 2, 0, buttonWidth * 3, FG.height);
				leftButton.Draw();
				leftButton.onOver = newRound;
				leftButton.pointToCheck = player.collision;
				Add(leftButton);

				rightButton = new FRectButton(FG.width, 0, buttonWidth, FG.height);
				rightButton.scaleX = -1;
				// Make the collision box larger in case player goes off screen
				rightButton.collision = new FRect(rightButton.x - buttonWidth, rightButton.y, buttonWidth * 3, FG.height)
				rightButton.Draw();
				rightButton.onOver = newRound;
				rightButton.pointToCheck = player.collision;
				Add(rightButton);
			}
		}

		private function randColor(x:Number):int
		{
			return Math.round(noise(x) * 230) + 25;
		}

		// Returns a number between 0 and 1
		private function noise(x:Number):Number
		{
			return Math.abs(FNoise.noise(x));
		}
	}
}