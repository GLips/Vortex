package Vortex
{
	import flash.display.Sprite;
	import flash.display.Graphics;

	import flash.utils.getTimer;

	import Framework.FGame;
	import Framework.Utils.FInternet;

	import Vortex.Scenes.*;

	[SWF(width='640',height='480',backgroundColor='#333333',frameRate='60')]

	public class Main extends FGame
	{

		public function Main():void
		{
			var c:Class;

			if(FInternet.ValidURL(this, "dropbox.com", true))
				c = MainMenu;
			else
				c = InterpolatorTest;

			super(this, 640, 480, c);
		}
	}

}