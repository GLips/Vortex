package Vortex.Scenes
{

	import Framework.FScene;
	import Framework.GUI.FButton;
	import Framework.GUI.FText;

	import Framework.FG;
	import Framework.FGroup;

	import Framework.Shapes.FRect;

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
		protected var numEnemies:int;
		protected var player:Player;

		protected var bd:BitmapData;
		protected var b:Bitmap;

		public function Game():void
		{
			super();
		}

		override public function Create():void
		{
			super.Create();

			enemies = new FGroup();
			Add(enemies);

			numEnemies = 100;

			player = new Player();
			Add(player);

			var c:Number;
			var dist:Number;
			for(var i:int = 0; i < numEnemies; i++)
			{
				c = FColor.RGBtoHEX(randColor(i*0.01), randColor(i*0.01 + 2), randColor(i*0.025 + 4));
				dist = noise(i*0.01);
				enemies.Add(new Debris(c,dist));
			}
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