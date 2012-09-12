package Vortex
{
	import flash.display.Sprite;
	import flash.display.Graphics;

	import flash.utils.getTimer;

	import Framework.FG;
	import Framework.FGame;
	import Framework.Utils.FInternet;

	import Vortex.Scenes.*;
	import Vortex.Preloader;

	[SWF(width='640',height='480',backgroundColor='#333333',frameRate='60')]
	[Frame(factoryClass="Vortex.Preloader")]

	public class Main extends FGame
	{

		public function Main():void
		{
			FG.gameURL = "www.ironswine.com/play/270/Vortex";
			FG.gameName = "Vortex";

			allowedURLs = new Array("ironswine.com", "fgl.com", "flashgamelicense.com", "encodable.com");

			super(this, 640, 480, MainMenu);
		}
	}

}