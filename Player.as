package Vortex
{

	import Framework.FG;
	import Framework.FSprite;

	import Framework.Shapes.FCircle;

	import Framework.Maths.FVec;

	public class Player extends FSprite
	{

		public var collision:FCircle;
		private var radius:int;

		public function Player()
		{
			super(FG.mouse.x, FG.mouse.y);
			radius = 3;
		}

		override public function Create():void
		{
			collision = new FCircle(x, y, radius);
		}

		override public function Update():void
		{
			var temp:FVec = new FVec(new FPoint(x, y), new FPoint(FG.mouse.x, FG.mouse.y));
			x = FG.mouse.x - x;
			y = FG.mouse.y - y;

			collision.p.x = x;
			collision.p.y = y;
		}

		override public function Draw():void
		{
			graphics.clear();
			graphics.beginFill(0);
			graphics.drawCircle(0,0,radius);
			graphics.endFill();
			draws = false;
		}
	}
}