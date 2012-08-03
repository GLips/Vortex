package Vortex.Scenes
{

	import Vortex.Scenes.GeneralScene;
	import Vortex.Scenes.About;
	import Vortex.Scenes.Game;

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
			b.CenterX().CenterY();
			Add(b);

			var a:FCircleButton = new FCircleButton(0, 0, "About", aboutMenu);
			a.CenterX().CenterY(100);
			a.y = FG.height/2 - a.height/2 + 100;
			Add(a);
		}

		protected function startGame():void
		{
			FG.SwitchScene(new Game());
		}

		protected function aboutMenu():void
		{
			FG.SwitchScene(new About());
		}

		/*override public function Update():void
		{
			super.Update();
		}*/
	}
}