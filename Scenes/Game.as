package Vortex.Scenes
{

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

	import Framework.Maths.FVec;
	import Framework.Maths.FPoint;
	import Framework.Maths.FMath;

	import flash.display.BitmapData;
	import flash.display.Bitmap;

	import Vortex.Player;
	import Vortex.Debris;

	public class Game extends GeneralScene
	{

		protected var enemies:FGroup;
		protected var player:Player;

		protected var bd:BitmapData;
		protected var b:Bitmap;

		protected var centerButton:FCircleButton;
		protected var leftButton:FRectButton;
		protected var rightButton:FRectButton;

		// Sound!
		[Embed(source="Sounds/roundOver.mp3")]
        public var S_roundOver:Class;

		// Animation stuff
		protected var exploding:Boolean;

		// Show center button or edge button?
		protected var useCenterButton:Boolean;

		// Track/display current round info
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

			timeLeft = 60;		// 1 minute long round
			dtimeLeft = new FText(0, 25, "60.0");
			dtimeLeft.UpdateFormat();
			dtimeLeft.CenterText().CenterX();
			zone_GUI.Add(dtimeLeft);

			droundNum = new FText(0, 10, "Round: "+roundNum);
			droundNum.size = 24;
			droundNum.UpdateFormat();
			droundNum.x = FG.width - droundNum.width - 25;
			zone_GUI.Add(droundNum);

			FNoise.seed = Math.random() * 99999999;

			newRound();
		}

		override public function Update():void
		{
			super.Update();

			timeLeft -= FG.dt;

			updateGUI();

			for each(var e:Debris in enemies.members)
			{
				e.explode = exploding;

				if(e != null && FCollide.CircleCircle(player.collision, e.collision))
				{
					e.Explode();
					exploding = true;
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
				dtimeLeft.scaleX = (Math.sin(timeLeft/100) * 0.5) + 1.5;
				dtimeLeft.scaleY = (Math.sin(timeLeft/100) * 0.5) + 1.5;
			}
			// This is a bad abstraction, I need to make an interpolator for this.
			if(timeLeft < 5)
			{
				var alarmTime:int = (timeLeft % 1250) - 749;
				var mod:Number = FMath.Clamp(Math.abs(alarmTime)/525);

				zone_BG.graphics.clear();
				
				zone_BG.graphics.beginFill(FColor.RGBtoHEX(255, 255 * mod, 255 * mod));
				
				zone_BG.graphics.drawRect(0, 0, FG.width, FG.height);
				zone_BG.graphics.endFill();
			}
		}

		private function gameOver():void
		{
			FG.soundEngine.Play(new S_roundOver());
			FG.SwitchScene(new MainMenu());
		}

		private function newRound():void
		{
			// New round
			roundNum++;

			placeButtons();

			//enemies.Destroy();

			var dist:Number;
			var numToAdd:int = enemies.length + 5;
			for(var i:int = enemies.length; i < numToAdd; i++)
			{
				dist = noise(i*0.01);
				enemies.Add(new Debris(randColor(i*0.0075), randColor(i*0.0075 + 2), randColor(i*0.0075 + 4), dist));
			}
			
			// New button location for next round
			useCenterButton = !useCenterButton;
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
				centerButton.pointToCheck = player.collision.p;
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
				leftButton.pointToCheck = player.collision.p;
				Add(leftButton);

				rightButton = new FRectButton(FG.width - buttonWidth, 0, buttonWidth, FG.height);
				rightButton.onOver = newRound;
				rightButton.pointToCheck = player.collision.p;
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