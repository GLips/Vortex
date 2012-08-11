package Vortex
{
	import flash.display.Sprite;
	import flash.display.Graphics;

	import flash.utils.getTimer;

	import Framework.*;

	import Vortex.Scenes.*;

	[SWF(width='640',height='480',backgroundColor='#ffffff',frameRate='60')]

	public class Main extends FGame
	{

		public function Main():void
		{
			//super(this, 640, 480, MainMenu);
			super(this, 640, 480, ParticleTest);
		}
	}

}