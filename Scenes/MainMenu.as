package Vortex.Scenes
{

	// Framework imports
	import Framework.GUI.FText;
	import Framework.GUI.Buttons.FCircleButton;
	import Framework.GUI.Buttons.FRectButton;

	import Framework.FG;
	import Framework.FScene;

	import Framework.Shapes.FRect;

	import Framework.Utils.FCollide;
	import Framework.Utils.FNoise;

	import Framework.Maths.FEasing;

	// Vortex imports
	import Vortex.Debris;

	import Vortex.Scenes.GeneralScene;
	import Vortex.Scenes.About;
	import Vortex.Scenes.Game;
	import Vortex.Scenes.ParticleTest;

	public class MainMenu extends GeneralScene
	{
		private var numToAdd:int;

		[Embed(source="../Sounds/popIn_05.mp3")]
        public var s_popIn:Class;

        private var offset:Number;

		public function MainMenu():void
		{
			super();
		}

		override public function Create():void
		{
			super.Create();

			//FG.soundEngine.muted = true;

			offset = Math.random() * 9999;

			var b:FCircleButton = new FCircleButton(0, 0, "Start Game", startGame);
			b.CenterX().CenterY();
			Add(b);

			numToAdd = 100;
			spawnIn();

			var vortexText:FText = new FText(0, 20, "Vortex");
			zone_GUI.Add(vortexText);
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

		override public function Update():void
		{
			super.Update();

			//if(numToAdd > 0)
			if(Math.random() * timeLived > 0.10 && numToAdd > 0)
				spawnIn();
		}
		
		private function spawnIn():void
		{
			var dist:Number;
			var seed:Number;
			for(var i:int = 0; i < getNumToAdd(); i++)
			{
				seed = (zone_Game.length * 0.01) + offset;
				dist = noise(seed);
				Add(new Debris(randColor(seed + 100), randColor(seed + 200), randColor(seed + 300), dist));
				numToAdd--;
			}
			FG.soundEngine.Play(new s_popIn());
		}

		private function getNumToAdd():int
		{
			return Math.round(Math.random() * (timeLived * 15))
			//return 3;
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
			return Math.abs(FNoise.noise(x));
		}
	}
}