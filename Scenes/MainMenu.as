package Vortex.Scenes
{

	import Vortex.Scenes.GeneralScene;
	import Vortex.Scenes.About;
	import Vortex.Scenes.Game;
	import Vortex.Scenes.ParticleTest;

	import Framework.GUI.FText;
	import Framework.GUI.Buttons.FCircleButton;
	import Framework.GUI.Buttons.FRectButton;

	import Framework.FG;

	import Framework.Shapes.FRect;

	import Framework.Utils.FCollide;
	import Framework.Utils.FNoise;

	import Vortex.Debris;

	public class MainMenu extends GeneralScene
	{

		public function MainMenu():void
		{
			super();
		}

		override public function Create():void
		{
			super.Create();

			var b:FCircleButton = new FCircleButton(0, 0, "Start Game", startGame);
			b.CenterX().CenterY();
			Add(b);

			var dist:Number;
			var numToAdd:int = 100;
			for(var i:int = 0; i < numToAdd; i++)
			{
				dist = noise(i*0.01);
				Add(new Debris(randColor(i*0.0075), randColor(i*0.0075 + 2), randColor(i*0.0075 + 4), dist));
			}

			var vortexText:FText = new FText(0, 20, "Vortex");
			Add(vortexText);
			vortexText.size = 72;
			vortexText.UpdateFormat();
			vortexText.CenterX();

			/*
			var a:FCircleButton = new FCircleButton(0, 0, "About", aboutMenu);
			a.CenterX().CenterY(100);
			a.y = FG.height/2 - a.height/2 + 100;
			Add(a);
			*/
		}

		protected function startGame():void
		{
			FG.SwitchScene(new Game());
		}

		protected function aboutMenu():void
		{
			FG.SwitchScene(new About());
		}

		private function randColor(x:Number):int
		{
			return Math.round(noise(x) * 230) + 25;
		}

		private function noise(x:Number):Number
		{
			return FNoise.noise(x,x,x);
		}

		/*override public function Update():void
		{
			super.Update();
		}*/
	}
}