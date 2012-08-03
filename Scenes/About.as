package Vortex.Scenes
{

	import Framework.FG;
	import Framework.GUI.Buttons.FCircleButton;

	import Vortex.Scenes.MainMenu;

	public class About extends GeneralScene
	{
		public function About():void
		{
			super();
		}

		override public function Create():void
		{
			super.Create();

			var a:FCircleButton = new FCircleButton(0, 0, "Back", goBack);
			a.x = a.radius + 10;
			a.y = FG.height - a.radius - 10;
			Add(a);
		}

		protected function goBack():void
		{
			FG.SwitchScene(new MainMenu());
		}
	}
}