package Vortex
{
	import Framework.Shapes.FCircle;
	import Framework.FSprite;
	import Framework.FG;
	import Framework.FEmitter;

	import Framework.Utils.FColor;
	import Framework.Utils.FInterpolator;

	import Framework.Maths.FMath;
	import Framework.Maths.FEasing;

	import Vortex.Particles.PlanetDebris;

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

		private var growth:FInterpolator;

		public var isColliding:Boolean;

		private var lineColor:Number, color:Number;

		public function Debris(r:int, g:int, b:int, Dist:Number):void
		{
			dist = (Dist * 150) + 100;
			
			super();

			color = FColor.RGBtoHEX(r,g,b);
			lineColor = FColor.RGBtoHEX(r * 0.45,g * 0.45,b * 0.45);
		}

		override public function Create():void
		{
			super.Create();

			var maxRadius:int = 5;
			radius = Math.round(Math.random() * (maxRadius - 3) + 3);

			//dist = Math.round(Math.random() * 150 + 100);
			speed = Math.random() * 0.35 + 0.125;
			angle = Math.random() * 360;
			explodeVelocity = Math.random() * 10 + 5;

			curRadius = 0.0;

			growth = new FInterpolator();
			growth.AddValue(0.75, 0.75);
			growth.AddValue(0.5, 1.5);
			growth.ChangeMethod(FInterpolator.SPLINE);

			var a:Number = FMath.DegreesToRadians(angle);
			x = (Math.cos(a) * dist) + FG.width/2;
			y = (Math.sin(a) * dist) + FG.height/2;

			collision = new FCircle(x, y, radius);
		}

		override public function Destroy():void
		{
			super.Destroy();

			growth = null;
		}

		override public function Update():void
		{
			angle = (angle + speed) % 360;

			var a:Number = FMath.DegreesToRadians(angle);
			x = (Math.cos(a) * dist) + FG.width/2;
			y = (Math.sin(a) * dist) + FG.height/2;

			super.Update();
		}

		override public function Draw():void
		{
			if(timeLived < 0.25)
				curRadius = FEasing.ElasticOut(timeLived/0.25, 0, radius);
			else
				curRadius = radius;
				//curRadius = growth.GetValue(timeLived/0.15) * radius;

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
			if(!explode)
			{
				explode = true;
				isColliding = true;
				FG.soundEngine.Play(new S_explosion());

				graphics.clear();
				draws = false;

				// Particle effect time!
				var e:FEmitter = new FEmitter();
				FG._scene.Add(e);
				e.SetXSpeed(-5, 5);
				e.SetYSpeed(-5, 5);
				e.SetTopSpeed(5, 5);
				e.SetAcceleration(0,0);
				e.SetDrag(0,0);
				e.x = x;
				e.y = y;
				e.Make(PlanetDebris, radius * 2 + 2);
				e.Start();
			}
		}
	}
}