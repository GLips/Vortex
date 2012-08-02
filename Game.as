package Vortex
{

	import Framework.FScene;
	import Framework.GUI.FButton;
	import Framework.GUI.FText;

	import Framework.FG;

	import Framework.Shapes.FRect;
	import Framework.Utils.FCollide;

	import Framework.Utils.FNoise;

	public class Game extends FScene
	{

		protected var framerate:FText;

		public function Game():void
		{
			framerate = new FText(FG.width - 25, 10, String(FG.framerate));
			Add(framerate);

			trace(FNoise.noise(1, 1, 2));
		}

		override public function Update():void
		{
			framerate.UpdateText(String(FG.framerate));
		}
	}
}