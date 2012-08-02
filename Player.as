package Vortex
{

	import Framework.FG;
	import Framework.FSprite;

	import Framework.Shapes.FCircle;

	import Framework.Maths.FVec;
	import Framework.Maths.FPoint;

	public class Player extends FSprite
	{

		public var collision:FCircle;
		private var radius:int;
		private var moveSpeed:int;

		public function Player()
		{
			super(FG.mouse.x, FG.mouse.y);
		}

		override public function Create():void
		{
			radius = 2;
			moveSpeed = 20;
			collision = new FCircle(x, y, radius);
		}

		override public function Update():void
		{
			var temp:FVec = new FVec(FG.mouse.x - x - (radius/2), FG.mouse.y - y - (radius/2));
			
			// Enforce the player speed limit
			if(temp.Mag() > moveSpeed)
			{
				temp.Normalize();
				temp.Mult(moveSpeed);
			}

			// Update collision model and the location
			collision.p.x = x += temp.x;
			collision.p.y = y += temp.y;
		}

		override public function Draw():void
		{
			graphics.clear();
			graphics.beginFill(0,0.5);
			graphics.drawCircle(0,0,radius);
			graphics.endFill();
			draws = false;
		}
	}
}