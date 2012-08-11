package Vortex.Scenes
{

	import Framework.FG;
	import Framework.FScene;
	import Framework.FObject;
	import Framework.FGroup;

	import Framework.GUI.FText;

	import Framework.Utils.FArray;

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

			// Set up framerate display
			framerate = new FText(0, 0, "30.00");
			avgFramerate = new Array();
			frames = 5;
			framerate.x = FG.width - framerate.width;
			framerate.y = FG.height - framerate.height;
			zone_GUI.Add(framerate);
		}

		override public function Update():void
		{
			super.Update();

			avgFramerate[_curFrame++%frames] = FG.framerate;

			// Update framerate display
			framerate.UpdateText(FArray.Average(avgFramerate).toFixed(2));
		}
	} 
}