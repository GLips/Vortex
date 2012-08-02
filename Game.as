package Vortex
{

	import Framework.FScene;
	import Framework.GUI.FButton;
	import Framework.GUI.FText;

	import Framework.FG;

	import Framework.Shapes.FRect;
	import Framework.Utils.FCollide;

	import Framework.Utils.FNoise;
	import Framework.Utils.FColor;

	public class Game extends FScene
	{

		protected var framerate:FText;

		public function Game():void
		{
			framerate = new FText(FG.width - 25, 10, String(FG.framerate));
			Add(framerate);

			var c:Number;

			for(var i:int = 0; i < 100; i++)
			{
				c = FColor.RGBtoHEX(randColor(i*0.025), randColor(i*0.025 + 2), randColor(i*0.025 + 4));
				Add(new Debris(c));
			}
		}

		override public function Update():void
		{
			super.Update();
			framerate.UpdateText(String(FG.framerate));
		}

		private function randColor(x:Number):int
		{
			return Math.round(FNoise.noise(x,x,x) * 255);
		}
	}
}