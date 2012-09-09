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
	import Framework.Utils.FInterpolator;

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

		private var b_newHighScore:Boolean;

		private var t_HighScore:FText;
		private var t_HighScoreReadout:FText;
		private var hScoreInterpolator:FInterpolator;
		private var t_RecentScore:FText;
		private var t_RecentScoreReadout:FText;

		public function RoundOver():void
		{
			super();
		}

		override public function Create():void
		{
			super.Create();

			b_newHighScore = (Global.recentScore > Global.highScore);

			hScoreInterpolator = new FInterpolator(1, 1);
			hScoreInterpolator.AddValue(0.5, 2);
			hScoreInterpolator.ChangeMethod(FInterpolator.SINE);

			addGUI();

			Global.hasPlayed = true;

			if(b_newHighScore)
			{
				Global.highScore = Global.recentScore;

				celebrate();
			}
			else
			{
				FG.soundEngine.Play(new S_roundOver());
			}

			Global.Save();
		}

		override public function Update():void
		{
			super.Update();

			if(b_newHighScore)
			{
				t_HighScoreReadout.scaleX = t_HighScoreReadout.scaleY = hScoreInterpolator.GetValue((t_HighScoreReadout.timeLived % 2) * 0.5);
			}
		}

		// New high score, hooray!
		private function celebrate():void
		{
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
				confettiEmitter.Start(FEmitter.CONSTANT, 3, 0, 0.025);

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

		private function addGUI():void
		{
			var b:FCircleButton = new FCircleButton(0, 0, "Start Game", startGame);
			b.CenterX().CenterY();
			Add(b);

			t_HighScore = new FText(FG.width / 4, FG.height/4, "High Score:");
			t_HighScore.textAlign = FText.ALIGN_CENTER;
			if(b_newHighScore)
			{
				t_HighScore.UpdateText("New High Score:");
				t_HighScore.size = 32
			}
			else
			{
				t_HighScore.size = 18;
			}
			t_HighScore.UpdateFormat();
			t_HighScore.CenterText();
			Add(t_HighScore);

			t_HighScoreReadout = new FText(FG.width/4, FG.height/4 + 25, String(Global.highScore));
			t_HighScoreReadout.textAlign = FText.ALIGN_CENTER;
			t_HighScoreReadout.size = 24;
			if(b_newHighScore)
			{
				t_HighScoreReadout.UpdateText(String(Global.recentScore));
				t_HighScoreReadout.y += 20;
				t_HighScoreReadout.size = 50;
			}
			else
			{
				t_HighScoreReadout.size = 24;
			}
			t_HighScoreReadout.UpdateFormat();
			t_HighScoreReadout.CenterText();
			Add(t_HighScoreReadout);

			t_RecentScore = new FText(FG.width - (FG.width / 4), FG.height/4, "Last Score:");
			t_RecentScore.textAlign = FText.ALIGN_CENTER;
			if(b_newHighScore)
			{
				t_RecentScore.UpdateText("Old High Score:");
				t_RecentScore.size = 24;
			}
			else
			{
				t_RecentScore.size = 18;
			}
			t_RecentScore.UpdateFormat();
			t_RecentScore.CenterText();
			Add(t_RecentScore);

			t_RecentScoreReadout = new FText(FG.width - (FG.width / 4), FG.height/4 + 25, String(Global.recentScore));
			t_RecentScoreReadout.textAlign = FText.ALIGN_CENTER;
			if(b_newHighScore)
			{
				t_RecentScoreReadout.UpdateText(String(Global.highScore));
				t_RecentScoreReadout.y += 20;
				t_RecentScoreReadout.size = 32;
			}
			else
			{
				t_RecentScoreReadout.size = 24;
			}
			t_RecentScoreReadout.UpdateFormat();
			t_RecentScoreReadout.CenterText();
			Add(t_RecentScoreReadout);
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
	}
}