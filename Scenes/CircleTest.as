package Vortex.Scenes
{

	import Framework.FScene;
	import Framework.FG;
	import Framework.Shapes.FCircle;
	import Framework.Utils.FCollide;

	public class CircleTest extends FScene
	{

		public var circRad:int = 100;
		public var mouseRad:int = 5;

		public function CircleTest()
		{
			super();
		}

		override public function Draw():void
		{
			graphics.clear();

			if(FCollide.CircleCircle(new FCircle(FG.width/2, FG.height/2, circRad), new FCircle(FG.mouse.x, FG.mouse.y, mouseRad)))
			{
				graphics.beginFill(0x00AA00);
			}
			else
			{
				graphics.beginFill(0xAA0000);
			}

			graphics.drawCircle(FG.width/2, FG.height/2, circRad)
			graphics.endFill();

			graphics.beginFill(0);
			graphics.drawCircle(FG.mouse.x, FG.mouse.y, mouseRad);
			graphics.endFill();
		}
	}
}