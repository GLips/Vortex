package Vortex
{
	import Framework.Shapes.FCircle;
	import Framework.FSprite;
	import Framework.FG;

	import Framework.Maths.FMath;

	public class Debris extends FSprite
	{

		private var color:Number;

		public var radius:int;
		private var dist:int;
		private var speed:Number;
		private var angle:Number;

		public var collision:FCircle;

		public var isColliding:Boolean;

		public function Debris(c:Number, Dist:Number):void
		{
			super();
			color = c;
		}

		override public function Create():void
		{
			var maxRadius:int = 5;
			radius = Math.round(Math.random() * (maxRadius - 2) + 2);

			dist = Math.round(Math.random() * 100 + 100);
			speed = Math.random() * 0.75 + 0.25;
			angle = Math.random() * 360;

			var a:Number = FMath.DegreesToRadians(angle);
			x = (Math.cos(a) * dist) + FG.width/2;
			y = (Math.sin(a) * dist) + FG.height/2;

			collision = new FCircle(x, y, radius);
		}

		override public function Update():void
		{
			angle += speed;

			var a:Number = FMath.DegreesToRadians(angle);
			collision.p.x = x = (Math.cos(a) * dist) + FG.width/2;
			collision.p.y = y = (Math.sin(a) * dist) + FG.height/2;
		}

		override public function Draw():void
		{
			graphics.clear();
			if(isColliding)
			{
				graphics.beginFill(0xFF0000);
			}
			else
			{
				graphics.beginFill(color);
			}
			graphics.lineStyle(1);
			graphics.drawCircle(0, 0, radius - 1);
			graphics.endFill();
		}
	}
}