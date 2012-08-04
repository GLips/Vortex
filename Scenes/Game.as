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

			timeLeft = 60 * 1000;	// 1 minute, measured in MS.
			dtimeLeft = new FText(0, 10, "60.0");
			dtimeLeft.CenterX();
			GUI.Add(dtimeLeft);

			newRound();
		}

		override public function Update():void
		{
			super.Update();

			timeLeft -= FG.dt;
			dtimeLeft.UpdateText( String(FMath.round(timeLeft/1000, 2)) );

			for each(var e:Debris in enemies.members)
			{
				//bd.draw(e);
				if(e != null && FCollide.CircleCircle(player.collision, e.collision))
				{
					e.isColliding = true;
					Add(new FTimer(3, gameOver));
				}
				else
				{
					e.isColliding = false;
				}
			}

			//b = new Bitmap(bd);
		}

		private function gameOver():void
		{
			FG.SwitchScene(new MainMenu());
		}

		private function newRound():void
		{
			// New round
			roundNum++;

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

			enemies.Destroy();

			FNoise.seed = Math.random() * 99999999;
			var dist:Number;
			for(var i:int = 0; i < roundNum * 200; i++)
			{
				dist = noise(i*0.01);
				enemies.Add(new Debris(randColor(i*0.025), randColor(i*0.025 + 2), randColor(i*0.025 + 4), dist));
			}
			
			// New button location for next round
			useCenterButton = !useCenterButton;
		}

		private function randColor(x:Number):int
		{
			return Math.round(noise(x) * 205) + 50;
		}

		private function noise(x:Number):Number
		{
			return FNoise.noise(x,x,x);
		}
	}
}