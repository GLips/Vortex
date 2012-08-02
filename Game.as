package Vortex
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

	public class Game extends FScene
	{

		protected var framerate:FText;

		protected var enemies:FGroup;
		protected var player:Player;

		protected var bd:BitmapData;
		protected var b:Bitmap;

		public function Game():void
		{
			super();
		}

		override public function Create():void
		{
			framerate = new FText(FG.width - 25, 10, String(FG.framerate));
			Add(framerate);

			enemies = new FGroup();
			Add(enemies);
			var c:Number;

			player = new Player();
			Add(player);

			for(var i:int = 0; i < 100; i++)
			{
				c = FColor.RGBtoHEX(randColor(i*0.025), randColor(i*0.025 + 2), randColor(i*0.025 + 4));
				enemies.Add(new Debris(c));
			}

			var d:FVec = new FVec(new FPoint(0,0), new FPoint(6,8));
			trace(d.Mag());
		}

		override public function Update():void
		{
			super.Update();
			framerate.UpdateText(String(FG.framerate));

			for each(var e:Debris in enemies)
			{
				if(FCollide.CircleCircle(player.collision, e.collision))
				{
					FG.SwitchScene(new MainMenu());
				}
			}
		}

		private function randColor(x:Number):int
		{
			return Math.round(FNoise.noise(x,x,x) * 255);
		}
	}
}