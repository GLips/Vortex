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
		[Embed(source="../Sounds/popIn_00.mp3")]
        public var S_popIn:Class;

		// Animation stuff
		protected var exploding:Boolean;

		// Tracks when to spawn the next enemy
		protected var nextSpawn:Number;

		// Show center button or edge button?
		protected var useCenterButton:Boolean;

		// Interpolators
		protected var buttonPopInterpolator:FInterpolator;

		// Track/display current round info
		protected var roundTime:Number;
		protected var roundNum:int;
		protected var timeLeft:Number;
		protected var droundNum:FText;
		protected var dtimeLeft:FText;

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
			Add(player);

			numToAdd = 0;
			nextSpawn = 0;
			roundTime = 0;

			timeLeft = 60;		// 1 minute long round
			dtimeLeft = new FText(0, 25, "60.0");
			dtimeLeft.UpdateFormat();
			dtimeLeft.CenterText().CenterX();
			zone_GUI.Add(dtimeLeft);

			buttonPopInterpolator = new FInterpolator();
			buttonPopInterpolator.AddValue(0.5, 1.25);
			buttonPopInterpolator.AddValue(0.75, 0.75);
			buttonPopInterpolator.ChangeMethod(FInterpolator.SPLINE);

			droundNum = new FText(0, 10, "Round: "+roundNum);
			droundNum.size = 24;
			droundNum.UpdateFormat();
			droundNum.x = FG.width - droundNum.width - 25;
			zone_GUI.Add(droundNum);

			FNoise.seed = Math.random() * 99999999;

			newRound();
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

			timeLeft -= FG.dt;
			roundTime += FG.dt;

			updateGUI();

			nextSpawn += FG.dt;
			if(nextSpawn > 0.05 && numToAdd > 0)
				spawnDebris();

			for each(var e:Debris in enemies.members)
			{
				e.explode = exploding;

				if(e != null && FCollide.CircleCircle(player.collision as FCircle, e.collision as FCircle))
				{
					e.Explode();
					exploding = true;
					removeButtons();
					Add(new FTimer(2, gameOver));
				}
				else
				{
					e.isColliding = false;
				}
			}

			if(timeLeft <= 0)
				gameOver();

			//b = new Bitmap(bd);
		}

		private function updateGUI():void
		{
			dtimeLeft.UpdateText( String(FMath.Round(timeLeft, 2)) );
			droundNum.UpdateText( "Round: "+roundNum);

			if(timeLeft <= 10)
			{
				dtimeLeft.scaleX = dtimeLeft.scaleY = (Math.abs(Math.sin(timeLeft * 3)) * 1.5) + 1;
			}

			if(roundTime < 0.25)
			{
				if(!useCenterButton)
				{
					centerButton.scaleX = centerButton.scaleY = buttonPopInterpolator.GetValue(roundTime * 4);
				}
				else
				{
					leftButton.scaleX = rightButton.scaleX = buttonPopInterpolator.GetValue(roundTime * 4);
				}
			}
			else
			{
				if(!useCenterButton)
					centerButton.scaleX = centerButton.scaleY = 1;
				else
				{
					leftButton.scaleX = rightButton.scaleX = 1;
				}
			}

			if(timeLeft < 5)
			{
				var i:FInterpolator = new FInterpolator();
				i.AddValue(0.5, 1);
				i.AddValue(1, 0);
				var mod:Number = i.GetValue((timeLeft%2)/2);

				zone_BG.graphics.clear();
				zone_BG.graphics.beginFill(FColor.RGBtoHEX(255, 255 * mod, 255 * mod));
				zone_BG.graphics.drawRect(0, 0, FG.width, FG.height);
				zone_BG.graphics.endFill();
			}
		}

		private function gameOver():void
		{
			Global.recentScore = roundNum;
			FG.SwitchScene(new RoundOver());
		}

		private function newRound():void
		{
			if(!exploding)
			{
				// New round
				roundNum++;
				roundTime = 0;

				placeButtons();

				FG.soundEngine.Play(new S_click());

				//enemies.Destroy();

				numToAdd += (roundNum/10) + 1;
				
				// New button location for next round
				useCenterButton = !useCenterButton;
			}
		}

		private function spawnDebris():void
		{
			nextSpawn = 0;
			FG.soundEngine.Play(new S_popIn());
			var i:int = enemies.length;
			enemies.Add(new Debris(randColor(i*0.0075), randColor(i*0.0075 + 2), randColor(i*0.0075 + 4), noise(i*0.01)));
			numToAdd--;
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
				leftButton.onOver = newRound;
				leftButton.pointToCheck = player.collision;
				Add(leftButton);

				rightButton = new FRectButton(FG.width - buttonWidth, 0, buttonWidth, FG.height);
				rightButton.onOver = newRound;
				rightButton.pointToCheck = player.collision;
				Add(rightButton);
			}
		}

		private function randColor(x:Number):int
		{
			return Math.round(noise(x) * 230) + 25;
		}

		private function noise(x:Number):Number
		{
			return FNoise.noise(x,x,x);
		}
	}
}