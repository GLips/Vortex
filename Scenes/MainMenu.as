package Vortex.Scenes
{

	import Framework.FScene;
	import Framework.GUI.FText;
	import Framework.GUI.Buttons.FCircleButton;

	import Framework.FG;

	import Framework.Shapes.FRect;
	import Framework.Utils.FCollide;

	public class MainMenu extends GeneralScene
	{

		public function MainMenu():void
		{
			super();
		}

		override public function Create():void
		{
			super.Create();

			var b:FCircleButton = new FCircleButton(0, 0, "Start Game");
			b.onOver = startGame;
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
		}
	}
}