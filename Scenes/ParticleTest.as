package Vortex.Scenes
{

	import Framework.FG;

	// Particle things
	import Framework.FEmitter;
	import Vortex.Particles.Confetti;
	import Framework.Maths.FVec;

	import Vortex.Scenes.MainMenu;

	public class ParticleTest extends GeneralScene
	{

		private var a:FEmitter;

		public function ParticleTest():void
		{
			super();
		}

		override public function Create():void
		{
			super.Create();

			a = new FEmitter();
			a.y = -10;
			Add(a);
			a.SetYSpeed(-5, 5);
			a.SetXSpeed(-5, 5);
			a.SetDrag(2, 0);
			a.SetTopSpeed(100, 5);
			a.acceleration = new FVec(0, 40);
			a.Make(Confetti);
			a.SetSize(FG.width);
			a.Start(FEmitter.CONSTANT, 3);
		}

		override public function Update():void
		{
			super.Update();


			if(FG.mouse.justPressed())
			{
				a.x = FG.mouse.x;
				a.y = FG.mouse.y;
				a.Start();
			}
			a.UpdateParticleLocations();
		}
	}
}