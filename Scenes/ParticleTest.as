package Vortex.Scenes
{

	import Framework.FG;

	// Particle things
	import Framework.FEmitter;
	import Vortex.Particles.Confetti;

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
			Add(a);
			a.SetYSpeed(-20, 10);
			a.Make(Confetti);
			a.SetSize(FG.width);
			a.Start(FEmitter.CONSTANT);
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