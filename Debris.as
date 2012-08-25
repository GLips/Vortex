package Vortex
{
	import Framework.Shapes.FCircle;
	import Framework.FSprite;
	import Framework.FG;

	import Framework.Utils.FColor;

	import Framework.Maths.FMath;

	public class Debris extends FSprite
	{

		private var curRadius:Number;
		public var radius:int;
		public var dist:int;
		private var speed:Number;
		private var angle:Number;
		private var explodeVelocity:Number;

		public var explode:Boolean;

		// Sound!
		[Embed(source="Sounds/explosion.mp3")]
		public var S_explosion:Class;

		public var collision:FCircle;

		public var isColliding:Boolean;

		private var lineColor:Number, color:Number;

		public function Debris(r:int, g:int, b:int, Dist:Number):void
		{
			super();

			color = FColor.RGBtoHEX(r,g,b);
			lineColor = FColor.RGBtoHEX(r * 0.45,g * 0.45,b * 0.45);
		}

		override public function Create():void
		{
			var maxRadius:int = 5;
			radius = Math.round(Math.random() * (maxRadius - 3) + 3);

			dist = Math.round(Math.random() * 150 + 100);
			speed = Math.random() * 0.35 + 0.125;
			angle = Math.random() * 360;
			explodeVelocity = Math.random() * 10 + 5;

			curRadius = 0.5;

			var a:Number = FMath.DegreesToRadians(angle);
			x = (Math.cos(a) * dist) + FG.width/2;
			y = (Math.sin(a) * dist) + FG.height/2;

			collision = new FCircle(x, y, radius);
		}

		override public function Update():void
		{
			angle = (angle + speed) % 360;

			if(explode)
				dist += explodeVelocity;

			var a:Number = FMath.DegreesToRadians(angle);
			collision.p.x = x = (Math.cos(a) * dist) + FG.width/2;
			collision.p.y = y = (Math.sin(a) * dist) + FG.height/2;
		}

		override public function Draw():void
		{
			if(curRadius < radius)
				curRadius += 0.5;

			graphics.clear();
			if(isColliding)
			{
				graphics.beginFill(0xFF0000);
			}
			else
			{
				graphics.beginFill(color);
			}
			graphics.lineStyle(1, lineColor);
			graphics.drawCircle(0, 0, Math.round(curRadius - 1));
			graphics.endFill();
		}

		public function Explode():void
		{
			explode = true;
			isColliding = true;
			FG.soundEngine.Play(new S_explosion());
		}
	}
}