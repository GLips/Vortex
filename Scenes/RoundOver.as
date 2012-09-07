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
	import Framework.Utils.FTimer;

	import Vortex.Global;

	public class RoundOver extends GeneralScene
	{
		[Embed(source="../Sounds/explosion.mp3")]
		public var S_cannon:Class;
		[Embed(source="../Sounds/cheers.mp3")]
		public var S_cheers:Class;
		[Embed(source="../Sounds/roundOver.mp3")]
        public var S_roundOver:Class;

		private var rightCannon:FEmitter;
		private var leftCannon:FEmitter;
		private var confettiEmitter:FEmitter;

		public function RoundOver():void
		{
			super();
		}

		override public function Create():void
		{
			super.Create();

			if(Global.recentScore > Global.highScore)
			{
				Global.highScore = Global.recentScore;

				FG.soundEngine.Play(new S_cheers());

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
				confettiEmitter.Start(FEmitter.CONSTANT, 3, 0, 0.05);

				rightCannon = new FEmitter();
				rightCannon.x = FG.width + 10;
				rightCannon.y = FG.height + 10;
				rightCannon.SetYSpeed(-15, -30);
				rightCannon.SetXSpeed(-2, -12);
				rightCannon.SetDrag(2, 0);
				rightCannon.SetAcceleration(0, 40);
				rightCannon.Make(Confetti, 50);
				Add(rightCannon);

				leftCannon = new FEmitter();
				leftCannon.x = -10;
				leftCannon.y = FG.height + 10;
				leftCannon.SetYSpeed(-15, -30);
				leftCannon.SetXSpeed(2, 12);
				leftCannon.SetDrag(2, 0);
				leftCannon.SetAcceleration(0, 40);
				leftCannon.Make(Confetti, 50);
				Add(leftCannon);

				var t:FTimer = new FTimer(0.5, launchCannons);
				Add(t);
			}
			else
			{
				FG.soundEngine.Play(new S_roundOver());
			}

			var b:FCircleButton = new FCircleButton(0, 0, "Start Game", startGame);
			b.CenterX().CenterY();
			Add(b);

			var hS:FText = new FText(FG.width / 4, FG.height/4, "High Score:");
			hS.textAlign = FText.ALIGN_CENTER;
			hS.size = 18;
			hS.UpdateFormat();
			hS.CenterText();
			Add(hS);

			var s:FText = new FText(FG.width/4, FG.height/4 + 25, String(Global.highScore));
			s.textAlign = FText.ALIGN_CENTER;
			s.size = 24;
			s.UpdateFormat();
			s.CenterText();
			Add(s);

			var rS:FText = new FText(FG.width - (FG.width / 4), FG.height/4, "Last Score:");
			rS.textAlign = FText.ALIGN_CENTER;
			rS.size = 18;
			rS.UpdateFormat();
			rS.CenterText();
			Add(rS);

			s = new FText(FG.width - (FG.width / 4), FG.height/4 + 25, String(Global.recentScore));
			s.textAlign = FText.ALIGN_CENTER;
			s.size = 24;
			s.UpdateFormat();
			s.CenterText();
			Add(s);
		}

		private function launchCannons():void
		{
			FG.soundEngine.Play(new S_cannon());

			rightCannon.Start(FEmitter.EXPLODE, 3);
			leftCannon.Start(FEmitter.EXPLODE, 3);
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