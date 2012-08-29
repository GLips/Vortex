package Vortex.Scenes
{

	// Vortex Imports
	import Vortex.Scenes.GeneralScene;
	import Vortex.Scenes.About;
	import Vortex.Scenes.Game;

	import Vortex.Particles.Confetti;

	// Framework Imports
	import Framework.GUI.FText;
	import Framework.GUI.Buttons.FCircleButton;
	import Framework.GUI.Buttons.FRectButton;

	import Framework.FG;
	import Framework.FEmitter;

	import Framework.Maths.FVec;

	import Framework.Shapes.FRect;
	import Framework.Utils.FCollide;

	public class RoundOver extends GeneralScene
	{

		private var confettiEmitter:FEmitter;

		public function RoundOver():void
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

			confettiEmitter = new FEmitter();
			confettiEmitter.y = -10;
			Add(confettiEmitter);
			confettiEmitter.SetYSpeed(-5, 5);
			confettiEmitter.SetXSpeed(-5, 5);
			confettiEmitter.SetDrag(2, 0);
			confettiEmitter.SetTopSpeed(100, 5);
			confettiEmitter.acceleration = new FVec(0, 40);
			confettiEmitter.Make(Confetti, 150);
			confettiEmitter.SetSize(FG.width);
			confettiEmitter.Start(FEmitter.CONSTANT, 3, 0, 0.025);
		}

		protected function startGame():void
		{
			FG.SwitchScene(new Game());
		}

		/*override public function Update():void
		{
			super.Update();
		}*/
	}
}