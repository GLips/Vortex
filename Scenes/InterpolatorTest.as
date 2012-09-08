package Vortex.Scenes
{
	import Framework.FG;

	import Framework.Utils.FInterpolator;

	import Framework.Maths.FEasing;

	public class InterpolatorTest extends GeneralScene
	{
		private var interpolator:FInterpolator;

		public function InterpolatorTest():void
		{
			super();
		}

		override public function Create():void
		{
			super.Create();

			interpolator = new FInterpolator();
			interpolator.AddValue(0.25, 1);
			interpolator.AddValue(1, 0.65);
			interpolator.AddValue(0.5, 0.75);
			interpolator.ChangeMethod(FInterpolator.SINE);

			graphics.beginFill(0xFF0000);

			var fineness:int = 64;
			for(var x:int = 0; x < fineness; x++)
			{
				graphics.drawEllipse((FG.width/fineness) * x, interpolator.GetValue(x/fineness) * FG.height, 3, 3);
				//graphics.drawEllipse((FG.width/fineness) * x, FEasing.BounceInOut(x/fineness, 0, FG.height), 3, 3);
			}
			graphics.endFill();
		}
	}
}