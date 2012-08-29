package Vortex
{

	import Framework.FG;
	import Framework.FSprite;

	import Framework.Shapes.FCircle;

	import Framework.Maths.FVec;
	import Framework.Maths.FPoint;
	import Framework.Maths.FMath;

	public class Player extends FSprite
	{

		private var radius:int;
		private var moveSpeed:int;

		public function Player()
		{
			super(FG.mouse.x, FG.mouse.y);
		}

		override public function Create():void
		{
			super.Create();

			radius = 2;
			moveSpeed = 30;
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

			// Rotation calculation
			var adj:Number = FG.mouse.x - x;
			var opp:Number = FG.mouse.y - y;
			var rot:Number = FMath.RadiansToDegrees(Math.atan(opp / adj));

			rotation = rot;

			// Velocity squish!
			scaleX = 1 + Math.abs(temp.x/(moveSpeed/4));
			scaleY = 1 - Math.abs(temp.x/(moveSpeed*2));

			// Update collision model and the location
			x += temp.x;
			y += temp.y;

			super.Update();
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