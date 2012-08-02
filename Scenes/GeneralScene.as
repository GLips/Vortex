package Vortex.Scenes
{

	import Framework.FG;
	import Framework.FScene;

	import Framework.GUI.FText;

	public class GeneralScene extends FScene
	{
		// Framerate readout text
		protected var framerate:FText;

		public function GeneralScene()
		{
			super();
		}

		override public function Create():void
		{
			super.Create();

			// Set up framerate display
			framerate = new FText(0, 0, FG.framerate.toFixed(2));
			framerate.x = FG.width - framerate.width;
			framerate.y = FG.height - framerate.height;
			Add(framerate);
		}

		override public function Update():void
		{
			super.Update();

			// Update framerate display
			framerate.UpdateText(FG.framerate.toFixed(2));
		}
	} 
}