package Vortex
{
	import flash.display.Sprite;
	import flash.display.Graphics;

	import flash.utils.getTimer;

	import Framework.*;

	[SWF(width='640',height='480',backgroundColor='#ffffff',frameRate='30')]

	public class Main extends FGame
	{

		public function Main():void
		{
			super(this, 640, 480, MainMenu);
		}
	}

}