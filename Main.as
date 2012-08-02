package Vortex
{
	import flash.display.Sprite;
	import flash.display.Graphics;

	import flash.utils.getTimer;

	import Framework.*;

	[SWF(width='800',height='600',backgroundColor='#ffffff',frameRate='30')]

	public class Main extends FGame
	{

		public function Main():void
		{
			super(this, 800, 600, MainMenu);
		}
	}

}