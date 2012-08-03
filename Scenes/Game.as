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

	import Framework.Maths.FVec;
	import Framework.Maths.FPoint;

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
		protected var buttonWidth:int;

		// Show center button or edge button?
		protected var useCenterButton:Boolean;

		// Track current round
		protected var roundNum:int;

		public function Game():void
		{
			super();
		}

		override public function Create():void
		{
			super.Create();

			enemies = new FGroup();
			Add(enemies);

			player = new Player();
			Add(player);

			buttonWidth = 20;

			newRound();
		}

		override public function Update():void
		{
			super.Update();

			for each(var e:Debris in enemies.members)
			{
				if(e != null && FCollide.CircleCircle(player.collision, e.collision))
				{
					e.isColliding = true;
					FG.SwitchScene(new MainMenu());
				}
				else
				{
					e.isColliding = false;
				}
			}
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

			var c:Number;
			var dist:Number;
			for(var i:int = 0; i < roundNum * 10; i++)
			{
				c = FColor.RGBtoHEX(randColor(i*0.01), randColor(i*0.01 + 2), randColor(i*0.025 + 4));
				dist = noise(i*0.01);
				enemies.Add(new Debris(c,dist));
			}
			
			// New button location for next round
			useCenterButton = !useCenterButton;
		}

		private function randColor(x:Number):int
		{
			return Math.round(noise(x) * 255);
		}

		private function noise(x:Number):Number
		{
			return FNoise.noise(x,x,x);
		}
	}
}