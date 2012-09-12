package Vortex.Scenes
{

	import Framework.FG;
	import Framework.FScene;
	import Framework.FObject;
	import Framework.FGroup;

	import Framework.GUI.FText;

	import Framework.Utils.FArray;
	import Framework.Utils.FInternet;
	
	import Framework.Maths.FEasing;

	public class GeneralScene extends FScene
	{
		// Framerate readout variables
		protected var framerate:FText;
		protected var avgFramerate:Array;
		protected var frames:int;			// Total frames to average (10)
		protected var _curFrame:int;		// Next frame to write

		public function GeneralScene()
		{
			super();
		}

		override public function Create():void
		{
			super.Create();

			graphics.beginFill(0xFFFFFF);
			graphics.drawRect(0, 0, FG.width, FG.height);
			graphics.endFill();

			// Set up framerate display
			/*
			framerate = new FText(0, 0, "60.00");
			avgFramerate = new Array();
			frames = 5;
			framerate.x = FG.width - framerate.width;
			framerate.y = FG.height - framerate.height;
			zone_GUI.Add(framerate);
			*/
		}

		override public function Update():void
		{
			super.Update();

			//avgFramerate[_curFrame++%frames] = FG.framerate;

			// Update framerate display
			//framerate.UpdateText(FArray.Average(avgFramerate).toFixed(2));
		}

		protected function goToIronswine():void
		{
			FInternet.GoToURL("http://www.google.com");
		}

		protected function transition(oldScene:FScene, newScene:FScene, loc:Number):void
		{
			newScene.paused = false;
			loc = 1 - loc;
			oldScene.alpha = FEasing.QuadIn(loc, 1, 0);
			newScene.alpha = FEasing.QuadOut(loc, 0, 1);
		}
	}
}