package Vortex.Scenes
{

	import Framework.FG;
	import Framework.GUI.Buttons.FCircleButton;

	import Framework.FEmitter;
	import Framework.FParticle;

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
			a.SetYSpeed(-25, 0);
			a.Make();
			//a.SetSize(FG.width);
			a.Start();

			var b:FParticle = new FParticle();
			b.x = b.y = 100;
			Add(b);
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