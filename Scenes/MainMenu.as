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
	import Framework.Utils.FInternet;

	import Framework.Maths.FEasing;

	// Vortex imports
	import Vortex.Debris;
	import Vortex.Global;

	import Vortex.Scenes.GeneralScene;
	import Vortex.Scenes.About;
	import Vortex.Scenes.Game;
	import Vortex.Scenes.ParticleTest;

	import mochi.as3.*;

	public class MainMenu extends GeneralScene
	{
		private var numToAdd:int;

		[Embed(source="../Sounds/popIn_06.mp3")]
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

			Global.Load();

			var b:FCircleButton = new FCircleButton(0, 0, "Start Game", startGame);
			b.CenterX().CenterY();
			Add(b);

			var vortexText:FText = new FText(0, 20, "Vortex");
			zone_GUI.Add(vortexText);
			vortexText.size = 72;
			vortexText.UpdateFormat();
			vortexText.CenterX();

			var a:FRectButton = new FRectButton(0, 0, 150, 40, "Play More Games", goToIronswine);
			a.CenterX().CenterY(100);
			zone_GUI.Add(a);

			a = new FRectButton(0, 0, 150, 40, "Clear Data", Global.Clear);
			a.CenterX().CenterY(150);
			zone_GUI.Add(a);

			numToAdd = 100;
			spawnIn();
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