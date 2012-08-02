package Vortex
{

	import Framework.FScene;
	import Framework.GUI.FButton;
	import Framework.GUI.FText;

	import Framework.FG;

	import Framework.Shapes.FRect;
	import Framework.Utils.FCollide;

	public class MainMenu extends FScene
	{

		protected var framerate:FText;

		public function MainMenu():void
		{
			framerate = new FText(FG.width - 25, 10, String(FG.framerate));
			Add(framerate);

			var b:FButton = new FButton(0, 0, "Start Game", startGame);
			b.x = FG.width/2 - b.width/2;
			b.y = FG.height/2 - b.height/2;
			Add(b);
		}

		public function startGame():void
		{
			FG.SwitchScene(new Game());
		}

		override public function Update():void
		{
			super.Update();

			framerate.UpdateText(String(FG.framerate));
		}
	}
}